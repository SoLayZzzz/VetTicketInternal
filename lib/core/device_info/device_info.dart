import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DeviceInfo {
  String? _deviceInfo;

  Future<String> getDeviceInfo() async {
    if (_deviceInfo == null) _deviceInfo = await _initDeviceInfo();
    return _deviceInfo!;
  }

  Map<String, String> parseDeviceInfo(String deviceInfo) {
    final deviceData = jsonDecode(deviceInfo);

    String deviceId;
    String deviceName;

    if (defaultTargetPlatform == TargetPlatform.android) {
      deviceId = deviceData['androidId'] ??
          deviceData['serialNumber'] ??
          'unknown_android_id';
      deviceName = '${deviceData['brand']} ${deviceData['model']}';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      deviceId = deviceData['identifierForVendor'] ?? 'unknown_ios_id';
      deviceName = '${deviceData['name']} ${deviceData['model']}';
    } else {
      deviceId = 'unknown_device_id';
      deviceName = 'unknown_device';
    }

    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
    };
  }

  Future<String> _initDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var deviceData = <String, dynamic>{};
    try {
      deviceData = switch (defaultTargetPlatform) {
        TargetPlatform.android =>
          _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
        TargetPlatform.iOS =>
          _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
        _ => <String, dynamic>{'Error:': 'platform isn\'t supported'},
      };
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    return jsonEncode(deviceData);
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'androidId': build.id, // Using id as androidId
      // 'isLowRamDevice': build.isLowRamDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'device_uuid': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'sysname': data.utsname.sysname,
      'nodename': data.utsname.nodename,
      'release': data.utsname.release,
      'version': data.utsname.version,
      'machine': data.utsname.machine,
    };
  }
}
