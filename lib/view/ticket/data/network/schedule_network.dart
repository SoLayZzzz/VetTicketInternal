import 'package:vet_internal_ticket/core/app_url/schedule_url.dart';
import 'package:vet_internal_ticket/core/base/contentType.dart';
import 'package:vet_internal_ticket/core/network/network_data_source.dart';

import 'package:vet_internal_ticket/view/ticket/data/model/request/schedule_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/schedule_response.dart';

class ScheduleNetwork {
  final NetworkDataSource _networkDataSource;
  ScheduleNetwork(this._networkDataSource);

  Future<ScheduleModel> schedule(ScheduleBody body) async {
    final response = await _networkDataSource.safePost(
      ScheduleUrl.scheduleListByDate,
      body.toMap(),
      contentType: ContentTypeVET.contentType,
      decoder: (data) {
        return ScheduleModel.fromJson(data);
      },
    );

    if (response == null) {
      throw Exception('Faild to get schedule');
    }

    return response;
  }
}
