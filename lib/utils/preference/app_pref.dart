import 'package:get/get.dart';
import 'package:vet_internal_ticket/local_storage/auth_storage.dart';
import 'package:vet_internal_ticket/local_storage/settings_storage.dart';

class AppPref {
  // pref for token
  Future<void> setUserToken(String value) async {
    await Get.find<AuthStorage>().saveAccessToken(value);
  }

  Future<String?> getUserToken() async {
    return Get.find<AuthStorage>().getAccessTOKEN();
  }

  Future<void> removeToken() async {
    await Get.find<AuthStorage>().deleteToken();
  }

  // pref for refresh_token
  Future<void> setRefreshToken(String refreshToken) async {
    await Get.find<AuthStorage>().saveRefreshToken(refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return Get.find<AuthStorage>().getRefreshToken();
  }

  Future<void> clearRefreshToken() async {
    await Get.find<AuthStorage>().deleteToken();
  }

  // pref for login
  Future<void> setLogin() async {
    await Get.find<SettingsStorage>().setLogin(true);
  }

  Future<bool?> getLogin() async {
    return Get.find<SettingsStorage>().getLogin();
  }

  Future<void> clearLogin() async {
    await Get.find<SettingsStorage>().clearLogin();
  }

  // pref for language
  Future<void> setLanguage(String language) async {
    await Get.find<SettingsStorage>().setLanguage(language);
  }

  Future<String?> getLanguage() async {
    return Get.find<SettingsStorage>().getLanguage();
  }

  Future<void> clearLanguage() async {
    await Get.find<SettingsStorage>().clearLanguage();
  }

  // pref for notification page
  Future<void> setInitNotificationPage(bool value) async {
    await Get.find<SettingsStorage>().setInitNotificationPage(value);
  }

  Future<bool?> getInitNotificationPage() async {
    return Get.find<SettingsStorage>().getInitNotificationPage();
  }

  Future<void> clearInitNotificationPage() async {
    await Get.find<SettingsStorage>().clearInitNotificationPage();
  }

  Future<void> clear() async {
    await Future.wait([
      Get.find<AuthStorage>().deleteToken(),
      Get.find<SettingsStorage>().clearAll(),
    ]);
  }
}
