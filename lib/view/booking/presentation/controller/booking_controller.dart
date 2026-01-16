// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/view/booking/data/model/request/booking_transaction_body.dart';
import 'package:vet_internal_ticket/view/booking/domain/uscase/booking_uscase.dart';
import 'package:vet_internal_ticket/view/booking/presentation/state/booking_state.dart';

class BookingController extends StateController<BookingState> {
  final BookingUscase bookingUscase;
  BookingController(this.bookingUscase);
  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg != null) {
      final totalPriceString = arg['totalPrice'];
      double totalPrice = 0.0;

      if (totalPriceString is String) {
        totalPrice = double.tryParse(totalPriceString) ?? 0.0;
      } else if (totalPriceString is double) {
        totalPrice = totalPriceString;
      }

      getAgrument(
        transactionId: arg['transactionId'],
        totalPrice: totalPrice,
        totalSeat: arg['totalSeat'],
      );
      getTransaction();
    }
  }

  @override
  BookingState onInitUiState() => BookingState();
  void getAgrument({
    required String transactionId,
    required double totalPrice,
    required String totalSeat,
  }) {
    uiState.value.transactionId = transactionId;
    uiState.value.totalPrice = totalPrice;
    uiState.value.totalSeat = totalSeat;

    print("======== Transaction get argument ========");
    print("Transaction ID: $transactionId");
    print("Total Price: $totalPrice");
    print("Total Seat: $totalSeat");
    print("===========================================");
  }

  Future<void> getTransaction() async {
    final st = uiState.value;
    try {
      st.isLoading.value = true;
      st.errorMessage.value = '';

      final body = BookingTransactionBody(transactionId: st.transactionId!);

      final response = await bookingUscase.executeGetTransaction(body);
      st.bookingTransactonModel.value = response;
    } catch (e) {
      st.errorMessage.value = e.toString();
      st.bookingTransactonModel.value = null;
    } finally {
      st.isLoading.value = false;
    }
  }
}
