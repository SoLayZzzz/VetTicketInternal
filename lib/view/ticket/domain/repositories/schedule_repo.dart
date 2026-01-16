import 'package:vet_internal_ticket/view/ticket/data/model/request/schedule_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/schedule_response.dart';

abstract class ScheduleRepo {
  Future<ScheduleModel> getSchedule(ScheduleBody body);
}
