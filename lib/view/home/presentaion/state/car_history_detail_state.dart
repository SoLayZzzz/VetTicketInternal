import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/home/data/model/response/booking_history_find_response.dart';

class CarHistoryDetailState {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Rx<BookingHistoryFindResponseModel?> detailResponse =
      Rx<BookingHistoryFindResponseModel?>(null);

  BookingHistoryDetailItem? get item =>
      detailResponse.value?.body?.data?.isNotEmpty == true
          ? detailResponse.value!.body!.data!.first
          : null;
}
