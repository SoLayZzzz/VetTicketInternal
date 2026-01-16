import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/auth/data/network/auth_network_data_source.dart';
import 'package:vet_internal_ticket/view/auth/data/repositoriesImpl/user_password_auth_repositoryImpl.dart';
import 'package:vet_internal_ticket/view/auth/domain/repsositories/auth_repository.dart';
import 'package:vet_internal_ticket/view/auth/presentation/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthNetworkDataSource(Get.find()));
    Get.lazyPut<AuthRepository>(
        () => UserPasswordAuthRepositoryimpl(Get.find(), Get.find()));
    Get.lazyPut(() => AuthController(Get.find()));
  }
}
