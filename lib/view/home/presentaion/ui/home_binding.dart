import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/home/data/nework/home_data_source.dart';
import 'package:vet_internal_ticket/view/home/data/repositoryImpl/home_repo_impl.dart';
import 'package:vet_internal_ticket/view/home/domain/repositories/home_repo.dart';
import 'package:vet_internal_ticket/view/home/domain/uscase/home_usecase.dart';
import 'package:vet_internal_ticket/view/home/presentaion/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<HomeUsecase>(() => HomeUsecase(Get.find()));
    Get.lazyPut<HomeDataSource>(() => HomeDataSource(Get.find()));
    Get.lazyPut<HomeRepo>(() => HomeRepoImpl(Get.find()));
  }
}
