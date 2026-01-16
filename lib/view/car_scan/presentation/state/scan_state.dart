import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/bus_list_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/checkIn_layout_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/checkIn_response.dart';

class ScanState {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt status = 0.obs;
  RxnString selectedBus = RxnString();

  String currentScanType = "1";
  final Rx<BusListModel?> busList = Rx<BusListModel?>(null);
  final Rx<CheckinLayoutResponse?> checkinLayoutModel =
      Rx<CheckinLayoutResponse?>(null);

  final Rx<List<List<Map<String, dynamic>>>> parsedSeatLayout =
      Rx<List<List<Map<String, dynamic>>>>([]);

  final Rx<CheckInModel?> checkInModel = Rx<CheckInModel?>(null);

  final List<Map<String, String>> selectedSeats = [];
  //
  final RxBool isFlashOn = false.obs;
  final RxBool isZoomEnabled = false.obs;
  final RxBool isContinuousScan = false.obs;
  final RxBool isZoomedIn = false.obs;
  final RxnString scannedData = RxnString();

  // For Qr code scan ========================
  // final MobileScannerController controllerQr = MobileScannerController();

  // // For Barcode scan ========================
  // final MobileScannerController controllerBarCode = MobileScannerController(
  //   formats: [
  //     BarcodeFormat.code128,
  //     BarcodeFormat.code39,
  //     BarcodeFormat.code93,
  //     BarcodeFormat.ean13,
  //     BarcodeFormat.ean8,
  //     BarcodeFormat.upcA,
  //     BarcodeFormat.upcE,
  //     BarcodeFormat.itf,
  //   ],
  // );

  final Rx<MobileScannerController> controllerQr =
      Rx<MobileScannerController>(MobileScannerController());

  final Rx<MobileScannerController> controllerBarCode =
      Rx<MobileScannerController>(
    MobileScannerController(
      formats: [
        BarcodeFormat.code128,
        BarcodeFormat.code39,
        BarcodeFormat.code93,
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
        BarcodeFormat.itf,
      ],
    ),
  );
}
