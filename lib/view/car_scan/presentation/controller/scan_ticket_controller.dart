// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import 'package:vet_internal_ticket/utils/colors.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/request/checkIn_request.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/bus_list_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/checkIn_layout_response.dart';
import 'package:vet_internal_ticket/view/car_scan/domain/uscase/scan_uscase.dart';
import 'package:vet_internal_ticket/view/car_scan/presentation/state/scan_state.dart';

class ScanTicketController extends StateController<ScanState> {
  final ScanUscase scanUscase;
  ScanTicketController(this.scanUscase);
  @override
  ScanState onInitUiState() => ScanState();

  @override
  void onInit() {
    super.onInit();
    // Initialize scanner controllers only once
    uiState.value.controllerQr.value = MobileScannerController();
    uiState.value.controllerBarCode.value = MobileScannerController();
    getBusList();
  }

  @override
  void onClose() {
    // ✅ Just stop the scanner instead of disposing
    uiState.value.controllerQr.value.stop();
    uiState.value.controllerBarCode.value.stop();
    super.onClose();
  }

  void reInitScannerControllers() {
    // ✅ Call this if you want fresh controllers (optional)
    uiState.value.controllerQr.value = MobileScannerController();
    uiState.value.controllerBarCode.value = MobileScannerController();
  }

  void selectBus(String value) async {
    uiState.value.selectedBus.value = value;
    uiState.value.isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    uiState.value.isLoading.value = false;
  }

  Future<void> getBusList() async {
    uiState.value.isLoading.value = true;
    uiState.value.errorMessage.value = "";

    try {
      final response = await scanUscase.getBusList();
      uiState.value.busList.value = response;

      print("Get Bus list ====>  $response");
    } catch (e) {
      uiState.value.errorMessage.value = e.toString();
    } finally {
      uiState.value.isLoading.value = false;
    }
  }

  // ===================================================================
  // ========================= For Qr code scan ========================
  // ===================================================================

  void onDectQR(BarcodeCapture capture) async {
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    // ✅ Define the scan box zone (same as UI)
    final screenSize = MediaQuery.of(Get.context!).size;
    const scanBoxSize = 300.0;
    final scanBoxCenter = Offset(screenSize.width / 2, screenSize.height / 2.8);
    final scanRect = Rect.fromCenter(
      center: scanBoxCenter,
      width: scanBoxSize,
      height: scanBoxSize,
    );

    // ✅ Get barcode corners and check if it's inside the scanRect
    final corners = barcode.corners;
    if (corners == null || corners.length != 4) return;

    final minX = corners.map((e) => e.dx).reduce((a, b) => a < b ? a : b);
    final maxX = corners.map((e) => e.dx).reduce((a, b) => a > b ? a : b);
    final minY = corners.map((e) => e.dy).reduce((a, b) => a < b ? a : b);
    final maxY = corners.map((e) => e.dy).reduce((a, b) => a > b ? a : b);
    final barcodeRect = Rect.fromLTRB(minX, minY, maxX, maxY);

    if (!scanRect.overlaps(barcodeRect)) {
      // ❌ Barcode is outside white box → ignore
      return;
    }

    // ✅ If inside scan box, process as before
    final raw = barcode.rawValue!;
    if (raw == uiState.value.scannedData.value &&
        !uiState.value.isContinuousScan.value) {
      return;
    }

    uiState.value.scannedData.value = raw;

    if (!uiState.value.isContinuousScan.value) {
      uiState.value.controllerQr.value.stop();
    }

    // ✅ Continue with your existing check-in logic
    try {
      final seatList =
          uiState.value.checkinLayoutModel.value?.body?.seatSelected ?? [];

      final matchedSeat = seatList.firstWhere(
        (seat) => seat.scanCode == raw || seat.ticketCode == raw,
        orElse: () => SeatSelected(),
      );

      if ((matchedSeat.seatNumber ?? '').isEmpty) {
        _showDialog("បរាជ័យ", "ទិន្នន័យ QR មិនត្រឹមត្រូវ", "");
        restartScanner();
        return;
      }

      final selectedBusName = uiState.value.selectedBus.value;
      final busModel = uiState.value.busList.value;
      final bus = busModel?.body?.firstWhere(
        (e) => e.name == selectedBusName,
        orElse: () => BusResult(),
      );

      if (bus == null || (bus.id?.isEmpty ?? true)) {
        _showDialog("បរាជ័យ", "មិនអាចរកឃើញឡានសម្រាប់ Check-In", "");
        restartScanner();
        return;
      }

      await fetchScanCheckInAuto(bus.id!, matchedSeat);
    } catch (e) {
      _showDialog("បរាជ័យ", "មានបញ្ហា: ${e.toString()}", "");
      restartScanner();
    }
  }

