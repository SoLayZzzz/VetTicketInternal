import 'package:json_annotation/json_annotation.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_checkToken.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_get_reportToken.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_permission.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_refresh_token.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/login_response.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/logout_response.dart';

part 'user_data.g.dart';

@JsonSerializable()
class AppConfig {
  String? locale;
  AppConfig({this.locale});

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}

@JsonSerializable()
class UserData {
  LoginResponse? loginResponse;
  LogoutResponse? logoutResponse;
  AuthRefreshTokenResponse? authRefreshTokenResponse;
  AuthCheckPermissionResponse? authCheckPermissionResponse;
  AuthGetReportTokenResponse? authGetReportTokenResponse;
  AuthCheckTokenResponse? authCheckTokenResponse;

  AppConfig? appConfig;
  UserData({this.loginResponse, this.appConfig});

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
