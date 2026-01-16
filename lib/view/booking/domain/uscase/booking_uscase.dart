import 'package:vet_internal_ticket/view/booking/data/model/request/booking_transaction_body.dart';
import 'package:vet_internal_ticket/view/booking/data/model/response/booking_transaction_response.dart';
import 'package:vet_internal_ticket/view/booking/domain/repository/booking_repo.dart';

class BookingUscase {
  final BookingRepo bookingRepo;
  BookingUscase(this.bookingRepo);

  Future<BookingCheckTransactionModel> executeGetTransaction(
      BookingTransactionBody body) async {
    return await bookingRepo.getTransaction(body);
  }
}