  Future<void> fetchScanCheckInAuto(String busId, SeatSelected seat) async {
    try {
      String checkInCode = seat.scanCode?.isNotEmpty == true
          ? seat.scanCode!
          : (seat.ticketCode ?? '');

      if (checkInCode.isEmpty) {
        _showDialog("បរាជ័យ", "មិនមាន QR/Barcode សម្រាប់ Check-In", "");
        restartScanner();
        return;
      }

      final body = CheckinBodyRequest(
        busId: busId,
        code: checkInCode,
        scanType: uiState.value.currentScanType,
      );

      final response = await scanUscase.getBookingCheckIn(body);

      if (response.header?.statusCode == 200 &&
          response.header?.result == true &&
          response.body?.status == 1) {
        // ✅ Refresh layout after success
        await fetchSeatCheckinLayout(busId);

        // ✅ Restart scanner for next ticket
        restartScanner();
      } else {
        // ❌ Error case → Show dialog
        _showDialog(
            "បរាជ័យ", response.body?.desc ?? "មិនអាចចូលបានទេ", checkInCode);
        restartScanner();
      }
    } catch (e) {
      _showDialog("បរាជ័យ", "មានបញ្ហា: ${e.toString()}", "");
      restartScanner();
    }
  }

  void restartScanner() {
    Future.delayed(const Duration(milliseconds: 500), () {
      uiState.value.scannedData.value = '';
      uiState.value.controllerQr.value.start();
    });
  }

  void toggleZoom() {
    if (uiState.value.isZoomedIn.value) {
      uiState.value.controllerQr.value.setZoomScale(0.0);
      uiState.value.isZoomedIn.value = false;
    } else {
      uiState.value.controllerQr.value.setZoomScale(0.5);
      uiState.value.isZoomedIn.value = true;
    }
  }

  void resetScanner() {
    uiState.value.scannedData.value = null;
    uiState.value.controllerQr.value.start();
  }

  // ===================================================================
  // ========================= For Bar code scan =======================
  // ===================================================================
  void onDetecBarCode(BarcodeCapture capture) async {
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    // ✅ Define the scan box zone (same as UI)
    final screenSize = MediaQuery.of(Get.context!).size;
    const scanBoxSize = 300.0;
    final scanBoxCenter = Offset(screenSize.width / 2, screenSize.height / 2.8);
    final scanRect = Rect.fromCenter(
      center: scanBoxCenter,
      width: scanBoxSize,
      height: scanBoxSize,
    );

    // ✅ Get barcode corners and check if it's inside the scanRect
    final corners = barcode.corners;
    if (corners == null || corners.length != 4) return;

    final minX = corners.map((e) => e.dx).reduce((a, b) => a < b ? a : b);
    final maxX = corners.map((e) => e.dx).reduce((a, b) => a > b ? a : b);
    final minY = corners.map((e) => e.dy).reduce((a, b) => a < b ? a : b);
    final maxY = corners.map((e) => e.dy).reduce((a, b) => a > b ? a : b);
    final barcodeRect = Rect.fromLTRB(minX, minY, maxX, maxY);

    if (!scanRect.overlaps(barcodeRect)) {
      // ❌ Barcode is outside white box → ignore
      return;
    }

    // ✅ If inside scan box, process as before
    final raw = barcode.rawValue!;
    if (raw == uiState.value.scannedData.value &&
        !uiState.value.isContinuousScan.value) {
      return;
    }

    uiState.value.scannedData.value = raw;

    if (!uiState.value.isContinuousScan.value) {
      uiState.value.controllerBarCode.value.stop();
    }

    // ✅ Continue with your existing check-in logic
    try {
      final seatList =
          uiState.value.checkinLayoutModel.value?.body?.seatSelected ?? [];

      final matchedSeat = seatList.firstWhere(
        (seat) => seat.scanCode == raw || seat.ticketCode == raw,
        orElse: () => SeatSelected(),
      );

      if ((matchedSeat.seatNumber ?? '').isEmpty) {
        _showDialog("បរាជ័យ", "ទិន្នន័យ QR មិនត្រឹមត្រូវ", "");
        restartScannerBarCode();
        return;
      }

      final selectedBusName = uiState.value.selectedBus.value;
      final busModel = uiState.value.busList.value;
      final bus = busModel?.body?.firstWhere(
        (e) => e.name == selectedBusName,
        orElse: () => BusResult(),
      );

      if (bus == null || (bus.id?.isEmpty ?? true)) {
        _showDialog("បរាជ័យ", "មិនអាចរកឃើញឡានសម្រាប់ Check-In", "");
        restartScannerBarCode();
        return;
      }

      await fetchScanCheckInAuto(bus.id!, matchedSeat);
    } catch (e) {
      _showDialog("បរាជ័យ", "មានបញ្ហា: ${e.toString()}", "");
      restartScannerBarCode();
    }
  }

