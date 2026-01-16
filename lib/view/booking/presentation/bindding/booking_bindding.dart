import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/booking/data/network/booking_network_datasourece.dart';
import 'package:vet_internal_ticket/view/booking/data/repositpryImpl/booking_repoImpl.dart';
import 'package:vet_internal_ticket/view/booking/domain/repository/booking_repo.dart';
import 'package:vet_internal_ticket/view/booking/domain/uscase/booking_uscase.dart';
import 'package:vet_internal_ticket/view/booking/presentation/controller/booking_controller.dart';

class BookingBindding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingNetworkDatasourece(Get.find()));
    Get.lazyPut<BookingRepo>(() => BookingRepoimpl(Get.find()));
    Get.lazyPut(() => BookingUscase(Get.find()));
    Get.lazyPut(() => BookingController(Get.find()));
  }
}
