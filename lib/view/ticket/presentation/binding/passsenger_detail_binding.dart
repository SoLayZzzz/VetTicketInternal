import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/ticket/data/network/passenger_network.dart';
import 'package:vet_internal_ticket/view/ticket/data/repositoriesImpl/passenger_repoImpl.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/passenger_repo.dart';
import 'package:vet_internal_ticket/view/ticket/domain/uscase/passenger_uscase.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/passenger_detail_controller.dart';

class PasssengerDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PassengerNetwork(Get.find()));
    Get.lazyPut(() => PassengerUscase(Get.find()));
    Get.lazyPut<PassengerRepo>(() => PassengerRepoimpl(Get.find()));
    Get.lazyPut<PassengerDetailController>(
        () => PassengerDetailController(Get.find()));
  }
}
