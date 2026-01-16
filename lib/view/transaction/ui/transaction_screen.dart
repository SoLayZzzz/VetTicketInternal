// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vet_internal_ticket/widgets/bluetooth_device_dialog.dart';
import 'package:vet_internal_ticket/app_image.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/components/text.dart';
import 'package:vet_internal_ticket/services/bluetooth_service.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import 'package:vet_internal_ticket/utils/colors.dart';
import 'package:vet_internal_ticket/utils/dimension.dart';
import 'package:vet_internal_ticket/view/booking/presentation/controller/booking_controller.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../../utils/bottom_sheets/button.dart';
import '../../printer/controller/printer_settingVewModel.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

// final GlobalKey _printKey = GlobalKey();
class _TransactionScreenState extends State<TransactionScreen>
    with WidgetsBindingObserver {
  final BookingController controller = Get.find<BookingController>();
  final GlobalKey _printKey = GlobalKey();
  final GlobalKey _recipKey = GlobalKey();
  final GlobalKey _seatQrKey = GlobalKey();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("🌀 App state changed: $state");
    if (state == AppLifecycleState.resumed) {
      print("✅ App is back to foreground");
    } else if (state == AppLifecycleState.paused) {
      print("⏸️ App is in background");
    } else if (state == AppLifecycleState.inactive) {
      print("⚠️ App is inactive (possibly transitioning)");
    } else if (state == AppLifecycleState.detached) {
      print("❌ App is detached (may be killed)");
    }
  }

  bool _isBluetoothConnected = false;
  bool _loadingBtDevices = false;
  final List<Map<String, dynamic>> _btDevices = [];

  // Show Bluetooth device selection dialog
  Future<void> _showBluetoothDevices() async {
    print('🔵 Starting Bluetooth device scanning...');

    // Check and request Bluetooth permissions
    if (Platform.isAndroid) {
      print('🔵 Requesting Bluetooth scan permission...');
      final status = await Permission.bluetoothScan.request();
      print('🔵 Bluetooth scan permission status: ${status.isGranted}');

      if (!status.isGranted) {
        print('🔴 Bluetooth scan permission denied');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Bluetooth scan permission is required')),
          );
        }
        return;
      }

      print('🔵 Requesting Bluetooth connect permission...');
      final connectStatus = await Permission.bluetoothConnect.request();
      print(
          '🔵 Bluetooth connect permission status: ${connectStatus.isGranted}');

      if (!connectStatus.isGranted) {
        print('🔴 Bluetooth connect permission denied');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Bluetooth connect permission is required')),
          );
        }
        return;
      }

      // For Android 12+, we also need location permission
      print('🔵 Checking location services status...');
      final isLocationEnabled =
          await Permission.locationWhenInUse.serviceStatus.isEnabled;
      print('🔵 Location services enabled: $isLocationEnabled');

      if (!isLocationEnabled) {
        print('🔴 Location services are disabled');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Please enable location services for Bluetooth scanning')),
          );
        }
        return;
      }

      print('🔵 Requesting location permission...');
      final locationStatus = await Permission.locationWhenInUse.request();
      print('🔵 Location permission status: ${locationStatus.isGranted}');

      if (!locationStatus.isGranted) {
        print('🔴 Location permission denied');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Location permission is required for Bluetooth scanning')),
          );
        }
        return;
      }
    }

    print('🔄 Starting Bluetooth device discovery...');
    setState(() {
      _loadingBtDevices = true;
      _btDevices.clear();
    });

    try {
      print('🔄 Starting Bluetooth scan...');
      final subscription = BluetoothService.startScan().listen(
        (device) {
          final deviceName = device['name'] ?? 'Unknown';
          final deviceAddress = device['address'] ?? 'unknown';
          print('📱 Found device: $deviceName ($deviceAddress)');

          if (!_btDevices.any((d) => d['address'] == deviceAddress)) {
            print('➕ Adding device to list: $deviceName');
            setState(() {
              _btDevices.add(device);
            });
          } else {
            print('ℹ️ Device already in list: $deviceName');
          }
        },
        onError: (error) {
          print('🔴 Bluetooth scan error: $error');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bluetooth error: $error')),
            );
          }
        },
        onDone: () {
          print('✅ Bluetooth scan completed');
        },
        cancelOnError: false,
      );

      // Show device selection dialog
      print('🔄 Showing device selection dialog...');
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => BluetoothDeviceDialog(),
      );

      // Clean up
      await subscription.cancel();
      print('🔄 Bluetooth scan canceled');

      if (result == true && mounted) {
        print('✅ Device selected and connected');
        setState(() {
          _isBluetoothConnected = true;
        });
      } else {
        print('❌ No device selected or connection failed');
      }
    } catch (e) {
      print('🔴 Error in Bluetooth scanning: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning for devices: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingBtDevices = false;
        });
      }
      print('🔵 Bluetooth scanning finished');
    }
  }

  // Print receipt via Bluetooth
  Future<void> _printViaBluetooth() async {
    if (!_isBluetoothConnected) {
      await _showBluetoothDevices();
      return;
    }

    // TODO: Generate the receipt data and send it to the printer
    // This is a sample ESC/POS command for text printing
    final List<int> receiptData = [
      0x1B, 0x40, // Initialize printer
      0x1B, 0x61, 0x01, // Center align
      0x1D, 0x21, 0x01, // Double height and width
      ...'=== Receipt ==='.codeUnits,
      0x0A, // New line
      0x1D, 0x21, 0x00, // Normal text
      0x1B, 0x61, 0x00, // Left align
      ...'Thank you for your purchase!'.codeUnits,
      0x0A, 0x0A, // Two new lines
      0x1B, 0x69, // Cut paper
    ];

    try {
      await BluetoothService.sendData(receiptData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt sent to printer')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Print error: $e')),
        );
        // If there's an error, assume we're disconnected
        setState(() {
          _isBluetoothConnected = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Show SnackBar when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        '',
        '',
        borderRadius: 5,
        margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 10),
        padding: EdgeInsets.zero,
        boxShadows: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(2, 2),
            blurRadius: 5,
          )
        ],
        titleText: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.red,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: TextExtraMedium(
                  text: "Printer:",
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppPadding.small),
                child: TextExtraMedium(
                  text: "មិនទាន់ភ្ជាប់ម៉ាស៊ីនព្រីន",
                  color: Colors.redAccent,
                ),
              )
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.white,
      );
      if (mounted) {
        setState(() {
          _loadingBtDevices = false;
        });
      }
    });
  }

  Future<Uint8List> _generatePdf() async {
    final boundary =
        _printKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    final doc = pw.Document();
    final pdfImage = pw.MemoryImage(bytes);

    doc.addPage(pw.Page(
      // Size of paper
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(child: pw.Image(pdfImage));
      },
    ));

    return doc.save();
  }

  /// ✅ Print PDF
  Future<void> _printScreen() async {
    final pdfBytes = await _generatePdf();
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes);
  }

  /// ✅ Generate PDF from a specific RepaintBoundary key
  Future<Uint8List> _generatePdfFrom(GlobalKey key) async {
    final boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Ensure the boundary has painted before capturing
    if (boundary.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    final doc = pw.Document();
    final pdfImage = pw.MemoryImage(bytes);

    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.letter,
      build: (pw.Context context) {
        return pw.Center(child: pw.Image(pdfImage));
      },
    ));

    return doc.save();
  }

  /// ✅ Print from specific widget key
  Future<void> _printFromKey(GlobalKey key) async {
    final pdfBytes = await _generatePdfFrom(key);
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes);
  }

  /// ✅ First print receipt, then continue to print seat QR
  Future<void> _printReceiptThenSeat() async {
    final printer = Get.find<PrinterSettingController>();

    try {
      // Capture with custom options
      Uint8List? bytes = await printer.printer.capture();

      if (bytes == null) throw Exception("Failed to capture seat ");
     // await _showCapturedImageDialog(bytes, 'Unknown');

      printer.startPrint(bytes);


    } catch (e) {
      print('Print sequence error: $e');
    }
  }

  Future<void> _showCapturedImageDialog(Uint8List image, String ticketCode) async {
    await Get.dialog(
      AlertDialog(
        title: Text('Captured Ticket: $ticketCode'),
        content: SizedBox(
          width: 184,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Image Size: ${image.length} bytes'),
                const SizedBox(height: 10),
                Image.memory(image, fit: BoxFit.contain),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  /// ✅ Share PDF (Telegram, etc.)

  Future<void> _sharePdf() async {
    final pdfBytes = await _generatePdf();

    // Get temporary directory
    final dir = await getTemporaryDirectory();

    // Generate file name safely
    final now = DateTime.now();
    final formattedDate =
        "${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}";
    final formattedTime =
        "${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}";
    final fileName = "VET-$formattedDate$formattedTime.pdf";

    final filePath = '${dir.path}/$fileName';

    // Save PDF
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    // Share the file
    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(filePath)]);
  }

  // Open Telegram app
  void _openTelegram() async {
    final Uri telegramUrl = Uri.parse(
      "tg://resolve?domain=telegram",
    ); // replace 'telegram' with username/group
    if (await canLaunchUrl(telegramUrl)) {
      await launchUrl(telegramUrl);
    } else {
      final Uri webUrl = Uri.parse("https://t.me/telegram");
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl);
      } else {
        print("Could not launch Telegram");
      }
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {

    final printer = Get.find<PrinterSettingController>();

    return Scaffold(
        // backgroundColor: AppColors.,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: _trasactionback,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            'បោះបង់',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isBluetoothConnected
                    ? Icons.bluetooth_connected
                    : Icons.bluetooth,
                color: _isBluetoothConnected ? Colors.green : Colors.white,
              ),
              onPressed: _printViaBluetooth,
              tooltip: 'Print via Bluetooth',
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: RepaintBoundary(
            key: _printKey,
            child: WidgetsToImage(
              child: Container(
                color: AppColors.primaryPurple,
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _transactioGo(),
                    SizedBox(
                      height: 20,
                    ),
                    _trasactionback()
                  ],
                )),
              ),
              controller: printer.printer,

            )


          ),
        ),
        bottomNavigationBar: _buttonBottomBar());
  }

  /// ✅ Updated Bottom Buttons: Print & Share
  _buttonBottomBar() {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: BottomAppBar(
        height: Get.height / 5.5,
        color: Colors.white,
        child: Column(
          children: [
            // Printer selection button
            Obx(() => Button(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1.5, color: AppColors.primaryColor),
                  onTap: _printViaBluetooth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.print,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          controller.uiState.value.selectedPrinter.value.isEmpty
                              ? "ជ្រើសរើសម៉ាសុីនព្រីន"
                              : controller.uiState.value.selectedPrinter.value,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 10),
            // Print button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Button(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primaryColor,
                    onTap: () async {

                        await _printReceiptThenSeat();
                       // Get.offAllNamed(AppRoutes.homeScreen);

                    },
                    child:
                        TextSmall(text: "ព្រីន", color: AppColors.whiteColor),
                  ),
                ),
                SizedBox(width: 10),

                // Share to another app
                Expanded(
                  child: Button(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green,
                    // onTap: () async {
                    //   await _sharePdf();
                    // },
                    onTap: _openTelegram,
                    child: TextSmall(
                        text: "ចែករំលែក", color: AppColors.whiteColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  Widget _transactioGo() {
    final ticket =
        controller.state.bookingTransactonModel.value?.body?.ticket?.first;
    if (ticket == null) return SizedBox();

    return Container(
      color: AppColors.primaryPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RepaintBoundary(key: _recipKey, child: _buildRecip(ticket)),
          RepaintBoundary(key: _seatQrKey, child: _buildQRSeat(ticket)),
        ],
      ),
    );
  }

  Widget _trasactionback() {
    final ticketList =
        controller.state.bookingTransactonModel.value?.body?.ticket;
    final ticket =
        (ticketList != null && ticketList.length > 1) ? ticketList[1] : null;
    if (ticket == null) return SizedBox();

    return Container(
      color: AppColors.primaryPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildTitle(ticket),
          // _buildTable(ticket),
          // _buildTableTwo(ticket),
          // _buildDetail(ticket),
          _buildRecip(ticket),
          _buildQRSeat(ticket),
        ],
      ),
    );
  }

  Widget _buildRecip(dynamic ticket) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildTitle(ticket),
            _buildTable(ticket),
            _buildTableTwo(ticket),
            _buildDetail(ticket),
          ],
        ),
      ),
    );
  }

  Widget _buildQRSeat(dynamic ticket) {
    final transactionId =
        controller.state.bookingTransactonModel.value?.body?.transactionId ??
            '';

    final seatLabels =
        (ticket?.seatLabel ?? "").split(",").map((s) => s.trim()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: seatLabels.map<Widget>((seat) {
        final qrDataMap = {
          "invoiceNo": "${transactionId}_$seat",
          "transactionId": transactionId,
          "seatLabel": seat,
          "customer": "Walk In",
          "telephone": ticket?.telephone ?? "",
          "bookingDate": ticket?.bookingDate ?? "",
          "travelDate": ticket?.travelDate ?? "",
          "direction":
              "${ticket?.destinationFrom ?? ""} → ${ticket?.destinationTo ?? ""}",
          "boardingPoint": ticket?.boardingPoint ?? "",
          "dropOffPoint": ticket?.dropOffPoint ?? "",
          "amount": ticket?.seatUnitPrice ?? "",
        };

        // final qrData = qrDataMap.toString();
        final qrData = jsonEncode(qrDataMap);

        print("QR code data: $qrData");

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                            "លេខរៀងវិក្ក័យបត្រ/Invoice No.:", transactionId),
                        _buildInfoRow("ទិសដៅ/Direction:",
                            "${ticket?.destinationFrom} -> ${ticket?.destinationTo}"),
                        _buildInfoRow("លេខកៅអី/Seat No.:", seat),
                        _buildInfoRow("អតិថិជន/Customer:", "Walk In"),
                        _buildInfoRow(
                            "ថ្ងៃទិញ/Issued Date:", ticket?.bookingDate ?? ""),
                        _buildInfoRow("ថ្ងៃធ្វើដំណើរ/Journey Date:",
                            ticket?.travelDate ?? ""),
                      ],
                    ),
                  ),
                  QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 190,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTitle(dynamic ticket) {
    final transaction = controller.state.bookingTransactonModel.value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.large),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Container(
                      height: Get.height / 15,
                      width: Get.width / 7,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppImages.IM_VET_Ticket),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextSmall(
                        text: "វិរៈ ប៊ុនថាំ អេចប្រេស",
                        fontWeight: FontWeight.bold,
                      ),
                      TextSmall(
                        text: "Vireak Buntham Express CO.Ltd",
                        fontWeight: FontWeight.w400,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppPadding.small),
                        child: TextSmall(
                          text: "VATTING: L001-948487373",
                        ),
                      ),
                      TextSmall(
                        text: "ភូមិទី២ ឃុំដងទង់ ស្រុកខេមរភូមិន្ទ ខេត្តកោះកុង",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.small),
              child: _buildRowValueOfTitle("លេខរៀងវិក្ក័យបត្រ/Invoice No.",
                  transaction?.body?.transactionId ?? ""
                  // "${transaction?.body?.transactionId ?? ""}_${ticket?.seatLabel ?? ""}",
                  ),
            ),
            _buildRowValueOfTitle("អតិថិជន/Customer", "walk in"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.small),
              child: _buildRowValueOfTitle(
                "លេខទូរសព្ទ័/Phone number",
                ticket?.telephone ?? "",
              ),
            ),
            _buildRowValueOfTitle(
              "ថ្ងៃទិញ/Issued Date",
              ticket?.bookingDate ?? "",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.small),
              child: _buildRowValueOfTitle(
                "ថ្ងៃធ្វើដំណើរ/Journey Date",
                ticket?.travelDate ?? "",
              ),
            ),
            _buildRowValueOfTitle(
              "ទិសដៅ/Direction",
              "${ticket?.destinationFrom ?? ""} → ${ticket?.destinationTo ?? ""}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowValueOfTitle(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: TextSmall(
              text: label,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        SizedBox(
          width: 10,
          child: TextSmall(
            text: ":",
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextSmall(
              text: value,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(dynamic ticket) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimension.padding10),
      child: Table(
        border: TableBorder.all(color: Colors.black),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
        },
        children: [
          _buildRow([
            'លេខកៅអី\nSeat No.',
            'បរិមាណ\nQTY',
            'តម្លៃឯកតា\nUnit Price',
            'តម្លៃ\nAmount'
          ]),
          _buildRow([
            ticket?.seatLabel ?? "",
            "${ticket?.totalSeat ?? 1}",
            ticket?.seatUnitPrice ?? "",
            ticket?.totalAmount ?? "",
          ]),
        ],
      ),
    );
  }

  Widget _buildTableTwo(dynamic ticket) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimension.padding10),
      child: Table(
        border: TableBorder.all(color: Colors.black),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _buildMergedRow('តម្លៃសរុប/Total', ticket?.totalAmount ?? ""),
          _buildMergedRow('បញ្ចុះតម្លៃ/Discount USD', '0\$'),
          _buildMergedRow(
              'សរុបចុងក្រោយ/Grand Total USD', ticket?.totalAmount ?? ""),
          _buildMergedRow(
              'សរុបចុងក្រោយ/Grand Total Riel', ticket?.totalRiel ?? ""),
        ],
      ),
    );
  }

  TableRow _buildRow(List<String> cells) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      children: cells.asMap().entries.map((entry) {
        final index = entry.key;
        final cell = entry.value;

        final alignment =
            index == 3 ? Alignment.centerRight : Alignment.centerLeft;

        return Container(
          padding: const EdgeInsets.all(8),
          alignment: alignment,
          child: Text(
            cell,
            textAlign: alignment == Alignment.centerLeft
                ? TextAlign.left
                : TextAlign.right,
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        );
      }).toList(),
    );
  }

  TableRow _buildMergedRow(String leftText, String rightText) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: AppPadding.medium),
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: TextExtraSmall(
                text: leftText,
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: TextExtraSmall(
                  text: rightText,
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildDetail(dynamic ticket) {
    // final transaction = controller.state.bookingTransactonModel.value;

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppPadding.medium, horizontal: Dimension.padding10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSmall(
              text:
                  "តម្លៃសំបុត្របូកបញ្ចូលពន្ធអាករលើតម្លៃបន្ថែមរួចជាស្រេច/VAT INCLUDED"),
          TextSmall(text: "អត្រាប្តូរប្រាក់/Exchange Rate: 4,100រ"),
          TextSmall(
              text: "ទីតាំងឡើង & លេខទូរសព្ទ័: ${ticket?.boardingPoint ?? ""}"),
          TextSmall(
              text: "ទីតាំងចុះ & លេខទូរសព្ទ័: ${ticket?.dropOffPoint ?? ""}"),
          TextSmall(text: "សូមអញ្ជើញមកដល់យ៉ាងហោចណាស់30នាទីមុនពេលការចេញដំណើរ"),
          TextSmall(
              text:
                  "សំបុត្រទិញហើយមិនអាចប្តូរយកប្រាក់វិញបានទេ។ អរគុណចំពោះការប្រើប្រាស់ \nសេវាកម្មយើងខ្ញុំ។"),
          TextSmall(
              text:
                  "Please arrive at least 30 minutes before departure time. Ticket sold cannot be refund. Thank you for using our service."),
          // TextSmall(
          //     text:
          //         "Invoice No.: ${transaction?.body?.transactionId}_${ticket?.seatLabel ?? ""}"),
          // TextSmall(
          //     text:
          //         "Direction: ${ticket?.destinationFrom} → ${ticket?.destinationTo}"),
          // TextSmall(text: "Seat No.: ${ticket?.seatLabel ?? ""}"),
          // TextSmall(text: "Customer: Walk In"),
          // TextSmall(text: "Issued Date: ${ticket?.bookingDate}"),
          // TextSmall(text: "Journey Date: ${ticket?.travelDate}"),
        ],
      ),
    );
  }
}

