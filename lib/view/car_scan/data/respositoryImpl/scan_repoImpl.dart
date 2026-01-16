import 'package:vet_internal_ticket/view/car_scan/data/model/request/checkIn_request.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/bus_list_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/checkIn_layout_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/checkIn_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/network/scan_network.dart';
import 'package:vet_internal_ticket/view/car_scan/domain/repository/scan_repository.dart';

class ScanRepoimpl implements ScanRepository {
  final ScanNetwork scanNetwork;
  ScanRepoimpl(this.scanNetwork);
  @override
  Future<BusListModel> getBusList() {
    return scanNetwork.getBuslist();
  }

  @override
  Future<CheckinLayoutResponse> getSeatCheckinLayout(String id) {
    return scanNetwork.getSeatCheckinLayout(id);
  }

  @override
  Future<CheckinResponse> getBookingCheckIn(CheckinBodyRequest body) {
    return scanNetwork.getBookingCheckIn(body);
  }
}
