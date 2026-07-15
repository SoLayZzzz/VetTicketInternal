// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import 'package:vet_internal_ticket/theme/app_colors.dart';
import 'package:vet_internal_ticket/view/booking/data/model/request/booking_cf_body.dart';
import 'package:vet_internal_ticket/booking_service.dart';
import 'package:vet_internal_ticket/view/ticket/domain/uscase/passenger_uscase.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/state/pasenger_detail_state.dart';

class PassengerDetailController extends StateController<PasengerDetailState> {
  final PassengerUscase passengerUscase;
  PassengerDetailController(this.passengerUscase);

  late final TripBookingData booking;
  final phoneFocus = FocusNode();

  @override
  void onClose() {
    phoneFocus.dispose();
    super.onClose();
  }

  @override
  PasengerDetailState onInitUiState() => PasengerDetailState();

  @override
  void onInit() {
    booking = Get.find<BookingService>().bookingData;
    super.onInit();
    final args = Get.arguments;

    if (args != null) {
      getAgument(isReturnTrip: args['isReturnTrip'] ?? false);
    }

    print("🚀 PassengerDetailController INIT");
    booking.calculateTotalSeat();
    booking.calculateTotalPrice();
    booking.debugPrint();

    if (booking.goScheduleId == null || booking.goDate == null) {
      _notifyError(
        title: "Error",
        message: "Booking data missing. Please restart booking.",
      );
      Get.back();
      return;
    }

    uiState.value.journeyId = booking.goScheduleId;
    uiState.value.scheduleId = booking.goScheduleId!;
    uiState.value.journeyBack = booking.returnScheduleId;

    uiState.value.fromName = booking.goFromName;
    uiState.value.toName = booking.goToName;
    uiState.value.date = booking.goDate;
    uiState.value.dateBack = booking.returnDate;

    uiState.value.selectedSeats.assignAll(booking.goSelectedSeats);
    uiState.value.selectedSeatback.assignAll(booking.returnSelectedSeats);

    uiState.value.totalSeat = booking.totalSeat ?? '0';
    uiState.value.seatPrice = booking.goSeatPrice ?? '0.0';
    uiState.value.markup = booking.markup;
    uiState.value.totalPrice = booking.totalPrice;

    if (uiState.value.selectedNationalityId.value == 0) {
      uiState.value.selectedNationalityId.value = 1;
    }

    // ✅ Start watching input for error clearing and synchronization
    uiState.value.phoneController.addListener(() {
      final text = uiState.value.phoneController.text.trim();

      // One-way sync to Return phone controller
      if (uiState.value.phoneBackController.text.trim() != text) {
        uiState.value.phoneBackController.text = uiState.value.phoneController.text;
      }

      if (!uiState.value.hasSubmitted.value) return;

      if (text.isEmpty) {
        uiState.value.showPhoneError.value = true;
        uiState.value.phoneErrorMessage.value = 'សូមបំពេញលេខទូរស័ព្ទ';
        return;
      }

      final hasInvalidLength = text.length < 8 || text.length > 10;
      if (hasInvalidLength) {
        uiState.value.showPhoneError.value = true;
        uiState.value.phoneErrorMessage.value = 'លេខលេខទូរស័ព្ទមិនត្រឹមត្រូវ';
        return;
      }

      uiState.value.showPhoneError.value = false;
      uiState.value.phoneErrorMessage.value = '';
    });

    uiState.value.phoneBackController.addListener(() {
      final text = uiState.value.phoneBackController.text.trim();
      if (!uiState.value.hasSubmitted.value) return;

      if (text.isEmpty) {
        uiState.value.showPhoneErrorBack.value = true;
        uiState.value.phoneErrorMessageBack.value = 'សូមបំពេញលេខទូរស័ព្ទ';
        return;
      }

      final hasInvalidLength = text.length < 8 || text.length > 10;
      if (hasInvalidLength) {
        uiState.value.showPhoneErrorBack.value = true;
        uiState.value.phoneErrorMessageBack.value = 'លេខលេខទូរស័ព្ទមិនត្រឹមត្រូវ';
        return;
      }

      uiState.value.showPhoneErrorBack.value = false;
      uiState.value.phoneErrorMessageBack.value = '';
    });

    fetchStations();
    // getNational();
  }

