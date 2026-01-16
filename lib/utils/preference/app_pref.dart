import 'package:shared_preferences/shared_preferences.dart';

import '../static.dart';

class AppPref {
  // pref for token
  Future<void> setUserToken(String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(Static.keyAccessToken, value);
  }

  Future<String?> getUserToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(Static.keyAccessToken);
  }

  Future<void> removeToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(Static.keyAccessToken);
  }

  // pref for refresh_token
  Future<void> setRefreshToken(String refreshToken) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(Static.refreshToken, refreshToken);
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(Static.refreshToken);
  }

  Future<void> clearRefreshToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove(Static.refreshToken);
  }

  // pref for login
  Future<void> setLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool(Static.keyLogin, true);
  }

  Future<bool?> getLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(Static.keyLogin);
  }

  Future<void> clearLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove(Static.keyLogin);
  }

  // pref for language
  Future<void> setLanguage(String language) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(Static.keyLanguage, language);
  }

  Future<String?> getLanguage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(Static.keyLanguage);
  }

  Future<void> clearLanguage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove(Static.keyLanguage);
  }

  // pref for notification page
  Future<void> setInitNotificationPage(bool value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool(Static.keyInitNotificationPage, value);
  }

  Future<bool?> getInitNotificationPage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(Static.keyInitNotificationPage);
  }

  Future<void> clearInitNotificationPage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove(Static.keyInitNotificationPage);
  }

  Future<void> clear() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await Future.wait([
      sp.remove(Static.keyAccessToken),
      sp.remove(Static.refreshToken),
      sp.remove(Static.keyLogin),
      sp.remove(Static.keyLanguage),
      sp.remove(Static.keyInitNotificationPage),
    ]);
  }
}
