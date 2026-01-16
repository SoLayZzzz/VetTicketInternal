import 'package:get_storage/get_storage.dart';

class GetStorageService {
  final GetStorage _box = GetStorage();

  String? get(String key) => _box.read(key);

  void set(String key, String value) => _box.write(key, value);

  void remove(String key) => _box.remove(key);

  void clear() => _box.erase();
}
