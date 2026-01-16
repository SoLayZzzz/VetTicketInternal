import 'package:vet_internal_ticket/view/booking/data/model/request/booking_cf_body.dart';
import 'package:vet_internal_ticket/view/booking/data/model/response/booking_cofirm_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/boarding_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/national_model.dart';

abstract class PassengerRepo {
  Future<BoardingModel> getBordingStataion(String id);
  Future<BoardingModel> getDownStation(String id);
  Future<BookingCofirmModel> postBookingComfirm(BookingCfBody body);
  Future<NationalistModel> getNational();
}
