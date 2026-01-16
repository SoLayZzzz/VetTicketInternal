import 'package:vet_internal_ticket/view/booking/data/model/request/booking_transaction_body.dart';
import 'package:vet_internal_ticket/view/booking/data/model/response/booking_transaction_response.dart';

abstract class BookingRepo {
  Future<BookingCheckTransactionModel> getTransaction(
      BookingTransactionBody body);
}
