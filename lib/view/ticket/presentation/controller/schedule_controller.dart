// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/booking_service.dart';
import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/theme/app_colors.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/schedule_body.dart';
import 'package:vet_internal_ticket/view/ticket/domain/uscase/schedule_uscase.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/seat_controller.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/state/schedule_state.dart';

class ScheduleController extends StateController<ScheduleState> {
  final ScheduleUscase scheduleUscase;
  ScheduleController(this.scheduleUscase);

  final TextEditingController markupController = TextEditingController();
  final FocusNode markupFocus = FocusNode();

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
        uiState.value.originalDate = uiState.value.selectDate.value;
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

    _syncMarkupText();

    markupFocus.addListener(() {
      if (markupFocus.hasFocus) {
        if (markupController.text.trim() == '0') {
          markupController.clear();
        }
        return;
      }

      if (markupController.text.trim().isEmpty) {
        markupController.value = const TextEditingValue(
          text: '0',
          selection: TextSelection.collapsed(offset: 1),
        );
        setMarkupFromInput(0);
      }
    });
  }

  @override
  void onClose() {
    markupController.dispose();
    markupFocus.dispose();
    super.onClose();
  }

  void _syncMarkupText() {
    if (markupFocus.hasFocus) return;
    final nextText = uiState.value.markup.value.toString();
    if (markupController.text == nextText) return;
    markupController.value = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: nextText.length),
    );
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

    print('🧾 [Schedule] Select scheduleId=$scheduleId journeyId=$journeyId');
    print(
        '🧾 [Schedule] isReturnTrip=${uiState.value.isReturnTrip.value} seatPrice=$seatPriceValue markup=$markupValue totalPrice=$totalPrice');

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
      setMarkupFromInput(0);
      await fetchScheduleList();
    }
  }

  Future<void> onBackPressed() async {
    if (!uiState.value.isReturnTrip.value) {
      Get.back();
      return;
    }

    final booking = Get.find<BookingService>().bookingData;
    final goScheduleId = booking.goScheduleId;
    final goDate = booking.goDate ?? uiState.value.originalDate;
    final backDate = uiState.value.selectDateBack.value;

    if (goScheduleId == null || goScheduleId.isEmpty || goDate == null) {
      Get.back();
      return;
    }

    final double goSeatPriceValue =
        double.tryParse(booking.goSeatPrice ?? '0.0') ?? 0.0;
    final int markupValue = uiState.value.markup.value;
    final double totalPrice = goSeatPriceValue + markupValue;

    Get.delete<SeatController>();

    final result = await Get.toNamed(AppRoutes.select_seat_screen, arguments: {
      'date': goDate,
      'dateback': backDate,
      'id': goScheduleId,
      'fromName': booking.goFromName ?? uiState.value.toName,
      'toName': booking.goToName ?? uiState.value.fromName,
      'fromId': booking.goFromId ?? uiState.value.toId,
      'toId': booking.goToId ?? uiState.value.fromId,
      'seatPrice': booking.goSeatPrice ?? '0',
      'totalSeat': booking.totalSeat ?? '0',
      'markup': uiState.value.markup,
      'totalPrice': totalPrice,
      'isReturnTrip': false.obs,
      'type': uiState.value.selectType,
      'selectedSeats': booking.goSelectedSeats,
      'selectedSeatback': booking.returnSelectedSeats,
    });

    if (result == 'go_confirmed') {
      uiState.value.isReturnTrip.value = true;
      setMarkupFromInput(0);
      await fetchScheduleList();
      return;
    }

    uiState.value.isReturnTrip.value = false;
    if (booking.goFromId != null && booking.goToId != null) {
      uiState.value.fromId = booking.goFromId;
      uiState.value.toId = booking.goToId;
      uiState.value.fromName = booking.goFromName;
      uiState.value.toName = booking.goToName;
    } else {
      final tempFromName = uiState.value.fromName;
      final tempFromId = uiState.value.fromId;
      uiState.value.fromName = uiState.value.toName;
      uiState.value.toName = tempFromName;
      uiState.value.fromId = uiState.value.toId;
      uiState.value.toId = tempFromId;
    }

    if (goDate.isNotEmpty) {
      uiState.value.selectDate.value = goDate;
    }

    await fetchScheduleList();
  }

  void incrementMarkup() {
    if (uiState.value.markup.value < 5) {
      uiState.value.markup.value++;
      _syncMarkupText();
    }
  }

  void decrementMarkup() {
    if (uiState.value.markup.value > 0) {
      uiState.value.markup.value--;
      _syncMarkupText();
    }
  }

  void setMarkupFromInput(int value) {
    final clamped = value.clamp(0, 5);
    uiState.value.markup.value = clamped;
    _syncMarkupText();
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
    final hadReturnDate = uiState.value.selectDateBack.value.isNotEmpty;
    uiState.value.selectDate.value = formatted;

    final booking = Get.find<BookingService>().bookingData;
    booking.goScheduleId = null;
    booking.goDate = formatted;
    booking.goSeatPrice = null;
    booking.goSelectedSeats.clear();

    if (hadReturnDate) {
      // Round-trip: keep return date but make sure it is >= go date
      try {
        final ret = DateTime.parse(uiState.value.selectDateBack.value);
        if (ret.isBefore(newDate)) {
          uiState.value.selectDateBack.value = _formatDate(newDate);
        }
      } catch (_) {
        uiState.value.selectDateBack.value = _formatDate(newDate);
      }

      booking.returnScheduleId = null;
      booking.returnSeatPrice = null;
      booking.returnSelectedSeats.clear();
      booking.returnDate = uiState.value.selectDateBack.value;
    } else {
      // One-way: ensure we don't accidentally create a return date
      uiState.value.selectDateBack.value = "";
      booking.resetReturnSelection();
    }

    fetchScheduleList();
  }

  void updateReturnDate(DateTime newDate) {
    final go = parseGoDate();
    final safe = newDate.isBefore(go) ? go : newDate;

    final formatted = _formatDate(safe);
    uiState.value.selectDateBack.value = formatted;

    final booking = Get.find<BookingService>().bookingData;
    booking.returnScheduleId = null;
    booking.returnDate = formatted;
    booking.returnSeatPrice = null;
    booking.returnSelectedSeats.clear();

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
