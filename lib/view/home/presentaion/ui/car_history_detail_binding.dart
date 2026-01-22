import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/home/data/nework/booking_history_network_datasource.dart';
import 'package:vet_internal_ticket/view/home/data/repositoryImpl/booking_history_repo_impl.dart';
import 'package:vet_internal_ticket/view/home/domain/repositories/booking_history_repo.dart';
import 'package:vet_internal_ticket/view/home/domain/uscase/booking_history_usecase.dart';
import 'package:vet_internal_ticket/view/home/presentaion/controller/car_history_detail_controller.dart';

class CarHistoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<BookingHistoryNetworkDatasource>()) {
      Get.lazyPut(() => BookingHistoryNetworkDatasource(Get.find()));
    }
    if (!Get.isRegistered<BookingHistoryRepo>()) {
      Get.lazyPut<BookingHistoryRepo>(() => BookingHistoryRepoImpl(Get.find()));
    }
    if (!Get.isRegistered<BookingHistoryUsecase>()) {
      Get.lazyPut(() => BookingHistoryUsecase(Get.find()));
    }

    Get.lazyPut(() => CarHistoryDetailController(Get.find()));
  }
}
