// ignore_for_file: file_names

class LoginRefreshTokenBodyRequest {
  final String deviceId;
  final String refreshToken;

  LoginRefreshTokenBodyRequest(
      {required this.deviceId, required this.refreshToken});

  Map<String, String> toMap() {
    return {'deviceId': deviceId, 'refreshToken': refreshToken};
  }
}