// _alertDialog() {
//     print('📋 Opening Bluetooth selection dialog...');
//     // _loadBluetoothDevices();
//     return Get.dialog(Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Dialog(
//         insetPadding: EdgeInsets.zero,
//         child: Container(
//           constraints: const BoxConstraints(maxHeight: 400), // Increased height
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(5)),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title and Bluetooth status
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                     vertical: AppPadding.medium, horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'ជ្រើសរើសម៉ាសុីនព្រីន',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     Row(
//                       children: [
//                         Icon(
//                           _isBluetoothConnected
//                               ? Icons.bluetooth_connected
//                               : Icons.bluetooth_disabled,
//                           color: _isBluetoothConnected
//                               ? Colors.green
//                               : Colors.grey,
//                           size: 24,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           _isBluetoothConnected ? 'Connected' : 'Disconnected',
//                           style: TextStyle(
//                             color: _isBluetoothConnected
//                                 ? Colors.green
//                                 : Colors.grey,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               // Bluetooth printers list
//               Expanded(
//                 child: _loadingBtDevices
//                     ? const Center(child: CircularProgressIndicator())
//                     : (_btDevices.isEmpty)
//                         ? Center(
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Icon(Icons.print_disabled,
//                                       size: 48, color: Colors.grey),
//                                   const SizedBox(height: 16),
//                                   const Text(
//                                     'មិនមានម៉ាសុីនព្រីនដែលបានភ្ជាប់ទេ',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'សូមភ្ជាប់ម៉ាសុីនព្រីនតាមរយៈ Bluetooth ជាមុន',
//                                     style: TextStyle(
//                                       color: Colors.grey[600],
//                                       fontSize: 14,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         : ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: _btDevices.length,
//                             itemBuilder: (context, index) {
//                               final device = _btDevices[index];
//                               final name = device['name']?.toString() ??
//                                   'Unknown Device';
//                               final address =
//                                   device['address']?.toString() ?? '';
//                               final type = device['type']?.toString() ?? '';
//                               return InkWell(
//                                 onTap: () async {
//                                   controller.uiState.value.isLoading.value =
//                                       true;
//                                   try {
//                                     print(
//                                         '✅ BT selected: name=$name address=$address');
//                                     controller.uiState.value.selectedPrinter
//                                             .value =
//                                         address.isNotEmpty
//                                             ? '$name ($address)'
//                                             : name;
//                                     // Connect to the selected device
//                                     final connected =
//                                         await BluetoothService.connect(address);
//                                     if (connected && mounted) {
//                                       setState(() {
//                                         _isBluetoothConnected = true;
//                                       });
//                                       Get.back();
//                                     }
//                                     print(
//                                         '✅ BT selected printer: ${controller.uiState.value.selectedPrinter.value}');
//                                     Get.back();
//                                   } finally {
//                                     controller.uiState.value.isLoading.value =
//                                         false;
//                                   }
//                                 },
//                                 child: Container(
//                                   height: 56,
//                                   decoration: const BoxDecoration(
//                                     border: Border(
//                                       bottom: BorderSide(
//                                           width: 1, color: Colors.grey),
//                                     ),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Expanded(
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(name,
//                                                   style: const TextStyle(
//                                                       color: Colors.black,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       fontSize:
//                                                           Dimension.fontSize16),
//                                                   overflow:
//                                                       TextOverflow.ellipsis),
//                                               const SizedBox(height: 2),
//                                               Text(name,
//                                                   style: const TextStyle(
//                                                       color: Colors.black54,
//                                                       fontSize:
//                                                           Dimension.fontSize14),
//                                                   overflow:
//                                                       TextOverflow.ellipsis),
//                                             ],
//                                           ),
//                                         ),
//                                         const Icon(Icons.bluetooth,
//                                             color: Colors.blue),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//               ),

//               // Cancel button
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   child: const Text(
//                     'បោះបង់',
//                     style: TextStyle(
//                         color: AppColors.redColor, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
