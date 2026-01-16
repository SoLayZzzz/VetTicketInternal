import 'package:vet_internal_ticket/view/ticket/data/model/request/seat_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_layout_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_unavailable_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/network/seat_network.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/seat_repo.dart';

class SeatRepoImpl implements SeatRepo {
  final SeatNetwork seatNetwork;
  SeatRepoImpl(this.seatNetwork);
  @override
  Future<SeatLayoutModel> getSeatLayout(SeatBody body) {
    return seatNetwork.seatLayout(body);
  }

  @override
  Future<SeatUnavailableModel> getSeatUnvailable(SeatBody body) {
    return seatNetwork.seatUnavailable(body);
  }
}
