import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/ticket/data/network/seat_network.dart';
import 'package:vet_internal_ticket/view/ticket/data/repositoriesImpl/seat_repoImpl.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/seat_repo.dart';
import 'package:vet_internal_ticket/view/ticket/domain/uscase/seat_uscase.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/seat_controller.dart';

class SeatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SeatNetwork(Get.find()));
    Get.lazyPut<SeatRepo>(() => SeatRepoImpl(Get.find()));
    Get.lazyPut(() => SeatUscase(Get.find()));
    Get.lazyPut(() => SeatController(Get.find()));
  }
}
