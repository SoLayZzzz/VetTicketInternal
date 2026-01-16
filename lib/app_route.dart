// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/auth/auth_binding.dart';
import 'package:vet_internal_ticket/view/auth/presentation/ui/login_screen.dart';
import 'package:vet_internal_ticket/view/booking/presentation/bindding/booking_bindding.dart';
import 'package:vet_internal_ticket/view/booking/presentation/ui/booking_detail_screen.dart';
import 'package:vet_internal_ticket/view/car_scan/presentation/bindding/scan_ticket_binding.dart';
import 'package:vet_internal_ticket/view/car_scan/presentation/ui/other/scan_ticket_screen.dart';
import 'package:vet_internal_ticket/view/bus/presentaion/ui/bus_screen.dart';
import 'package:vet_internal_ticket/view/car_scan/presentation/ui/scan/bar_code_scan.dart';
import 'package:vet_internal_ticket/view/car_scan/presentation/ui/scan/qr_scan.dart';
import 'package:vet_internal_ticket/view/home/presentaion/ui/home_binding.dart';
import 'package:vet_internal_ticket/view/home/presentaion/ui/car_history_screen.dart';
import 'package:vet_internal_ticket/view/home/presentaion/ui/car_history_detail_screen.dart';
import 'package:vet_internal_ticket/view/home/presentaion/ui/car_history_map_screen.dart';
import 'package:vet_internal_ticket/view/home/presentaion/ui/home_screen.dart';
import 'package:vet_internal_ticket/view/home/presentaion/ui/widget/drawer_menu.dart';
import 'package:vet_internal_ticket/view/printer/ui/BluetoothScreen.dart';
import 'package:vet_internal_ticket/view/printer/ui/printerSetting.dart';

import 'package:vet_internal_ticket/view/report/presentation/report_sale_binding.dart';
import 'package:vet_internal_ticket/view/report/presentation/ui/report_balance_screen.dart';
import 'package:vet_internal_ticket/view/report/presentation/ui/report_sale_screen.dart';
import 'package:vet_internal_ticket/view/report/presentation/ui/report_screen.dart';
import 'package:vet_internal_ticket/splash_screen.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/binding/passsenger_detail_binding.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/binding/schedule_binding.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/binding/seat_binding.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/binding/ticket_menu_binding.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/ui/passenger_detail_screen.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/ui/schedule_detail_screen.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/ui/schedule_list_screen.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/ui/seat_screen.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/ui/ticket_menu_screen.dart';
import 'package:vet_internal_ticket/view/transaction/ui/transaction_screen.dart';

class AppRoutes {
  static const String drawer_menu = "/drawer_menu";
  static const String loginScreen = "/loginScreen";
  static const String homeScreen = "/homeScreen";
  static const String car_history_screen = "/car_history_screen";
  static const String car_history_detail_screen = "/car_history_detail_screen";
  static const String car_history_map_screen = "/car_history_map_screen";
  static const String printerScreen = "/printerScreen";
  static const String splashScreen = "/splashScreen";
  static const String busScreen = "/busScreen";
  static const String reportScreen = "/reportScreen";
  static const String report_balance_screen = "/report_balance_screen";
  static const String report_sale_screen = "/report_sale_screen";
  static const String select_seat_screen = "/select_seat_screen";
  static const String ticket_menu_Screen = "/ticket_menu_Screen";
  static const String scan_ticket_screen = "/scan_ticket_screen";
  static const String schedule_list_screen = "/schedule_list_screen";
  static const String schedule_detail_screen = "/schedule_detail_screen";
  static const String passenger_detail_screen = "/passenger_detail_screen";
  static const String booking_detail_screen = "/booking_detail_screen";
  static const String transaction_screen = "/transaction_screen";
  static const String qr_code_car_scan = "/qr_code_car_scan";
  static const String bar_code_car_scan = "/bar_code_car_scan";
  static const String bluetooth = "/bluetooth";
  static const String printerSetting = "/printerSetting";

  static void goToLogin() => Get.offAllNamed(AppRoutes.loginScreen);
}

int index = 10;

final getPages = [
  GetPage(
      name: AppRoutes.loginScreen,
      page: () => LoginScreen(),
      binding: AuthBinding()),
  // ----------------------
  GetPage(
      name: AppRoutes.drawer_menu,
      page: () => DrawerMenu(),
      binding: AuthBinding()),
  // ----------------------
  GetPage(
      name: AppRoutes.homeScreen,
      page: () => HomeScreen(),
      binding: HomeBinding()),
  // ----------------
  GetPage(
    name: AppRoutes.car_history_screen,
    page: () => const CarHistoryScreen(),
  ),
  // ----------------
  GetPage(
    name: AppRoutes.car_history_detail_screen,
    page: () => const CarHistoryDetailScreen(),
  ),
  // ----------------
  GetPage(
    name: AppRoutes.car_history_map_screen,
    page: () => const CarHistoryMapScreen(),
  ),
  // ----------------
  GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBindding()),
  // ----------------
  GetPage(name: AppRoutes.busScreen, page: () => const BusScreen()),
  // ----------------
  GetPage(name: AppRoutes.reportScreen, page: () => const ReportScreen()),
  // ----------------
  GetPage(
      name: AppRoutes.report_balance_screen,
      page: () => const ReportBalanceScreen()),
  // ----------------
  GetPage(
      name: AppRoutes.report_sale_screen,
      page: () => const ReportSaleScreen(),
      binding: ReportSaleBinding()),
  // ----------------
  GetPage(
      name: AppRoutes.select_seat_screen,
      page: () => const SelectSeatScreen(),
      binding: SeatBinding()),

  // ----------------
  GetPage(
      name: AppRoutes.ticket_menu_Screen,
      page: () => TicketMenuScreen(),
      binding: TicketMenuBinding()),
  // ----------------
  GetPage(
      name: AppRoutes.scan_ticket_screen,
      page: () => const ScanTicketScreen(),
      binding: ScanTicketBinding()),

  GetPage(
      name: AppRoutes.schedule_list_screen,
      page: () => ScheduleListScreen(),
      binding: ScheduleBinding()),
  // ----------------
  GetPage(
    name: AppRoutes.schedule_detail_screen,
    page: () => const ScheduleDetailScreen(),
  ),
  // ----------------
  GetPage(
      name: AppRoutes.passenger_detail_screen,
      page: () => const PassengerDetailScreen(),
      binding: PasssengerDetailBinding()),
  // ----------------
  GetPage(
      name: AppRoutes.transaction_screen,
      page: () => TransactionScreen(),
      binding: BookingBindding()),

  // ----------------
  GetPage(
      name: AppRoutes.booking_detail_screen,
      page: () => const BookingDetailScreen(),
      binding: BookingBindding()),
  // ----------------
  GetPage(
    name: AppRoutes.qr_code_car_scan,
    page: () => QRCodeCarScan(),
  ),

  // ----------------
  GetPage(
    name: AppRoutes.bar_code_car_scan,
    page: () => const BarCodeCarScan(),
  ),
  GetPage(
    name: AppRoutes.printerScreen,
    page: () => const PrinterSetting(),
  ),

  GetPage(
    name: AppRoutes.bluetooth,
    page: () => const BluetoothScreen(),
  )
];
