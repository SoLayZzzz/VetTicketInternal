// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/utils/colors.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/schedule_body.dart';
import 'package:vet_internal_ticket/view/ticket/domain/uscase/schedule_uscase.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/seat_controller.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/state/schedule_state.dart';

class ScheduleController extends StateController<ScheduleState> {
  final ScheduleUscase scheduleUscase;
  ScheduleController(this.scheduleUscase);

  @override
  void onInit() {
    super.onInit();
    print("🚀🚀🚀🚀🚀 ============== ScheduleController INIT ==============");
    loadArguments();
    fetchScheduleList();
  }

  @override
  ScheduleState onInitUiState() => ScheduleState();

  void loadArguments() {
    final args = Get.arguments;

    args.forEach((key, value) {
      print("🧩 Arg Schedule: $key → $value");
    });

    if (args != null) {
      getAgrumentFromTicket(
        fromId: args['fromId'],
        fromName: args['fromName'],
        toId: args['toId'],
        toName: args['toName'],
        date: args['date'],
        dateBack: args['dateback'],
        type: args['type'],
      );

      uiState.value.isReturnTrip.value = args['isReturnTrip'] ?? false;

      /// ✅ Swap names and date for return trip UI
      if (uiState.value.isReturnTrip.value) {
        final tempFromName = uiState.value.fromName;
        final tempFromId = uiState.value.fromId;

        uiState.value.fromName = uiState.value.toName;
        uiState.value.toName = tempFromName;

        uiState.value.fromId = uiState.value.toId;
        uiState.value.toId = tempFromId;

        /// Update selected date to return date
        uiState.value.selectDate.value = uiState.value.selectDateBack.value;
      }
    }
  }

  void getAgrumentFromTicket({
    required String fromId,
    required String fromName,
    required String toId,
    required String toName,
    required String date,
    required String dateBack,
    required dynamic type,
  }) {
    uiState.value.selectDate.value = date;
    uiState.value.selectDateBack.value = dateBack;
    uiState.value.fromId = fromId;
    uiState.value.fromName = fromName;
    uiState.value.toId = toId;
    uiState.value.toName = toName;
    uiState.value.selectType = type.toString();
  }

  Future<void> fetchScheduleList() async {
    if (uiState.value.fromId == null || uiState.value.toId == null) return;

    try {
      uiState.value.isLoading.value = true;
      uiState.value.errorMessage.value = '';

      final body = ScheduleBody(
        date: uiState.value.isReturnTrip.value
            ? uiState.value.selectDateBack.value
            : uiState.value.selectDate.value,
        destinationFrom: uiState.value.isReturnTrip.value
            ? uiState.value.toId!
            : uiState.value.fromId!,
        destinationTo: uiState.value.isReturnTrip.value
            ? uiState.value.fromId!
            : uiState.value.toId!,
        nationally: "kh",
        type: uiState.value.selectType.toString(),
      );
      final result = await scheduleUscase.executeScheduleList(body);
      uiState.value.scheduleData.value = result;

      print("====== Schedule Body post to server ======");
      print("Date: ${uiState.value.selectDate.value},");
      print("Destination From: ${uiState.value.fromId},");
      print("Destination To: ${uiState.value.toId},");
      print("Type: ${uiState.value.selectType}");
      print("===========================================");
    } catch (e) {
      uiState.value.errorMessage.value = e.toString();
      uiState.value.scheduleData.value = null;
    } finally {
      uiState.value.isLoading.value = false;
    }
  }

