import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vet_internal_ticket/app_binding.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/booking_service.dart';
import 'package:vet_internal_ticket/local_storage/auth_storage.dart';
import 'package:vet_internal_ticket/local_storage/hive_service.dart';
import 'package:vet_internal_ticket/local_storage/printer_storage.dart';
import 'package:vet_internal_ticket/local_storage/settings_storage.dart';
import 'theme/app_colors.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await HiveService.init();

  final authStorage = AuthStorage();
  await authStorage.innit();
  Get.put<AuthStorage>(authStorage, permanent: true);

  final settingsStorage = SettingsStorage();
  await settingsStorage.init();
  Get.put<SettingsStorage>(settingsStorage, permanent: true);

  final printerStorage = PrinterStorage();
  await printerStorage.init();
  Get.put<PrinterStorage>(printerStorage, permanent: true);

  Get.put(BookingService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: getPrimaryMaterialColor(Colors.red),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(primary: const MaterialColor(0xFF312783, <int, Color>{})),
      ),
      debugShowCheckedModeBanner: false,
      getPages: getPages,
      initialRoute: AppRoutes.splashScreen,
      // initialRoute: AppRoutes.homeScreen,
      initialBinding: AppBinding(),
    );
  }
}
