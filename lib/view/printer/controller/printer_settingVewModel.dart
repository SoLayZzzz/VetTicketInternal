import 'dart:async';
import 'dart:io' show Platform;
import 'package:get/Get.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import '../../../app_route.dart';
import '../../../utils/General_utils.dart';
import '../../../utils/dialog/dailogPrinter.dart';
import '../../../utils/dialog/snakbar.dart';
import 'package:flutter/material.dart';

class PrinterSettingController extends GetxController {
  static const MethodChannel platform = MethodChannel('com.udaya.bluetooth');
  static const EventChannel eventChannel =
      EventChannel('com.udaya.bluetooth.stream');

  // Reactive variables
  var isPrinterConnected = false.obs;
  var isScanning = false.obs;
  RxList<String> devicesList = <String>[].obs; // Real-time device list
  var connectingDevices = <String, bool>{}.obs;
  RxString printerName = ''.obs;
  RxBool isPrinting = false.obs;

  final List<Map<String, dynamic>> printerOptions = [
    {
      "icon": 'assets/icons/ic_sumi.png',
      "title": 'Mobile Printer',
      'subtitle': "tap_to_select_printer"
    },
    {
      "icon": 'assets/icons/ic_bluetooth_printer.png',
      "title": 'BLUETOOTH V2.0',
      'subtitle': "tap_to_select_printer"
    },
    {
      "icon": 'assets/icons/test.png',
      "title": 'Print Test',
      'subtitle': "print_test"
    },
  ];

  Map<String, dynamic> jsonTest = {
    "status": "1",
    "info": "Get Data Success",
    "date_print": "30/09/2025",
    "date_invoice": "30/09/2025",
    "destination_from": "ក្រុងតាខ្មៅ (កណ្ដាល)KD",
    "destination_to": "ខេត្តបាត់ដំបង (ផ្សារថ្មី)BTB",
    "dest_to_code": "321-01",
    "location_type": "(ខេត្ត)",
    "delivery_area": "ផ្សារថ្មី",
    "branch_from_name": "សាខាក្រុងតាខ្មៅ",
    "branch_from_tel": "098 266 220 / 089 266 220 / 066 266 220",
    "branch_to_name": "សាខា ខេត្តបាត់ដំបង (ផ្សារថ្មី)",
    "branch_to_tel": "012 233 998",
    "transfer_code": "2509155361370-kh",
    "item_value": "10.00",
    "transfer_fee": "6,000",
    "delivery_fee": "2,000",
    "discount": "0",
    "total_amount": "8,000",
    "point": 0,
    "customerName": "",
    "isFree": 0,
    "paid": "1",
    "collect_cod": "0",
    "item_code": "TKM-BTBPTM25090000257",
    "item_name": "ឧបករណ៍អេឡិចត្រូនិច",
    "item_qty": "1",
    "qr_code": "2509155361370-kh,023145678,1,,",
    "token": "9dd7130371fc2bd43c010656dab3c718c696b988"
  };

  var selectedIndex = (-1).obs;

  TextEditingController sizePaperEdit = TextEditingController(text: "65");
  RxDouble sizePaper = 65.0.obs;

  WidgetsToImageController printer = WidgetsToImageController();