  void getAgument({
    required RxBool isReturnTrip,
  }) {
    uiState.value.isReturnTrip.value = isReturnTrip.value;
  }

  void onTapGender(String seatId, int genderValue) {
    uiState.value.passengerGenders[seatId] = genderValue;

    // One-way sync: If the selected seat is in the "go" trip (e.g. starts with 'go_'),
    // find its index and automatically update the corresponding seat in the "back" trip.
    if (seatId.startsWith("go_")) {
      final rawSeatId = seatId.substring(3); // remove 'go_'
      final goIndex = uiState.value.selectedSeats.indexWhere((seat) => (seat['value'] ?? '') == rawSeatId);
      if (goIndex != -1 && goIndex < uiState.value.selectedSeatback.length) {
        final backSeatVal = uiState.value.selectedSeatback[goIndex]['value'] ?? '';
        if (backSeatVal.isNotEmpty) {
          uiState.value.passengerGenders["back_$backSeatVal"] = genderValue;
        }
      }
    }

    if (uiState.value.showGenderError.value) {
      final con = uiState.value;
      bool hasMissing = false;
      for (var seat in con.selectedSeats) {
        final id = seat['value'] ?? '';
        final g = con.passengerGenders["go_$id"];
        if (g == null || g == 0) {
          hasMissing = true;
          break;
        }
      }
      if (!hasMissing) {
        for (var seat in con.selectedSeatback) {
          final id = seat['value'] ?? '';
          final g = con.passengerGenders["back_$id"];
          if (g == null || g == 0) {
            hasMissing = true;
            break;
          }
        }
      }
      con.showGenderError.value = hasMissing;
    }
  }

  // Route back
  void goBackToSeatSelection() {
    Get.back();
  }

  Future<void> fetchStations() async {
    final goScheduleId = uiState.value.journeyId;
    final returnScheduleId = uiState.value.journeyBack;

    uiState.value.isLoading.value = true;
    uiState.value.errorMessage.value = '';

    try {
      if (goScheduleId != null && goScheduleId.isNotEmpty) {
        final [boardingGo, downGo] = await Future.wait([
          passengerUscase.executeBoardingStation(goScheduleId),
          passengerUscase.executeDownStation(goScheduleId),
        ]);

        if (boardingGo.body?.isNotEmpty == true) {
          uiState.value.goBoardingStationList.assignAll(boardingGo.body!);
          uiState.value.goBoardingStation.value = boardingGo.body!.first;
        }
        if (downGo.body?.isNotEmpty == true) {
          uiState.value.goDropStationList.assignAll(downGo.body!);
          uiState.value.goDropStation.value = downGo.body!.first;
        }
      }

      if (returnScheduleId != null && returnScheduleId.isNotEmpty) {
        final [boardingReturn, downReturn] = await Future.wait([
          passengerUscase.executeBoardingStation(returnScheduleId),
          passengerUscase.executeDownStation(returnScheduleId),
        ]);

        if (boardingReturn.body?.isNotEmpty == true) {
          uiState.value.returnBoardingStationList
              .assignAll(boardingReturn.body!);
          uiState.value.returnBoardingStation.value =
              boardingReturn.body!.first;
        }
        if (downReturn.body?.isNotEmpty == true) {
          uiState.value.returnDropStationList.assignAll(downReturn.body!);
          uiState.value.returnDropStation.value = downReturn.body!.first;
        }
      }
    } catch (e) {
      uiState.value.errorMessage.value = e.toString();
    } finally {
      uiState.value.isLoading.value = false;
    }
  }

  void onNationalitySelected(int index) {
    final nationalDataList = uiState.value.national.value?.body?.data;
    if (nationalDataList != null &&
        index >= 0 &&
        index < nationalDataList.length) {
      final selectedNationality = nationalDataList[index];
      uiState.value.selectedNationalityId.value = selectedNationality.id ?? 1;
    }
  }

  // Future<void> getNational() async {
  //   uiState.value.isSelectingNationality.value = true;
  //   uiState.value.errorMessage.value = '';
  //   try {
  //     final response = await passengerUscase.getNational();
  //     uiState.value.national.value = response;

  //     if (response.body?.data != null) {
  //       final names = response.body!.data!.map((d) => d.name ?? '').toList();
  //       uiState.value.nationalityNames.assignAll(names);
  //     }
  //   } catch (e) {
  //     uiState.value.errorMessage.value = e.toString();
  //   } finally {
  //     uiState.value.isSelectingNationality.value = false;
  //   }
  // }