  void navigateToSeat(
    String scheduleId,
    String journeyId,
    String seatPrice,
    String totalSeat,
  ) async {
    final double seatPriceValue = double.tryParse(seatPrice) ?? 0.0;
    final int markupValue = uiState.value.markup.value;
    final double totalPrice = seatPriceValue + markupValue;

    final isReturn = uiState.value.isReturnTrip.value.obs;
    final dateGo = uiState.value.selectDate.value;
    final dateBack = uiState.value.selectDateBack.value;

    final fromName = uiState.value.fromName;
    final toName = uiState.value.toName;
    final fromId = uiState.value.fromId;
    final toId = uiState.value.toId;

    final args = Get.arguments ?? {};
    final selectedSeats = args['selectedSeats'] ?? [];
    final selectedSeatback = args['selectedSeatback'] ?? [];

    final String selectedScheduleId = scheduleId;

    Get.delete<SeatController>();

    final result = await Get.toNamed(AppRoutes.select_seat_screen, arguments: {
      'date': uiState.value.isReturnTrip.value ? dateBack : dateGo,
      'dateback': uiState.value.isReturnTrip.value ? dateGo : dateBack,
      'id': selectedScheduleId,
      'fromName': uiState.value.isReturnTrip.value ? toName : fromName,
      'toName': uiState.value.isReturnTrip.value ? fromName : toName,
      'fromId': uiState.value.isReturnTrip.value ? toId : fromId,
      'toId': uiState.value.isReturnTrip.value ? fromId : toId,
      'seatPrice': seatPrice,
      'totalSeat': totalSeat,
      'markup': uiState.value.markup,
      'totalPrice': totalPrice,
      'isReturnTrip': isReturn,
      'type': uiState.value.selectType,
      'selectedSeats': selectedSeats,
      'selectedSeatback': selectedSeatback,
    });

    if (result == 'go_confirmed' && !isReturn.value && dateBack.isNotEmpty) {
      uiState.value.isReturnTrip.value = true;
      await fetchScheduleList();
    }
  }

  void incrementMarkup() {
    if (uiState.value.markup.value < 5) {
      uiState.value.markup.value++;
    }
  }

  void decrementMarkup() {
    if (uiState.value.markup.value > 0) {
      uiState.value.markup.value--;
    }
  }

  // For date

  // ---------------- Date parsing helpers ----------------
  DateTime parseSelectedDate() {
    try {
      return uiState.value.isReturnTrip.value
          ? DateTime.parse(
              uiState.value.selectDateBack.value) // return UI shows return date
          : DateTime.parse(
              uiState.value.selectDate.value); // go UI shows go date
    } catch (_) {
      return DateTime.now();
    }
  }

  /// Always parse the GO date (outbound)
  DateTime parseGoDate() {
    try {
      return DateTime.parse(uiState.value.selectDate.value);
    } catch (_) {
      return DateTime.now();
    }
  }

  /// Always parse the RETURN date (inbound)
  DateTime parseReturnDate() {
    try {
      return DateTime.parse(uiState.value.selectDateBack.value);
    } catch (_) {
      return DateTime.now();
    }
  }

// ---------------- Date picking & updates ----------------
  Future<void> selectDate(BuildContext context) async {
    // Initial date = currently displayed date (go or return depending on UI)
    final initial = parseSelectedDate();

    // Earliest selectable date:
    // - For GO: today
    // - For RETURN: must be >= GO date
    final first =
        uiState.value.isReturnTrip.value ? parseGoDate() : DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first) ? first : initial,
      firstDate: first,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                const ColorScheme.light(primary: AppColors.primaryColor),
            datePickerTheme: const DatePickerThemeData(
                backgroundColor: AppColors.whiteColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (uiState.value.isReturnTrip.value) {
        updateReturnDate(pickedDate);
      } else {
        updateGoDate(pickedDate);
      }
    }
  }

  void updateGoDate(DateTime newDate) {
    final formatted = _formatDate(newDate);
    uiState.value.selectDate.value = formatted;

    try {
      final ret = DateTime.parse(uiState.value.selectDateBack.value);
      if (ret.isBefore(newDate)) {
        uiState.value.selectDateBack.value = formatted;
      }
    } catch (_) {
      uiState.value.selectDateBack.value = formatted;
    }

    fetchScheduleList();
  }

  void updateReturnDate(DateTime newDate) {
    final go = parseGoDate();
    final safe = newDate.isBefore(go) ? go : newDate;
    uiState.value.selectDateBack.value = _formatDate(safe);
    fetchScheduleList();
  }

  void updateSelectedDate(String newDate) {
    if (uiState.value.isReturnTrip.value) {
      uiState.value.selectDateBack.value = newDate;
    } else {
      uiState.value.selectDate.value = newDate;
    }
    fetchScheduleList();
  }

// Keep as-is
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
