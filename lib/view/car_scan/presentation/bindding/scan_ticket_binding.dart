import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/car_scan/data/network/scan_network.dart';
import 'package:vet_internal_ticket/view/car_scan/data/respositoryImpl/scan_repoImpl.dart';
import 'package:vet_internal_ticket/view/car_scan/domain/repository/scan_repository.dart';
import 'package:vet_internal_ticket/view/car_scan/domain/uscase/scan_uscase.dart';
import 'package:vet_internal_ticket/view/car_scan/presentation/controller/scan_ticket_controller.dart';

class ScanTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScanNetwork(Get.find()));
    Get.lazyPut<ScanRepository>(() => ScanRepoimpl(Get.find()));
    Get.lazyPut(() => ScanUscase(Get.find()));
    Get.lazyPut(() => ScanTicketController(Get.find()));
  }
}
