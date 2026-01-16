// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
      locale: json['locale'] as String?,
    );

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
      'locale': instance.locale,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      loginResponse: json['loginResponse'] == null
          ? null
          : LoginResponse.fromJson(
              json['loginResponse'] as Map<String, dynamic>),
      appConfig: json['appConfig'] == null
          ? null
          : AppConfig.fromJson(json['appConfig'] as Map<String, dynamic>),
    )
      ..logoutResponse = json['logoutResponse'] == null
          ? null
          : LogoutResponse.fromJson(
              json['logoutResponse'] as Map<String, dynamic>)
      ..authRefreshTokenResponse = json['authRefreshTokenResponse'] == null
          ? null
          : AuthRefreshTokenResponse.fromJson(
              json['authRefreshTokenResponse'] as Map<String, dynamic>)
      ..authCheckPermissionResponse =
          json['authCheckPermissionResponse'] == null
              ? null
              : AuthCheckPermissionResponse.fromJson(
                  json['authCheckPermissionResponse'] as Map<String, dynamic>)
      ..authGetReportTokenResponse = json['authGetReportTokenResponse'] == null
          ? null
          : AuthGetReportTokenResponse.fromJson(
              json['authGetReportTokenResponse'] as Map<String, dynamic>)
      ..authCheckTokenResponse = json['authCheckTokenResponse'] == null
          ? null
          : AuthCheckTokenResponse.fromJson(
              json['authCheckTokenResponse'] as Map<String, dynamic>);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'loginResponse': instance.loginResponse,
      'logoutResponse': instance.logoutResponse,
      'authRefreshTokenResponse': instance.authRefreshTokenResponse,
      'authCheckPermissionResponse': instance.authCheckPermissionResponse,
      'authGetReportTokenResponse': instance.authGetReportTokenResponse,
      'authCheckTokenResponse': instance.authCheckTokenResponse,
      'appConfig': instance.appConfig,
    };
