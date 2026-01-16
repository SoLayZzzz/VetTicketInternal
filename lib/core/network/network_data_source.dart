// // ignore_for_file: unnecessary_null_comparison, prefer_const_declarations

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/core/app_url/base_url.dart';
import 'package:vet_internal_ticket/core/base/api_error.dart';
import 'package:vet_internal_ticket/utils/preference/app_pref.dart';
import 'package:vet_internal_ticket/view/auth/domain/repsositories/user_repository.dart';
import 'package:vet_internal_ticket/view/auth/presentation/controller/auth_controller.dart';

class NetworkDataSource extends GetConnect {
  final UserRepository _userRepository;
  final AppPref _appPref = AppPref();

  NetworkDataSource(this._userRepository);

  @override
  void onInit() async {
    httpClient.addRequestModifier<dynamic>((request) async {
      // ✅ Add Authorization header if token exists (skip login API)
      if (!request.url.path.endsWith('auth/login')) {
        final tokenType = _userRepository.loginResponse().tokenType ?? 'Bearer';
        final accessToken = await _appPref.getUserToken();

        if (kDebugMode) {
          print("Access Token NetworkDataSource: $accessToken");
        }

        if (accessToken != null) {
          request.headers['Authorization'] = "$tokenType $accessToken";
        }
      }

      // ✅ Append base URL
      const baseUrl = BaseUrl.baseUrlTest;
      final newUrl = Uri.parse('$baseUrl${request.url.path}');
      final query = request.url.queryParameters;

      return request.copyWith(url: newUrl.replace(queryParameters: query));
    });

    httpClient.addResponseModifier((request, response) async {
      // ✅ Debug logs for request/response
      if (kDebugMode) {
        final url = request.url;
        final method = request.method;
        debugPrint('🟢 START $method --> $url');
        debugPrint('👋 Headers: ${request.headers}');
        debugPrint('👋 Response Body: ${response.bodyString}');
        debugPrint('⏩ END $method --> $url');
        final byte = await request.bodyBytes.toBytes();
        debugPrint('🧍 Body: ${utf8.decode(byte)}');
      }

      // ✅ Handle 401 Unauthorized → Try Refresh Token
      if (response.statusCode == HttpStatus.unauthorized) {
        print("⚠️ Unauthorized detected. Attempting token refresh...");
        try {
          final authController = Get.find<AuthController>();
          await authController.loginRefreshToken();

          // ✅ Get new token after refresh
          final newAccessToken = await _appPref.getUserToken();
          if (newAccessToken != null) {
            print("✅ Retrying request with new token...");
            request.headers['Authorization'] = "Bearer $newAccessToken";

            // ✅ Correct retry using send()
            return await httpClient.send(request);
          } else {
            print("❌ No new token found after refresh. Logging out...");
            await authController.logOut();
          }
        } catch (e) {
          print("❌ Token refresh failed: $e");
          AppRoutes.goToLogin();
        }
      }

      return response;
    });

    httpClient.addAuthenticator<dynamic>((request) async {
      // ✅ Add token on retry attempts
      final tokenType = _userRepository.loginResponse().tokenType ?? 'Bearer';
      final accessToken = await _appPref.getUserToken();
      if (accessToken != null) {
        request.headers['Authorization'] = "$tokenType $accessToken";
      }
      return request;
    });

    httpClient.maxAuthRetries = 3;
    super.onInit();
  }

  // ✅ Safe POST wrapper
  Future<T?> safePost<T>(
    String url,
    dynamic body, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    String? contentType,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) async {
    final res = await post(url, body,
        headers: headers,
        query: query,
        contentType: contentType,
        decoder: decoder,
        uploadProgress: uploadProgress);

    if (res.isOk) {
      return res.body;
    }

    throw ApiError(res.bodyString, res.statusCode);
  }
}
