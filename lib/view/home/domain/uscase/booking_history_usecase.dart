import 'package:vet_internal_ticket/view/home/data/model/request/booking_history_list_body.dart';
import 'package:vet_internal_ticket/view/home/data/model/request/booking_history_find_body.dart';
import 'package:vet_internal_ticket/view/home/data/model/response/booking_history_find_response.dart';
import 'package:vet_internal_ticket/view/home/data/model/response/booking_history_list_response.dart';
import 'package:vet_internal_ticket/view/home/domain/repositories/booking_history_repo.dart';

class BookingHistoryUsecase {
  BookingHistoryUsecase(this.bookingHistoryRepo);

  final BookingHistoryRepo bookingHistoryRepo;

  Future<BookingHistoryListResponseModel> executeGetBookingHistoryList(
      BookingHistoryListBody body) {
    return bookingHistoryRepo.getBookingHistoryList(body);
  }

  Future<BookingHistoryFindResponseModel> executeGetBookingHistoryById(
      {required int id, required BookingHistoryFindBody body}) {
    return bookingHistoryRepo.getBookingHistoryById(id: id, body: body);
  }
}
