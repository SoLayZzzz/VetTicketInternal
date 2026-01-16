import 'package:json_annotation/json_annotation.dart';

part 'login_body.g.dart';

sealed class LoginBody {}

@JsonSerializable()
class LoginUserPasswordBody extends LoginBody {
  final String deviceId, deviceName, password, username;
  LoginUserPasswordBody({
    required this.deviceId,
    required this.deviceName,
    required this.username,
    required this.password,
  });

  factory LoginUserPasswordBody.fomJson(Map<String, dynamic> json) =>
      _$LoginUserPasswordBodyFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserPasswordBodyToJson(this);
}
