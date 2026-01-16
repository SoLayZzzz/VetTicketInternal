// ignore_for_file: file_names

import 'dart:convert';
import 'package:vet_internal_ticket/core/local/get_storage_service.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_checkToken.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_get_reportToken.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_permission.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_refresh_token.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/login_response.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/logout_response.dart';
import 'package:vet_internal_ticket/view/auth/data/model/user_data.dart';
import 'package:vet_internal_ticket/view/auth/domain/repsositories/user_repository.dart';

class UserRepositoryimpl implements UserRepository {
  late UserData _userData;
  final GetStorageService _getStorageService;
  final String _userKey = "VET_TICKET_USER_DATA";

  UserRepositoryimpl(this._getStorageService) {
    _userData = _getUserData();
  }

  @override
  AppConfig appConfig() => _userData.appConfig ?? AppConfig();

  @override
  void clear() => _getStorageService.clear();

  @override
  bool isLogin() => _userData.loginResponse?.accessToken != null;

  @override
  LoginResponse loginResponse() => _userData.loginResponse ?? LoginResponse();

  @override
  void setAppConfig(AppConfig appConfig) {
    _userData.appConfig = appConfig;
    _setUserData(_userData);
  }

  @override
  void setLoginResponse(LoginResponse loginResponse) {
    _userData.loginResponse = loginResponse;
    _setUserData(_userData);
  }

  UserData _getUserData() {
    final json = _getStorageService.get(_userKey);
    if (json == null) {
      final UserData userData = UserData();
      _setUserData(userData);
      return userData;
    }
    final map = jsonDecode(json) as Map<String, dynamic>;
    return UserData.fromJson(map);
  }

  void _setUserData(UserData userData) {
    final String json = jsonEncode(userData.toJson());
    _getStorageService.set(_userKey, json);
  }

  @override
  void setLogOutResponse(LogoutResponse logOutResponse) {
    _userData.logoutResponse = logOutResponse;
    _setUserData(_userData);
  }

  @override
  void setLoginCheckPermission() {
    _userData.authCheckPermissionResponse = AuthCheckPermissionResponse();
    _setUserData(_userData);
  }

  @override
  void setLoginCheckToken() {
    _userData.authCheckTokenResponse = AuthCheckTokenResponse();
    _setUserData(_userData);
  }

  @override
  void setLoginGetReportToken() {
    _userData.authGetReportTokenResponse = AuthGetReportTokenResponse();
    _setUserData(_userData);
  }

  @override
  void setLoginRefreshToken(AuthRefreshTokenResponse authRefreshToken) {
    _userData.authRefreshTokenResponse = authRefreshToken;
    _setUserData(_userData);
  }
}
