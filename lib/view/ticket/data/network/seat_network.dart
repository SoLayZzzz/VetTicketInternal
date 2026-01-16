import 'package:vet_internal_ticket/core/app_url/seat_url.dart';
import 'package:vet_internal_ticket/core/base/contentType.dart';
import 'package:vet_internal_ticket/core/network/network_data_source.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/seat_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_layout_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_unavailable_model.dart';

class SeatNetwork {
  final NetworkDataSource networkDataSource;
  SeatNetwork(this.networkDataSource);

  Future<SeatLayoutModel> seatLayout(SeatBody body) async {
    final response = await networkDataSource.safePost(
      SeatUrl.seatLayout,
      body.toMap(),
      contentType: ContentTypeVET.contentType,
      decoder: (data) {
        return SeatLayoutModel.fromJson(data);
      },
    );

    if (response == null) {
      throw Exception('Fail to get seat layout');
    }

    return response;
  }

  Future<SeatUnavailableModel> seatUnavailable(SeatBody body) async {
    final response = await networkDataSource.safePost(
      SeatUrl.seatUnavailable,
      body.toMap(),
      contentType: ContentTypeVET.contentType,
      decoder: (data) {
        return SeatUnavailableModel.fromJson(data);
      },
    );

    if (response == null) {
      throw Exception('Fail to get seat unavailable');
    }

    return response;
  }
}
