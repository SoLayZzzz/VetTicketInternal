import 'package:hive_flutter/hive_flutter.dart';

class AuthStorage {
  static const String _authBox = 'auth_box';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';

  late Box _box;

  Future<void> innit() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_authBox);
  }

// =============== Access Token ================

  Future<void> saveAccessToken(String accessToken) async {
    await _box.put(_keyAccessToken, accessToken);
  }

  String? getAccessTOKEN() {
    return _box.get(_keyAccessToken);
  }

  // =============== Refresh Token ================
  Future<void> saveRefreshToken(String refreshToken) async {
    await _box.put(_keyRefreshToken, refreshToken);
  }

  String? getRefreshToken() {
    return _box.get(_keyRefreshToken);
  }

  // Delete
  Future<void> deleteToken() async {
    await _box.delete(_keyAccessToken);
    await _box.delete(_keyRefreshToken);
  }
}
