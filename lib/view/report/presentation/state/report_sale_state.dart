import 'package:get/get_rx/get_rx.dart';

class ReportSaleState {
  String? agency;
  final agencyItems = ['ប្រុស', 'ស្រី'].obs;

  final RxString bookingDateFrom = ''.obs;
  final RxString bookingDateTo = ''.obs;
  final RxString travelDateFrom = ''.obs;
  final RxString travelDateTo = ''.obs;
}