  void restartScannerBarCode() {
    Future.delayed(const Duration(milliseconds: 500), () {
      uiState.value.scannedData.value = '';
      uiState.value.controllerQr.value.start();
    });
  }

  // ===================================================================
  // ========================= Get Seat check in layout =======================
  // ===================================================================

  List<String> get scannedSeats {
    final list =
        uiState.value.checkinLayoutModel.value?.body?.seatSelected ?? [];
    return list
        .where((seat) => seat.checkIn == 1)
        .map((s) => s.seatNumber ?? '')
        .toList();
  }

  List<String> get bookedSeats {
    final list =
        uiState.value.checkinLayoutModel.value?.body?.seatSelected ?? [];
    return list
        .where((seat) => seat.enable == 1)
        .map((s) => s.seatNumber ?? '')
        .toList();
  }

  /// ✅ Fetch Seat Check-in Layout and parse layoutSeat JSON
  Future<void> fetchSeatCheckinLayout(String id) async {
    uiState.value.isLoading.value = true;
    uiState.value.errorMessage.value = "";
    try {
      final response = await scanUscase.getSeatCheckinLayout(id);
      uiState.value.checkinLayoutModel.value = response;

      if (response.body != null && response.body!.layoutSeat != null) {
        uiState.value.parsedSeatLayout.value =
            parseLayout(response.body!.layoutSeat!);
      }
    } catch (e) {
      uiState.value.errorMessage.value = e.toString();
    } finally {
      uiState.value.isLoading.value = false;
    }
  }

  List<List<Map<String, dynamic>>> parseLayout(String layoutSeat) {
    final parsed = jsonDecode(layoutSeat) as List;
    return parsed
        .map((row) => (row['col'] as List)
            .map((col) => col as Map<String, dynamic>)
            .toList())
        .toList();
  }

  void toggleSeatSelection(String value, String label) {
    if (!bookedSeats.contains(value)) {
      return; // Not booked, ignore
    }

    final seatList =
        uiState.value.checkinLayoutModel.value?.body?.seatSelected ?? [];

    final matchedSeat = seatList.firstWhere(
      (seat) => seat.seatNumber == value,
      orElse: () => SeatSelected(),
    );

    _showSeatInfoDialog(matchedSeat);
  }

