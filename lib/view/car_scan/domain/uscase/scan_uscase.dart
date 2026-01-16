import 'package:vet_internal_ticket/view/car_scan/data/model/request/checkIn_request.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/bus_list_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/checkIn_layout_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/checkIn_response.dart';
import 'package:vet_internal_ticket/view/car_scan/domain/repository/scan_repository.dart';

class ScanUscase {
  final ScanRepository scanRepository;
  ScanUscase(this.scanRepository);

  Future<BusListModel> getBusList() async {
    return await scanRepository.getBusList();
  }

  Future<CheckinLayoutResponse> getSeatCheckinLayout(String id) async {
    return await scanRepository.getSeatCheckinLayout(id);
  }

  Future<CheckinResponse> getBookingCheckIn(CheckinBodyRequest body) async {
    return await scanRepository.getBookingCheckIn(body);
  }
}