  void validateAndSubmit() {
    final con = uiState.value;

    print('🧾 [Passenger] Submit tapped');
    print(
        '🧾 [Passenger] booking.goScheduleId=${booking.goScheduleId} booking.returnScheduleId=${booking.returnScheduleId} booking.totalSeat=${booking.totalSeat} booking.markup=${booking.markup} booking.totalPrice=${booking.totalPrice}');

    // Mark that user attempted to submit
    con.hasSubmitted.value = true;

    // Reset error flags
    con.showPhoneError.value = false;
    con.phoneErrorMessage.value = '';
    con.showPhoneErrorBack.value = false;
    con.phoneErrorMessageBack.value = '';
    con.showNationalityError.value = false;
    con.showGenderError.value = false;

    // Validate phone
    final phoneText = con.phoneController.text.trim();
    final phoneLen = phoneText.length;
    final bool hasPhoneError;
    if (phoneText.isEmpty) {
      hasPhoneError = true;
      con.phoneErrorMessage.value = 'សូមបំពេញលេខទូរស័ព្ទ';
    } else if (phoneLen < 8 || phoneLen > 10) {
      hasPhoneError = true;
      con.phoneErrorMessage.value = 'លេខលេខទូរស័ព្ទមិនត្រឹមត្រូវ';
    } else {
      hasPhoneError = false;
      con.phoneErrorMessage.value = '';
    }
    con.showPhoneError.value = hasPhoneError;

    // Validate back phone if round trip
    bool hasPhoneErrorBack = false;
    if (con.selectedSeatback.isNotEmpty) {
      final phoneTextBack = con.phoneBackController.text.trim();
      final phoneLenBack = phoneTextBack.length;
      if (phoneTextBack.isEmpty) {
        hasPhoneErrorBack = true;
        con.phoneErrorMessageBack.value = 'សូមបំពេញលេខទូរស័ព្ទ';
      } else if (phoneLenBack < 8 || phoneLenBack > 10) {
        hasPhoneErrorBack = true;
        con.phoneErrorMessageBack.value = 'លេខលេខទូរស័ព្ទមិនត្រឹមត្រូវ';
      } else {
        hasPhoneErrorBack = false;
        con.phoneErrorMessageBack.value = '';
      }
      con.showPhoneErrorBack.value = hasPhoneErrorBack;
    }

    // Validate gender per seat
    bool hasGenderError = false;
    for (var seat in con.selectedSeats) {
      final id = seat['value'] ?? '';
      final g = con.passengerGenders["go_$id"];
      if (g == null || g == 0) {
        hasGenderError = true;
        break;
      }
    }
    if (!hasGenderError) {
      for (var seat in con.selectedSeatback) {
        final id = seat['value'] ?? '';
        final g = con.passengerGenders["back_$id"];
        if (g == null || g == 0) {
          hasGenderError = true;
          break;
        }
      }
    }
    con.showGenderError.value = hasGenderError;

    // Validate nationality
    if (con.selectedNationalityId.value == 0) {
      con.selectedNationalityId.value = 1;
    }
    final hasNationalError = con.selectedNationalityId.value == 0;
    con.showNationalityError.value = hasNationalError;

    print(
        '🧾 [Passenger] Validation: phoneLen=$phoneLen phoneError=$hasPhoneError phoneErrorBack=$hasPhoneErrorBack genderError=$hasGenderError nationalityId=${con.selectedNationalityId.value} nationalityError=$hasNationalError');

    // Show error if any
    if (hasPhoneError || hasPhoneErrorBack || hasGenderError || hasNationalError) {
      print('🧾 [Passenger] Submit blocked by validation errors');
      return;
    }

    // Proceed to submit
    con.buttonText.value = 'កំពុងដំណើរការ...';
    print('🧾 [Passenger] Calling postBookingConfirm()');
    postBookingConfirm();
  }

