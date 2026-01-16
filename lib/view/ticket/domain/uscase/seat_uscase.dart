import 'package:vet_internal_ticket/view/ticket/data/model/request/seat_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_layout_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_unavailable_model.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/seat_repo.dart';

class SeatUscase {
  final SeatRepo seatRepo;
  SeatUscase(this.seatRepo);

  Future<SeatLayoutModel> executeSeatLayout(SeatBody body) async {
    return await seatRepo.getSeatLayout(body);
  }

  Future<SeatUnavailableModel> executeSeatUnvailable(SeatBody body) async {
    return await seatRepo.getSeatUnvailable(body);
  }
}
