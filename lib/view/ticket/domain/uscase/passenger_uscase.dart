import 'package:vet_internal_ticket/view/booking/data/model/request/booking_cf_body.dart';
import 'package:vet_internal_ticket/view/booking/data/model/response/booking_cofirm_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/boarding_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/national_model.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/passenger_repo.dart';

class PassengerUscase {
  final PassengerRepo passengerRepo;

  PassengerUscase(this.passengerRepo);

  Future<BoardingModel> executeBoardingStation(String id) async {
    return await passengerRepo.getBordingStataion(id);
  }

  Future<BoardingModel> executeDownStation(String id) async {
    return await passengerRepo.getDownStation(id);
  }

  Future<BookingCofirmModel> executeBookingComfirm(BookingCfBody body) async {
    return await passengerRepo.postBookingComfirm(body);
  }

  Future<NationalistModel> getNational() async {
    return await passengerRepo.getNational();
  }
}
