// ignore_for_file: file_names

class LogoutBody {
  final String deviceId;

  LogoutBody({required this.deviceId});

  Map<String, String> toMap() {
    return {'deviceId': deviceId};
  }
}
