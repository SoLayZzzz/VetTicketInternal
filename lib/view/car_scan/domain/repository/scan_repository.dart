import 'package:vet_internal_ticket/view/car_scan/data/model/request/checkIn_request.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/bus_list_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/checkIn_layout_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/checkIn_response.dart';

abstract class ScanRepository {
  Future<BusListModel> getBusList();
  Future<CheckinLayoutResponse> getSeatCheckinLayout(String id);
  Future<CheckinResponse> getBookingCheckIn(CheckinBodyRequest body);
}
