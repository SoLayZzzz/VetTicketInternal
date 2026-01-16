// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginUserPasswordBody _$LoginUserPasswordBodyFromJson(
        Map<String, dynamic> json) =>
    LoginUserPasswordBody(
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginUserPasswordBodyToJson(
        LoginUserPasswordBody instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'password': instance.password,
      'username': instance.username,
    };
