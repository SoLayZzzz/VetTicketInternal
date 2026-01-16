import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/ticket/data/network/schedule_network.dart';
import 'package:vet_internal_ticket/view/ticket/data/repositoriesImpl/schedule_repoImpl.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/schedule_repo.dart';
import 'package:vet_internal_ticket/view/ticket/domain/uscase/schedule_uscase.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/schedule_controller.dart';

class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScheduleNetwork(Get.find()));
    Get.lazyPut(() => ScheduleUscase(Get.find()));
    Get.lazyPut<ScheduleRepo>(() => ScheduleRepoimpl(Get.find()));
    Get.lazyPut(() => ScheduleController(Get.find()));
  }
}
