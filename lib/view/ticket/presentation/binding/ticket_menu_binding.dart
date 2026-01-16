import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/ticket/data/network/ticket_network_datasource.dart';
import 'package:vet_internal_ticket/view/ticket/data/repositoriesImpl/ticket_repoImpl.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/ticket_reppo.dart';
import 'package:vet_internal_ticket/view/ticket/domain/uscase/ticket_usecase.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/ticket_controller.dart';

class TicketMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TicketNetworkDatasource>(
        () => TicketNetworkDatasource(Get.find()));
    Get.lazyPut<TicketReppo>(() => TicketRepoimpl(Get.find()));
    Get.lazyPut<TicketMenuController>(() => TicketMenuController(Get.find()));
    Get.lazyPut<TicketUsecase>(() => TicketUsecase(Get.find()));
  }
}
