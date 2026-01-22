import 'package:vet_internal_ticket/view/home/data/model/request/booking_history_list_body.dart';
import 'package:vet_internal_ticket/view/home/data/model/request/booking_history_find_body.dart';
import 'package:vet_internal_ticket/view/home/data/model/response/booking_history_find_response.dart';
import 'package:vet_internal_ticket/view/home/data/model/response/booking_history_list_response.dart';

abstract class BookingHistoryRepo {
  Future<BookingHistoryListResponseModel> getBookingHistoryList(
      BookingHistoryListBody body);

  Future<BookingHistoryFindResponseModel> getBookingHistoryById(
      {required int id, required BookingHistoryFindBody body});
}
