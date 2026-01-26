import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/home/data/model/response/booking_history_list_response.dart';

class CarHistoryState {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  RxList<BookingHistoryItem> histories = <BookingHistoryItem>[].obs;
}
