import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

//* scrollable
ScrollPhysics getScrollPhysics() {
  return Platform.isIOS
      ? const BouncingScrollPhysics()
      : const AlwaysScrollableScrollPhysics();
}

// //* Device ID
// Future<String?> getDeviceId() async {
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//     return iosInfo.utsname.sysname;
//   } else if (Platform.isAndroid) {
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     return androidInfo.id;
//   }
//   return 'Unknown';
// }

// //* Device Name
// Future<String?> getDeviceName() async {
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//     return iosInfo.utsname.machine;
//   } else if (Platform.isAndroid) {
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     return androidInfo.model;
//   }
//   return 'Unknown';
// }

// * Check length input
String? checkLength(
    String value, int length, String nullInfo, String lengthInfo) {
  if (value == '') {
    return nullInfo;
  } else if (value.length < length) {
    return lengthInfo;
  }
  return null;
}

// * Check length input for phone number
String? checkLengthPhone(String value, int minLength, int maxLength,
    String nullInfo, String lengthInfo) {
  if (value == '') {
    return nullInfo;
  } else if (value.length < minLength || value.length > maxLength) {
    return lengthInfo;
  }
  return null;
}

// * Check match length
String? checkMatch(String value1, String value2, String matchInfo) {
  if (value1 != value2) {
    return matchInfo;
  }
  return null;
}

String? validateEmail(String? value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Invalid format email address'
      : null;
}
