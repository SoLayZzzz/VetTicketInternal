import 'package:vet_internal_ticket/view/booking/data/model/request/booking_cf_body.dart';
import 'package:vet_internal_ticket/view/booking/data/model/response/booking_cofirm_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/boarding_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/national_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/network/passenger_network.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/passenger_repo.dart';

class PassengerRepoimpl implements PassengerRepo {
  final PassengerNetwork passengerNetwork;
  PassengerRepoimpl(this.passengerNetwork);
  @override
  Future<BoardingModel> getBordingStataion(String id) {
    return passengerNetwork.boardingStation(id);
  }

  @override
  Future<BoardingModel> getDownStation(String id) {
    return passengerNetwork.downStation(id);
  }

  @override
  Future<BookingCofirmModel> postBookingComfirm(BookingCfBody body) {
    return passengerNetwork.bookingCofirm(body);
  }

  @override
  Future<NationalistModel> getNational() {
    return passengerNetwork.getNational();
  }
}
