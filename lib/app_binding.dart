// import 'package:get/get.dart';
// import 'package:vet_internal_ticket/core/local/get_storage_service.dart';
// import 'package:vet_internal_ticket/core/network/network_data_source.dart';
// import 'package:vet_internal_ticket/utils/preference/app_pref.dart';
// import 'package:vet_internal_ticket/view/auth/data/repositoriesImpl/user_repositoryImpl.dart';
// import 'package:vet_internal_ticket/view/auth/domain/repsositories/user_repository.dart';

// class AppBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(GetStorageService(), permanent: true);
//     Get.put<UserRepository>(UserRepositoryimpl(Get.find()), permanent: true);
//     Get.put(NetworkDataSource(Get.find()), permanent: true);
//     Get.put(AppPref(), permanent: true);
//   }
// }

import 'package:get/get.dart';
import 'package:vet_internal_ticket/core/local/get_storage_service.dart';
import 'package:vet_internal_ticket/core/network/network_data_source.dart';
import 'package:vet_internal_ticket/utils/preference/app_pref.dart';
import 'package:vet_internal_ticket/view/auth/data/network/auth_network_data_source.dart';
import 'package:vet_internal_ticket/view/auth/data/repositoriesImpl/user_password_auth_repositoryImpl.dart';
import 'package:vet_internal_ticket/view/auth/data/repositoriesImpl/user_repositoryImpl.dart';
import 'package:vet_internal_ticket/view/auth/domain/repsositories/auth_repository.dart';
import 'package:vet_internal_ticket/view/auth/domain/repsositories/user_repository.dart';
import 'package:vet_internal_ticket/view/auth/presentation/controller/auth_controller.dart';
import 'package:vet_internal_ticket/view/printer/controller/printer_settingVewModel.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GetStorageService(), permanent: true);
    Get.put(AppPref(), permanent: true);

    Get.put(PrinterSettingController());



    Get.put<UserRepository>(UserRepositoryimpl(Get.find()), permanent: true);
    Get.put(NetworkDataSource(Get.find()), permanent: true);
    Get.put(AuthNetworkDataSource(Get.find()), permanent: true);

    Get.put<AuthRepository>(
      UserPasswordAuthRepositoryimpl(Get.find(), Get.find()),
      permanent: true,
    );
    Get.put(AuthController(Get.find()), permanent: true);
  }
}
