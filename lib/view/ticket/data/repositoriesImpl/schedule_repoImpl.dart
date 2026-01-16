import 'package:vet_internal_ticket/view/ticket/data/model/request/schedule_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/schedule_response.dart';
import 'package:vet_internal_ticket/view/ticket/data/network/schedule_network.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/schedule_repo.dart';

class ScheduleRepoimpl implements ScheduleRepo {
  final ScheduleNetwork scheduleNetwork;
  ScheduleRepoimpl(this.scheduleNetwork);
  @override
  Future<ScheduleModel> getSchedule(ScheduleBody body) {
    return scheduleNetwork.schedule(body);
  }
}
