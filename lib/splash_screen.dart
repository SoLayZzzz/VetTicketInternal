import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_image.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/local_storage/auth_storage.dart';
import 'package:vet_internal_ticket/view/auth/data/network/auth_network_data_source.dart';
import 'package:vet_internal_ticket/view/auth/data/repositoriesImpl/user_password_auth_repositoryImpl.dart';
import 'package:vet_internal_ticket/view/auth/domain/repsositories/auth_repository.dart';
import 'package:vet_internal_ticket/view/auth/presentation/controller/auth_controller.dart';
import 'package:vet_internal_ticket/view/home/presentaion/controller/home_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthStorage _authStorage = Get.find<AuthStorage>();
  bool _navigated = false; // ✅ Prevent multiple navigations

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _verifySession());
  }

  Future<void> _verifySession() async {
    if (_navigated) return; // ✅ Ensure this runs only once
    _navigated = true;

    final accessToken = _authStorage.getAccessTOKEN();

    if (kDebugMode) {
      print('🔹 Splash Auth Check: Token=${accessToken != null}');
    }

    if (accessToken != null) {
      try {
        final ok = await Get.find<AuthController>().loginCheckToken();

        if (!ok) {
          Get.offAllNamed(AppRoutes.loginScreen);
          return;
        }

        // ✅ Navigate only if not already on Home
        if (Get.currentRoute != AppRoutes.homeScreen) {
          Get.offAllNamed(AppRoutes.homeScreen);
        }
      } catch (e) {
        print('⚠️ Token check failed: $e');
        Get.offAllNamed(AppRoutes.loginScreen);
      }
    } else {
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppImages.APP_LOGO_2, width: 250),
      ),
    );
  }
}

class SplashBindding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => AuthNetworkDataSource(Get.find()));
    Get.lazyPut<AuthRepository>(
        () => UserPasswordAuthRepositoryimpl(Get.find(), Get.find()));
    Get.lazyPut(() => AuthController(Get.find()));
  }
}
