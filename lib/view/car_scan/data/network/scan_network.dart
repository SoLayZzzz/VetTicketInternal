import 'package:vet_internal_ticket/core/app_url/scan_url.dart';
import 'package:vet_internal_ticket/core/app_url/seat_url.dart';
import 'package:vet_internal_ticket/core/app_url/transportation_url.dart';
import 'package:vet_internal_ticket/core/base/contentType.dart';
import 'package:vet_internal_ticket/core/network/network_data_source.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/request/checkIn_request.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/bus_list_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/checkIn_layout_response.dart';
import 'package:vet_internal_ticket/view/car_scan/data/model/response/checkIn_response.dart';

class ScanNetwork {
  final NetworkDataSource networkDataSource;

  ScanNetwork(this.networkDataSource);

  Future<BusListModel> getBuslist() async {
    final response = await networkDataSource.safePost(
      TransportationUrl.busList,
      null,
      contentType: ContentTypeVET.contentType,
      decoder: (data) {
        return BusListModel.fromJson(data);
      },
    );

    if (response == null) {
      throw Exception("Faild to get bus");
    }
    return response;
  }

  Future<CheckinLayoutResponse> getSeatCheckinLayout(String id) async {
    var body = {'id': id};
    final response = await networkDataSource.safePost(
      SeatUrl.seatCheckInLayout(id),
      body,
      contentType: ContentTypeVET.contentType,
      decoder: (data) {
        return CheckinLayoutResponse.fromJson(data);
      },
    );

    if (response == null) {
      throw Exception('Fail to get seat layout');
    }

    return response;
  }

  Future<CheckinResponse> getBookingCheckIn(CheckinBodyRequest body) async {
    final respone = await networkDataSource.safePost(
      ScanUrl.checkIn,
      body,
      query: {
        'busId': body.busId,
        'code': body.code,
        'scanType': body.scanType,
      },
      contentType: ContentTypeVET.contentType,
      decoder: (data) {
        return CheckinResponse.fromJson(data);
      },
    );

    if (respone == null) {
      throw Exception('Fail to get booking check in');
    }

    return respone;
  }
}
