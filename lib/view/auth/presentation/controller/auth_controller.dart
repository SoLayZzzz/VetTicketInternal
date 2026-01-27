// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/core/base/api_error.dart';
import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/core/device_info/device_info.dart';
import 'package:vet_internal_ticket/local_storage/auth_storage.dart';
import 'package:vet_internal_ticket/view/auth/data/model/request/logOut_body.dart';
import 'package:vet_internal_ticket/view/auth/data/model/request/login_body.dart';
import 'package:vet_internal_ticket/view/auth/data/model/request/login_refreshToken_body_request.dart';
import 'package:vet_internal_ticket/view/auth/domain/repsositories/auth_repository.dart';
import 'package:vet_internal_ticket/view/auth/presentation/state/auth_state.dart';

class AuthController extends StateController<AuthState> {
  AuthController(this._authRepository);

  final AuthRepository _authRepository;
  final DeviceInfo _deviceInfo = DeviceInfo();
  final AuthStorage _authStorage = Get.find<AuthStorage>();
  final userController = TextEditingController(text: "admin");
  final passwordController = TextEditingController(text: "123");
  // Hive

  @override
  AuthState onInitUiState() => AuthState();

  @override
  void onInit() {
    super.onInit();
    loginCheckPermission();
  }

  void onTapLogin(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      uiState.update((val) => val?.isLoading = true);

      final deviceInfo = await _deviceInfo.getDeviceInfo();
      final deviceData = _deviceInfo.parseDeviceInfo(deviceInfo);

      final body = LoginUserPasswordBody(
        deviceId: deviceData['deviceId'] ?? 'unknown_device_id',
        deviceName: deviceData['deviceName'] ?? 'unknown_device',
        username: userController.text,
        password: passwordController.text,
      );

      print("Device ID : ${deviceData['deviceId'] ?? 'unknown_device_id'}");
      final response = await _authRepository.login(body);

      if (response != null &&
          response.statusCode == 200 &&
          response.body != null) {
        await _saveTokens(response.body!);

        uiState.update((val) {
          val?.isLoading = false;
          val?.status = response.statusCode!;
          val?.loginResponse = response.body;
          val?.errorLogin = "";
        });
        goToRoute(status: response.statusCode!, form: formKey);
      } else {
        print("🚫 Login failed:");
        print("🔹 Status Code: ${response?.statusCode}");
        print("🔹 Response Body: ${response?.body}");

        uiState.update((val) {
          val?.isLoading = false;
          val?.status = response?.statusCode ?? 400;
          val?.errorLogin = response?.body?.toString() ?? "Login failed";
        });
      }
    } on ApiError catch (error) {
      print('=== LOGIN ERROR ===');
      print('Error status: ${error.statusCode}');
      print('Error message: ${error.message}');
      print('===================');
      uiState.update((val) {
        val?.isLoading = false;
        val?.status = error.statusCode ?? 400;
        val?.errorLogin = error.message ?? "Login failed";
      });
    } catch (e) {
      uiState.update((val) {
        val?.isLoading = false;
        val?.status = 400;
        val?.errorLogin = "An unexpected error occurred";
      });
    }
  }

  Future<void> _saveTokens(dynamic loginResponse) async {
    print('=== START TOKEN SAVING ===');

    print('🔹 Full login response: $loginResponse');
    final accessToken = loginResponse.accessToken;
    final refreshToken = loginResponse.refreshToken;
    final tokenType = loginResponse.tokenType;

    print('🔹 Access token to save: $accessToken');
    print('🔹 Refresh token to save: $refreshToken');
    print('🔹 Token Type: $tokenType');

    if (accessToken != null) {
      await _authStorage.saveAccessToken(accessToken);

      final savedAccessToken = _authStorage.getAccessTOKEN();
      print('🔹 Saved access token: $savedAccessToken');
    } else {
      print('⚠️ Access token is null - not saved');
    }

    if (refreshToken != null) {
      await _authStorage.saveRefreshToken(refreshToken);

      final savedRefreshToken = _authStorage.getRefreshToken();
      print('🔹 Saved refresh token: $savedRefreshToken');
    } else {
      print('⚠️ Refresh token is null - not saved');
    }

    print('=== END TOKEN SAVING ===');
  }

  goToRoute({int status = 0, GlobalKey<FormState>? form}) {
    if (status == 200) {
      Get.offAllNamed(AppRoutes.homeScreen);
      return;
    }

    uiState.update((val) => val!.isLoading = false);
    if (!form!.currentState!.validate()) return;
  }

  // ---------------------------
  // ✅ LOGOUT
  // ---------------------------

  Future<void> logOut() async {
    try {
      // ✅ Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final deviceInfo = await _deviceInfo.getDeviceInfo();
      final deviceData = _deviceInfo.parseDeviceInfo(deviceInfo);

      final logoutBody = LogoutBody(
        deviceId: deviceData['deviceId'] ?? 'unknown_device_id',
      );

      final response = await _authRepository.logOut(logoutBody);

      // ✅ Dismiss loading dialog
      Get.back();

      if (response != null &&
          response.statusCode == 200 &&
          response.body?.body?.status == true) {
      } else {
        Get.offAllNamed(AppRoutes.homeScreen);
      }

      await _authStorage.deleteToken();
      _authRepository.userRepository.clear();

      Get.offAllNamed(AppRoutes.loginScreen);
    } catch (e) {
      // Ensure loading is removed even on error
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      print("❌ Logout Exception: $e");
    }
  }

  // ---------------------------
  // ✅ LOGIN WITH REFRESH TOKEN
  // ---------------------------
  Future<void> loginRefreshToken() async {
    try {
      uiState.update((val) => val?.isLoading = true);

      final deviceInfo = await _deviceInfo.getDeviceInfo();
      final deviceData = _deviceInfo.parseDeviceInfo(deviceInfo);
      final refreshToken = _authStorage.getRefreshToken();

      if (refreshToken == null) {
        print("⚠️ No refresh token found, redirecting to login.");
        await logOut();
        return;
      }

      final body = LoginRefreshTokenBodyRequest(
        deviceId: deviceData['deviceId'] ?? 'unknown_device_id',
        refreshToken: refreshToken,
      );

      final response = await _authRepository.loginRefreshToken(body);

      if (response != null &&
          response.statusCode == 200 &&
          response.body?.body != null) {
        final newToken = response.body!.body!;
        await _saveRefreshToken(newToken.accessToken!, newToken.refreshToken!);
        _authRepository.userRepository.setLoginRefreshToken(response.body!);

        print("✅ Token refreshed successfully");
      } else {
        print("❌ Refresh token failed, logging out.");
        await logOut();
      }
    } catch (e) {
      print("❌ Exception during refresh token: $e");
      await logOut();
    } finally {
      uiState.update((val) => val?.isLoading = false);
    }
  }

  Future<void> _saveRefreshToken(
      String accessToken, String refreshToken) async {
    await _authStorage.saveAccessToken(accessToken);
    await _authStorage.saveRefreshToken(refreshToken);
    print("🔹 New tokens saved: AccessToken=$accessToken");
  }

  // ---------------------------
  // ✅ CHECK PERMISSION
  // ---------------------------

  Future<void> loginCheckPermission() async {
    try {
      uiState.update((val) => val?.isLoading = true);
      final response = await _authRepository.loginCheckPermission();

      if (response != null &&
          response.statusCode == 200 &&
          response.body != null) {
        print("✅ Permission data: ${response.body}");

        // Save permission in UserRepository
        _authRepository.userRepository.setLoginCheckPermission();
      } else {
        print("⚠️ Permission check failed");
      }
    } catch (e) {
      print("❌ Exception in check permission: $e");
    } finally {
      uiState.update((val) => val?.isLoading = false);
    }
  }

  // ---------------------------
  // ✅ CHECK TOKEN
  // ---------------------------
  Future<void> loginCheckToken() async {
    try {
      uiState.update((val) => val?.isLoading = true);
      final response = await _authRepository.loginCheckToken();

      if (response != null && response.statusCode == 200) {
        print("✅ Token check response: ${response.body?.body}");
        _authRepository.userRepository.setLoginCheckToken();
      } else {
        print("⚠️ Token check failed, trying refresh...");
        await loginRefreshToken();
      }
    } catch (e) {
      print("❌ Exception in token check: $e");
    } finally {
      uiState.update((val) => val?.isLoading = false);
    }
  }

  // ---------------------------
  // ✅ GET REPORT TOKEN
  // ---------------------------
  Future<void> loginGetReportToken() async {
    try {
      uiState.update((val) => val?.isLoading = true);
      final response = await _authRepository.loginGetReportToken();

      if (response != null && response.statusCode == 200) {
        print("✅ Report token response: ${response.body?.body?.toJson()}");
        _authRepository.userRepository.setLoginGetReportToken();
      } else {
        print("⚠️ Failed to get report token");
      }
    } catch (e) {
      print("❌ Exception in get report token: $e");
    } finally {
      uiState.update((val) => val?.isLoading = false);
    }
  }
}
