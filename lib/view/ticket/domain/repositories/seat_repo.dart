import 'package:vet_internal_ticket/view/ticket/data/model/request/seat_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_layout_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_unavailable_model.dart';

abstract class SeatRepo {
  Future<SeatLayoutModel> getSeatLayout(SeatBody body);
  Future<SeatUnavailableModel> getSeatUnvailable(SeatBody body);
}
