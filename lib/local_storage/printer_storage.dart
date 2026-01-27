import 'package:hive/hive.dart';
import 'package:vet_internal_ticket/local_storage/hive_service.dart';

class PrinterStorage {
  static const String _boxName = 'printer_box';

  static const String keyPaperSize = 'size';
  static const String keyPrinterAddress = 'printer_address';
  static const String keyPrinterName = 'printer_name';
  static const String keyPrinterType = 'printer_type';

  late Box _box;

  Future<void> init() async {
    _box = await HiveService.openBox(_boxName);
  }

  Future<void> setPaperSize(String value) async {
    await _box.put(keyPaperSize, value);
  }

  String? getPaperSize() {
    return _box.get(keyPaperSize) as String?;
  }

  Future<void> setPrinterDetails({
    required String address,
    required String name,
    required String type,
  }) async {
    await Future.wait([
      _box.put(keyPrinterAddress, address),
      _box.put(keyPrinterName, name),
      _box.put(keyPrinterType, type),
    ]);
  }

  Map<String, String?> getPrinterDetails() {
    return {
      'address': _box.get(keyPrinterAddress) as String?,
      'name': _box.get(keyPrinterName) as String?,
      'type': _box.get(keyPrinterType) as String?,
    };
  }

  Future<void> clear() async {
    await Future.wait([
      _box.delete(keyPaperSize),
      _box.delete(keyPrinterAddress),
      _box.delete(keyPrinterName),
      _box.delete(keyPrinterType),
    ]);
  }
}
