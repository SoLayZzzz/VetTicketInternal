import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/booking/data/model/response/booking_transaction_response.dart';

class BookingState {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  final selectedPrinter = ''.obs;

  String? transactionId;
  double totalPrice = 0.0;
  String totalSeat = '';

  Rx<BookingCheckTransactionModel?> bookingTransactonModel =
      Rx<BookingCheckTransactionModel?>(null);

  // Add if you want convenience getter
  List<Ticket>? get tickets => bookingTransactonModel.value?.body?.ticket;
}
