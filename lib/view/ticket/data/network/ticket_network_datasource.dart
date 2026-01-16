// ignore_for_file: prefer_const_declarations
import 'package:vet_internal_ticket/core/app_url/destination_url.dart';
import 'package:vet_internal_ticket/core/base/contentType.dart';

import 'package:vet_internal_ticket/core/network/network_data_source.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/destination_from_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/destination_to_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/destination_model.dart';

class TicketNetworkDatasource {
  final NetworkDataSource _networkDataSource;

  TicketNetworkDatasource(this._networkDataSource);

  Future<DestinationFromModel> destiFrom(DestinationFromBody body) async {
    final response = await _networkDataSource.safePost(
      DestinationUrl.destinationFrom,
      body.toMap(),
      contentType: ContentTypeVET.contentType,
      decoder: (data) {
        return DestinationFromModel.fromJson(data);
      },
    );

    if (response == null) {
      throw Exception("Faild to fetch destination from");
    }

    return response;
  }

  Future<DestinationFromModel> destiTo(DestinationToBody body) async {
    final response = await _networkDataSource.safePost(
      DestinationUrl.destinationTo,
      body.toMap(),
      contentType: ContentTypeVET.contentType,
      decoder: (data) {
        return DestinationFromModel.fromJson(data);
      },
    );

    if (response == null) {
      throw Exception('Faild to fect destination To');
    }

    return response;
  }
}
