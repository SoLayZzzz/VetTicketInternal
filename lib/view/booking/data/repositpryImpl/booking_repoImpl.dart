import 'package:vet_internal_ticket/view/booking/data/model/request/booking_transaction_body.dart';
import 'package:vet_internal_ticket/view/booking/data/model/response/booking_transaction_response.dart';
import 'package:vet_internal_ticket/view/booking/data/network/booking_network_datasourece.dart';
import 'package:vet_internal_ticket/view/booking/domain/repository/booking_repo.dart';

class BookingRepoimpl implements BookingRepo {
  final BookingNetworkDatasourece bookingNetworkDatasourece;
  BookingRepoimpl(this.bookingNetworkDatasourece);
  @override
  Future<BookingCheckTransactionModel> getTransaction(
      BookingTransactionBody body) {
    return bookingNetworkDatasourece.getBookingTransaction(body);
  }
}