  void _notifyError({required String title, required String message}) {
    void showDialog() {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Get.defaultDialog(
        title: title,
        middleText: message,
        textConfirm: 'OK',
        onConfirm: () {
          Get.back();
        },
      );
    }

    void showSnack() {
      try {
        final overlayContext = Get.overlayContext;
        final hasOverlay =
            overlayContext != null && Overlay.maybeOf(overlayContext) != null;
        if (!hasOverlay) {
          showDialog();
          return;
        }

        Get.snackbar(
          title,
          message,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (_) {
        showDialog();
      }
    }

    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          showSnack();
        } catch (_) {
          showDialog();
        }
      });
    } catch (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          showDialog();
        } catch (_) {}
      });
    }
  }

  Future<void> postBookingConfirm() async {
    final booking = Get.find<BookingService>().bookingData;

    print('🧾 [Passenger] postBookingConfirm start');
    print(
        '🧾 [Passenger] booking.goScheduleId=${booking.goScheduleId} booking.returnScheduleId=${booking.returnScheduleId} booking.totalSeat=${booking.totalSeat} booking.markup=${booking.markup} booking.totalPrice=${booking.totalPrice}');

    final goBoarding = uiState.value.goBoardingStation.value;
    final goDrop = uiState.value.goDropStation.value;
    final returnBoarding = uiState.value.returnBoardingStation.value;
    final returnDrop = uiState.value.returnDropStation.value;

    /// ✅ Combine all selected seats from Go and Return
    final List<Map<String, String>> allSeats = [
      ...uiState.value.selectedSeats.map((seat) => {
            ...seat,
            'journeyId': booking.goScheduleId ?? '',
          }),
      ...uiState.value.selectedSeatback.map((seat) => {
            ...seat,
            'journeyId': booking.returnScheduleId ?? '',
          }),
    ];

    /// ✅ Seat numbers and genders
    final seatNumbers = allSeats.map((seat) => seat['value'] ?? '').toList();
    final seatGenders = [
      ...uiState.value.selectedSeats.map((seat) {
        final id = seat['value'] ?? '';
        return uiState.value.passengerGenders["go_$id"]?.toString() ?? '1';
      }),
      ...uiState.value.selectedSeatback.map((seat) {
        final id = seat['value'] ?? '';
        return uiState.value.passengerGenders["back_$id"]?.toString() ?? '1';
      }),
    ];

    /// ✅ Station & Journey Info
    final List<String> boardingIds = [];
    final List<String> dropOffIds = [];
    final List<String> journeyIds = [];
    final List<String> dates = [];

    if (uiState.value.selectedSeats.isNotEmpty) {
      boardingIds.add(goBoarding?.id.toString() ?? '');
      dropOffIds.add(goDrop?.id.toString() ?? '');
      journeyIds.add(booking.goScheduleId ?? '');
      dates.add(booking.goDate ?? '');
    }

    if (uiState.value.selectedSeatback.isNotEmpty) {
      boardingIds.add(returnBoarding?.id.toString() ?? '');
      dropOffIds.add(returnDrop?.id.toString() ?? '');
      journeyIds.add(booking.returnScheduleId ?? '');
      dates.add(booking.returnDate ?? '');
    }

    final journeyType = journeyIds.length == 2 ? '2' : '1';

    final List<String> markups = [];
    if (uiState.value.selectedSeats.isNotEmpty) {
      markups.add(booking.goMarkup.toString());
    }
    if (uiState.value.selectedSeatback.isNotEmpty) {
      markups.add(booking.returnMarkup.toString());
    }

    final totalSeats = allSeats.length;
    final double goPerSeatMarkup = booking.goMarkup.toDouble();
    final double returnPerSeatMarkup = booking.returnMarkup.toDouble();

    final seatPrices = [
      ...List.filled(
          booking.goSelectedSeats.length,
          ((double.tryParse(booking.goSeatPrice ?? '0.0') ?? 0.0) +
                  goPerSeatMarkup)
              .toStringAsFixed(2)),
      ...List.filled(
          booking.returnSelectedSeats.length,
          ((double.tryParse(booking.returnSeatPrice ?? '0.0') ?? 0.0) +
                  returnPerSeatMarkup)
              .toStringAsFixed(2)),
    ];

    final totalAmount =
        seatPrices.fold<double>(0.0, (sum, price) => sum + double.parse(price));

    print(
        '🧾 [Passenger] Computed totalAmount(with per-seat markup)=${totalAmount.toStringAsFixed(2)} seats=${allSeats.length} seatPrices=$seatPrices');

    final phone = uiState.value.phoneController.text.trim();
    final phoneBack = uiState.value.phoneBackController.text.trim();
    final String finalPhone;
    if (uiState.value.selectedSeatback.isNotEmpty && phoneBack.isNotEmpty) {
      finalPhone = '$phone,$phoneBack';
    } else {
      finalPhone = phone;
    }

    /// ✅ Build request body
    final body = BookingCfBody(
      boardingPointId: boardingIds,
      dropOffId: dropOffIds,
      journeyDate: dates,
      journeyId: journeyIds,
      journeyType: journeyType,
      markup: markups,
      name: 'admin',
      email: 'kkk@gmail.com',
      // nationally: uiState.value.selectedNationalityId.value.toString(),
      nationally: 1.toString(),
      seatGender: seatGenders,
      seatJourney: allSeats.map((s) => s['journeyId'] ?? '').toList(),
      seatNum: seatNumbers,
      seatPrice: seatPrices,
      telephone: finalPhone,
      totalAmount: totalAmount.toStringAsFixed(2),
      totalSeat: totalSeats.toString(),
    );

    /// ✅ Debug Log
    print("📦 Booking Confirmation Data:");
    print("📋 boardingPointId: $boardingIds");
    print("📋 dropOffId: $dropOffIds");
    print("📋 journeyDate: $dates");
    print("📋 journeyId: $journeyIds");
    print("📋 journeyType: $journeyType");
    print("📋 markup: $markups");
    print("📋 name: admin");
    print("📋 email: kkk@gmail.com");
    print("📋 nationally: ${uiState.value.selectedNationalityId.value}");
    print("📋 seatGender: $seatGenders");
    print("📋 seatJourney: ${allSeats.map((s) => s['journeyId'])}");
    print("📋 seatNum: $seatNumbers");
    print("📋 seatPrice: $seatPrices");
    print("📋 telephone: $phone");
    print("📋 totalAmount: ${totalAmount.toStringAsFixed(2)}");
    print("📋 totalSeat: $totalSeats");

    try {
      uiState.value.isLoading.value = true;
      final response = await passengerUscase.executeBookingComfirm(body);
      final status = response.body?.status ?? -1;

      print('🧾 [Passenger] Booking confirm status=$status');

      print("REsponse: $response");

      if (status == 0) {
        // 🚫 Seats unavailable
        _notifyError(
          title: "Error",
          message: "Sorry, some seats you selected are not available.",
        );
      } else if (status == 1) {
        // ✅ Booking success
        final transactionId = response.body?.transactionId?.toString() ?? '';
        print('🧾 [Passenger] Success transactionId=$transactionId');
        if (transactionId.isEmpty) {
          _notifyError(
            title: "Error",
            message: "Transaction ID missing. Please try again.",
          );
          return;
        }

        if (Get.isDialogOpen == true) {
          Get.back();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          print(
              '🧾 [Passenger] Navigating to transaction_screen totalPrice=${totalAmount.toStringAsFixed(2)} totalSeat=$totalSeats');
          Get.toNamed(AppRoutes.transaction_screen, arguments: {
            'masg': response.body?.msg,
            'transactionId': transactionId,
            'status': response.body?.status,
            'totalPrice': totalAmount.toStringAsFixed(2),
            'totalSeat': totalSeats.toString(),
            'goMarkup': booking.goMarkup,
            'returnMarkup': booking.returnMarkup,
            'goSeatPrice': booking.goSeatPrice,
            'returnSeatPrice': booking.returnSeatPrice,
          });
        });

        Get.find<BookingService>().reset();
      } else {
        // 💸 Money not enough
        print(
            '🧾 [Passenger] Not navigating: status=$status (showPassengerInfoDialog)');
        showPassengerInfoDialog();
      }
    } catch (e) {
      print('🧾 [Passenger] postBookingConfirm error: $e');
      uiState.value.errorMessage.value = e.toString();
    } finally {
      uiState.value.isLoading.value = false;
      uiState.value.buttonText.value = 'ដំណើរការដើម្បីចូលបង់ប្រាក់';
      print('🧾 [Passenger] postBookingConfirm done loading=false');
    }
  }

  void showPassengerInfoDialog() {
    Get.dialog(
      barrierColor: Colors.grey.withAlpha(80),
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: AppPadding.large),
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ព័ត៍មាន',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'មិនមានទឹកប្រាក់គ្រប់គ្រាន់សម្រាប់ការកក់សំបុត្រទេ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'យល់ព្រម',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
