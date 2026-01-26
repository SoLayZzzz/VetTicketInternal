import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/schedule_detail_controller.dart';

class ScheduleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScheduleDetailController());
  }
}