  void _showSeatInfoDialog(SeatSelected seat) {
    Get.dialog(
      barrierColor: Colors.grey.withAlpha(80),
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: AppPadding.large),
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ព័ត៌មានកៅអី",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildSeatDetail("កៅអី", seat.seatNumber ?? ''),
              _buildSeatDetail("ស្លាកកៅអី", seat.seatLabel ?? ''),
              _buildSeatDetail("លេខសំបុត្រ", seat.ticketCode ?? ''),
              _buildSeatDetail("លេខទូរសព្ទ័", seat.telephone ?? 'មិនមាន'),
              _buildSeatDetail("QR/Barcode", seat.scanCode ?? ''),
              _buildSeatDetail("បានលក់ដោយ", seat.soldBy ?? 'N/A'),
              _buildSeatDetail(
                  "ស្ថានភាព", seat.checkIn == 1 ? "បានឡើង" : "មិនទាន់ឡើង"),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text("បិទ", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (seat.checkIn != 1)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                          final selectedBusName =
                              uiState.value.selectedBus.value;
                          final busModel = uiState.value.busList.value;
                          final bus = busModel?.body?.firstWhere(
                            (e) => e.name == selectedBusName,
                            orElse: () => BusResult(),
                          );

                          if (bus != null && (bus.id?.isNotEmpty ?? false)) {
                            await fetchScanCheckIn(
                              bus.id!,
                              seat.seatNumber ?? '',
                            );
                          } else {
                            _showDialog(
                                "បរាជ័យ", "មិនអាចរកឃើញឡានសម្រាប់ Check-In", "");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text("Check-In",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildSeatDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Flexible(
              child: Text(value,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Future<void> fetchScanCheckIn(String busId, String seatNumber) async {
    uiState.value.isLoading.value = true;

    try {
      final seatList =
          uiState.value.checkinLayoutModel.value?.body?.seatSelected ?? [];

      final matchedSeat = seatList.firstWhere(
        (seat) => seat.seatNumber == seatNumber,
        orElse: () => SeatSelected(),
      );

      String checkInCode = matchedSeat.scanCode?.isNotEmpty == true
          ? matchedSeat.scanCode!
          : (matchedSeat.ticketCode ?? '');

      if (checkInCode.isEmpty) {
        _showDialog("បរាជ័យ", "មិនមាន QR/Barcode សម្រាប់ Check-In", "");
        uiState.value.isLoading.value = false;
        return;
      }

      final body = CheckinBodyRequest(
        busId: busId,
        code: checkInCode,
        scanType: uiState.value.currentScanType,
      );

      print(
          "Body scan ==> $busId, $checkInCode,  ${uiState.value.currentScanType}");

      final response = await scanUscase.getBookingCheckIn(body);

      if (response.header?.statusCode == 200 &&
          response.header?.result == true) {
        if (response.body?.status == 1) {
          _showDialogSuccess(
            "ជោគជ័យ",
            "ការស្គេនបានជោគជ័យ\n"
                "កូដ: ${response.body?.code ?? ''}\n"
                "កៅអី: ${response.body?.seatNumber ?? ''}\n",
            checkInCode,
            () async {
              await fetchSeatCheckinLayout(busId);
            },
          );
        } else {
          _showDialog(
              "បរាជ័យ", response.body?.desc ?? "មិនអាចចូលបានទេ", checkInCode);
        }
      } else {
        _showDialog("បរាជ័យ", response.header?.errorText ?? "មិនអាចចូលបានទេ",
            checkInCode);
      }
    } catch (e) {
      _showDialog("បរាជ័យ", "មានបញ្ហា: ${e.toString()}", "");
    } finally {
      uiState.value.isLoading.value = false;
    }
  }

  // ===================================================================
  // ========================= Show dialog information =================
  // ===================================================================

  void _showDialogSuccess(
      String title, String message, String currentScan, VoidCallback ontap) {
    Get.dialog(
      barrierColor: Colors.grey.withAlpha(80),
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: AppPadding.large),
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ontap();
                    Get.back();

                    Future.delayed(const Duration(milliseconds: 500), () {
                      uiState.value.scannedData.value = '';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'យល់ព្រម',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showDialog(String title, String message, String currentScan) {
    Get.dialog(
      barrierColor: Colors.grey.withAlpha(80),
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: AppPadding.large),
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    // ✅ Allow new scan after closing
                    Future.delayed(const Duration(milliseconds: 500), () {
                      uiState.value.scannedData.value = ''; // Reset lock
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'យល់ព្រម',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
