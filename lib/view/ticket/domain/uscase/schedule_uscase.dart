import 'package:vet_internal_ticket/view/ticket/data/model/request/schedule_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/schedule_response.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/schedule_repo.dart';

class ScheduleUscase {
  final ScheduleRepo scheduleRepo;
  ScheduleUscase(this.scheduleRepo);

  Future<ScheduleModel> executeScheduleList(ScheduleBody body) async {
    return await scheduleRepo.getSchedule(body);
  }
}
