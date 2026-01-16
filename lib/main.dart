import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vet_internal_ticket/app_binding.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/booking_service.dart';
import 'utils/colors.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
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
      initialBinding: AppBinding(),
    );
  }
}
