import 'package:hive/hive.dart';
import 'package:vet_internal_ticket/local_storage/hive_service.dart';

class SettingsStorage {
  static const String _boxName = 'settings_box';

  static const String keyLogin = 'login';
  static const String keyLanguage = 'language';
  static const String keyInitNotificationPage = 'notificationPage';

  late Box _box;

  Future<void> init() async {
    _box = await HiveService.openBox(_boxName);
  }

  Future<void> setLogin(bool value) async {
    await _box.put(keyLogin, value);
  }

  bool? getLogin() {
    return _box.get(keyLogin) as bool?;
  }

  Future<void> clearLogin() async {
    await _box.delete(keyLogin);
  }

  Future<void> setLanguage(String language) async {
    await _box.put(keyLanguage, language);
  }

  String? getLanguage() {
    return _box.get(keyLanguage) as String?;
  }

  Future<void> clearLanguage() async {
    await _box.delete(keyLanguage);
  }

  Future<void> setInitNotificationPage(bool value) async {
    await _box.put(keyInitNotificationPage, value);
  }

  bool? getInitNotificationPage() {
    return _box.get(keyInitNotificationPage) as bool?;
  }

  Future<void> clearInitNotificationPage() async {
    await _box.delete(keyInitNotificationPage);
  }

  Future<void> clearAll() async {
    await Future.wait([
      _box.delete(keyLogin),
      _box.delete(keyLanguage),
      _box.delete(keyInitNotificationPage),
    ]);
  }
}
