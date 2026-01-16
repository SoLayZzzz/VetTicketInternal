import 'package:vet_internal_ticket/core/app_url/auth_url.dart';
import 'package:vet_internal_ticket/core/base/header.dart';
import 'package:vet_internal_ticket/core/network/network_data_source.dart';
import 'package:vet_internal_ticket/view/auth/data/model/request/logOut_body.dart';
import 'package:vet_internal_ticket/view/auth/data/model/request/login_body.dart';
import 'package:vet_internal_ticket/view/auth/data/model/request/login_refreshToken_body_request.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_checkToken.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_get_reportToken.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_permission.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_refresh_token.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/login_response.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/logout_response.dart';

class AuthNetworkDataSource {
  final NetworkDataSource networkDataSource;

  AuthNetworkDataSource(this.networkDataSource);

  Future<Header<LoginResponse>?> loginUserPassword(
          LoginUserPasswordBody loginBody) =>
      networkDataSource.safePost(
        AuthUrl.authLogin,
        loginBody.toJson(),
        query: {
          'deviceId': loginBody.deviceId,
          'deviceName': loginBody.deviceName,
          'password': loginBody.password,
          'username': loginBody.username,
        },
        decoder: (data) => Header<LoginResponse>.fromJson(data,
            (json) => LoginResponse.fromJson(json as Map<String, dynamic>)),
      );

  Future<Header<LogoutResponse>?> logOut(LogoutBody body) =>
      networkDataSource.safePost(
        AuthUrl.authLogout,
        body.toMap(),
        query: {'deviceId': body.deviceId},
        decoder: (data) => Header<LogoutResponse>.fromJson(data,
            (json) => LogoutResponse.fromJson(json as Map<String, dynamic>)),
      );

  Future<Header<AuthRefreshTokenResponse>?> loginRefreshToken(
          LoginRefreshTokenBodyRequest body) =>
      networkDataSource.safePost(
        AuthUrl.authLoginWithRefreshToken,
        body.toMap(),
        query: {'deviceId': body.deviceId, 'refreshToken': body.refreshToken},
        decoder: (data) => Header<AuthRefreshTokenResponse>.fromJson(
            data,
            (json) => AuthRefreshTokenResponse.fromJson(
                json as Map<String, dynamic>)),
      );

  Future<Header<AuthCheckPermissionResponse>?> loginCheckPermission() =>
      networkDataSource.safePost(
        AuthUrl.authCheckPermission,
        null,
        decoder: (data) => Header<AuthCheckPermissionResponse>.fromJson(
            data,
            (json) => AuthCheckPermissionResponse.fromJson(
                json as Map<String, dynamic>)),
      );

  Future<Header<AuthCheckTokenResponse>?> loginCheckToken() =>
      networkDataSource.safePost(
        AuthUrl.authCheckToken,
        null,
        decoder: (data) => Header<AuthCheckTokenResponse>.fromJson(
            data, (json) => AuthCheckTokenResponse.fromJson(json)),
      );

  Future<Header<AuthGetReportTokenResponse>?> loginGetReportToken() =>
      networkDataSource.safePost(
        AuthUrl.authGetReportToken,
        null,
        decoder: (data) => Header<AuthGetReportTokenResponse>.fromJson(
            data,
            (json) => AuthGetReportTokenResponse.fromJson(
                json as Map<String, dynamic>)),
      );
}
