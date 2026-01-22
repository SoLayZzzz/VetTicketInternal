import 'package:vet_internal_ticket/view/home/data/model/request/booking_history_list_body.dart';
import 'package:vet_internal_ticket/view/home/data/model/request/booking_history_find_body.dart';
import 'package:vet_internal_ticket/view/home/data/model/response/booking_history_find_response.dart';
import 'package:vet_internal_ticket/view/home/data/model/response/booking_history_list_response.dart';
import 'package:vet_internal_ticket/view/home/data/nework/booking_history_network_datasource.dart';
import 'package:vet_internal_ticket/view/home/domain/repositories/booking_history_repo.dart';

class BookingHistoryRepoImpl implements BookingHistoryRepo {
  final BookingHistoryNetworkDatasource bookingHistoryNetworkDatasource;

  BookingHistoryRepoImpl(this.bookingHistoryNetworkDatasource);

  @override
  Future<BookingHistoryListResponseModel> getBookingHistoryList(
      BookingHistoryListBody body) {
    return bookingHistoryNetworkDatasource.getBookingHistoryList(body);
  }

  @override
  Future<BookingHistoryFindResponseModel> getBookingHistoryById(
      {required int id, required BookingHistoryFindBody body}) {
    return bookingHistoryNetworkDatasource.getBookingHistoryById(
        id: id, body: body);
  }
}