  saveSize() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('size', sizePaperEdit.value.text);
    sizePaper.value = double.parse(sizePaperEdit.value.text);
  }

  getSize() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? size = sp.getString('size');
    if (size != null) {
      sizePaperEdit = TextEditingController(text: size);
      sizePaper.value = double.parse(sizePaperEdit.value.text);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    _listenToDeviceStream();
    checkAndReconnectPrinter();
    getSize();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _listenToDeviceStream() {
    if (!Platform.isAndroid) {
      return;
    }

    eventChannel.receiveBroadcastStream().listen((device) {
      if (!devicesList.contains(device)) {
        devicesList.add(device);
      }
    }, onError: (error) {
      print("Device stream error: $error");
    });
  }

  startScan() async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      isScanning.value = true;
      devicesList.clear();
      connectingDevices.clear();

      await platform.invokeMethod('startScan');
    } on PlatformException catch (e) {
      print("Error starting scan: ${e.message}");
    } finally {
      isScanning.value = false;
    }
  }

  // Select a printer option
  void selectOption(int index) {
    selectedIndex.value = index;
    if (index == 0) {
      Utils.snackbarTopSuccess("Success");
    }

    if (index == 1) {
      Get.toNamed(AppRoutes.bluetooth);
      startScan();
    }
    if (index == 2) {
      // Get.to(PrintTestScreen(model: SaveTransferModel.fromJson(jsonTest) ));
      getSize();
    }
  }

  Future<void> connectToDevice(
      String address, String deviceName, String type) async {
    // Clear previous loading states and set only the current device to loading
    connectingDevices.clear();
    connectingDevices[address] = true;

    try {
      final result = await platform
          .invokeMethod('connectToDevice', {'address': address, "type": type});

      if (result == 'CONNECTED') {
        isPrinterConnected.value = true;
        printerName.value = deviceName;

        await _savePrinterDetails(address, deviceName, type);

        // Show success dialog
        showConnectionDialogConnectPrinter(
          context: Get.context!,
          title: 'Connection Successful',
          message: 'Connected to $deviceName successfully!',
          isSuccess: true,
        );
      } else if (result == 'CONNECT_FAILED') {
        // Show failure dialog with retry option
        showConnectionDialogConnectPrinter(
          context: Get.context!,
          title: 'Connection Failed',
          message: 'Failed to connect to $deviceName. Please try again.',
          isSuccess: false,
          deviceAddress: address,
          deviceName: deviceName,
          deviceType: type,
          onRetry: (String retryAddress, String retryName, String retryType) {
            Get.back(); // Close the dialog before retrying
          },
        );
      }
    } on PlatformException catch (e) {
      showConnectionDialogConnectPrinter(
        context: Get.context!,
        title: 'Connection Error',
        message: 'An error occurred: ${e.message}. Please try again.',
        isSuccess: false,
        deviceAddress: address,
        deviceName: deviceName,
        deviceType: type,
        onRetry: (String retryAddress, String retryName, String retryType) {
          Get.back();
        },
      );
    } finally {
      connectingDevices[address] = false;
    }
  }

  Future<void> _savePrinterDetails(
      String address, String deviceName, String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('printer_address', address);
      await prefs.setString('printer_name', deviceName);
      await prefs.setString('printer_type', type);
      print('Printer details saved: $deviceName ($address) $type');
    } catch (e) {
      print('Failed to save printer details: $e');
    }
  }

  Future<Map<String, String?>> getSavedPrinterDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final address = prefs.getString('printer_address');
      final name = prefs.getString('printer_name');
      final type = prefs.getString('printer_type');
      return {'address': address, 'name': name, 'type': type};
    } catch (e) {
      print('Failed to retrieve printer details: $e');
      return {'address': null, 'name': null};
    }
  }

  Future<bool> checkAndReconnectPrinter() async {
    final savedDetails = await getSavedPrinterDetails();

    if (savedDetails['address'] != null && savedDetails['name'] != null) {
      final address = savedDetails['address'];
      final name = savedDetails['name'];
      final type = savedDetails['type'];
      return _attemptReconnect(address!, name!, type!);
    }
    return false;
  }

  Future<bool> _attemptReconnect(
      String address, String name, String type) async {
    try {
      final result = await platform
          .invokeMethod('connectToDevice', {'address': address, "type": type});

      if (result == 'CONNECTED') {
        isPrinterConnected.value = true;
        printerName.value = name;
        print('Reconnected to printer: $name');
        return true;
      } else {
        isPrinterConnected.value = false;
        print('Failed to reconnect to printer: $name');
        return false;
      }
    } catch (e) {
      print('Error during reconnection: $e');
      return false;
    }
  }

  // ScreenshotController screenshotController = ScreenshotController();

  Future<void> startPrint(Uint8List imageData) async {
    try {
      isPrinting.value = true;
      final img.Image originalImage = decodeImage(imageData)!;
      final img.Image rotatedImage = copyRotate(originalImage, angle: 180);
      final Uint8List rotatedImageData =
          Uint8List.fromList(encodePng(rotatedImage));

      final response = await platform.invokeMethod('printData', {
        'imageData': rotatedImageData,
        'height': 100,
        'percent': sizePaper / 100,
      });

      isPrinting.value = false;

      if (response == 'Print Success') {
        showSnackBar(
          title: 'Success',
          message: 'Machine started printing.',
          isError: false,
        );
      } else if (response == 'Print Fail') {
        isPrinting.value = false;
        Get.back();
        showSnackBar(
          title: 'Error',
          message: 'Print Fail Please check connect printer ',
          isError: true,
        );
        Get.toNamed(AppRoutes.printerSetting);
      }
    } catch (e) {
      print(e);
    }
  }
}
