// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/components/text.dart';
import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import 'package:vet_internal_ticket/utils/colors.dart';
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
      Get.snackbar("Error", "Booking data missing. Please restart booking.");
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

    // ✅ Start watching input for error clearing
    uiState.value.phoneController.addListener(() {
      final text = uiState.value.phoneController.text.trim();
      if (text.length >= 8 && uiState.value.showPhoneError.value) {
        uiState.value.showPhoneError.value = false;
      }
    });

    fetchStations();
    getNational();
  }

  void getAgument({
    required RxBool isReturnTrip,
  }) {
    uiState.value.isReturnTrip.value = isReturnTrip.value;
  }

  void onTapGender(String seatId, int genderValue) {
    uiState.value.passengerGenders[seatId] = genderValue;
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

  Future<void> getNational() async {
    uiState.value.isLoading.value = true;
    uiState.value.errorMessage.value = '';
    try {
      final response = await passengerUscase.getNational();
      uiState.value.national.value = response;

      if (response.body?.data != null) {
        final names = response.body!.data!.map((d) => d.name ?? '').toList();
        uiState.value.nationalityNames.assignAll(names);
      }
    } catch (e) {
      uiState.value.errorMessage.value = e.toString();
    } finally {
      uiState.value.isLoading.value = false;
    }
  }

  void validateAndSubmit() {
    final con = uiState.value;

    // Mark that user attempted to submit
    con.hasSubmitted.value = true;

    // Reset error flags
    con.showPhoneError.value = false;
    con.showNationalError.value = false;
    con.showGenderError.value = false;

    // Validate phone
    final hasPhoneError = con.phoneController.text.trim().length < 8;
    con.showPhoneError.value = hasPhoneError;

    // Validate gender per seat
    bool hasGenderError = false;
    final allSeats = [...con.selectedSeats, ...con.selectedSeatback];
    for (var seat in allSeats) {
      final id = seat['value'] ?? '';
      if (con.passengerGenders[id] == null || con.passengerGenders[id] == 0) {
        hasGenderError = true;
        break;
      }
    }
    con.showGenderError.value = hasGenderError;

    // Validate nationality
    final hasNationalError =
        con.selectedNationalityId.value == 0 || con.nationalityNames.isEmpty;
    con.showNationalityError.value = hasNationalError;

    // Show error if any
    if (hasPhoneError || hasGenderError || hasNationalError) {
      Get.snackbar(
        'ព័ត៌មានមិនគ្រប់គ្រាន់',
        'សូមបំពេញព័ត៌មានដែលបានសម្គាល់ *',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Proceed to submit
    con.buttonText.value = 'កំពុងដំណើរការ...';
    postBookingConfirm();
  }

  Future<void> postBookingConfirm() async {
    final booking = Get.find<BookingService>().bookingData;

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
    final seatGenders = allSeats.map((seat) {
      final id = seat['value'] ?? '';
      return uiState.value.passengerGenders[id]?.toString() ?? '1';
    }).toList();

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

    final journeyType = booking.returnDate?.isNotEmpty == true ? '2' : '1';

    final totalSeats = allSeats.length;
    final double perSeatMarkup =
        totalSeats > 0 ? booking.markup / totalSeats : 0;

    final seatPrices = [
      ...List.filled(
          booking.goSelectedSeats.length,
          ((double.tryParse(booking.goSeatPrice ?? '0.0') ?? 0.0) +
                  perSeatMarkup)
              .toStringAsFixed(2)),
      ...List.filled(
          booking.returnSelectedSeats.length,
          ((double.tryParse(booking.returnSeatPrice ?? '0.0') ?? 0.0) +
                  perSeatMarkup)
              .toStringAsFixed(2)),
    ];

    final totalAmount =
        seatPrices.fold<double>(0.0, (sum, price) => sum + double.parse(price));

    final phone = uiState.value.phoneController.text.trim();

    /// ✅ Build request body
    final body = BookingCfBody(
      boardingPointId: boardingIds,
      dropOffId: dropOffIds,
      journeyDate: dates,
      journeyId: journeyIds,
      journeyType: journeyType,
      markup: booking.markup.toString(),
      name: 'admin',
      email: 'kkk@gmail.com',
      nationally: uiState.value.selectedNationalityId.value.toString(),
      seatGender: seatGenders,
      seatJourney: allSeats.map((s) => s['journeyId'] ?? '').toList(),
      seatNum: seatNumbers,
      seatPrice: seatPrices,
      telephone: phone,
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
    print("📋 markup: ${booking.markup}");
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

      if (status == 0) {
        // 🚫 Seats unavailable
        Get.snackbar(
          "",
          "",
          titleText: TextSmall(
            text: "Error",
            color: AppColors.redColor,
            fontWeight: FontWeight.bold,
          ),
          messageText: TextSmall(
            text: "Sorry, some seats you selected are not available.",
            color: AppColors.redColor,
          ),
          borderWidth: 1,
          borderColor: AppColors.redColor,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 70),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: AppColors.whiteColor,
          duration: Duration(seconds: 2),
        );
      } else if (status == 1) {
        // ✅ Booking success
        Get.offAllNamed(AppRoutes.transaction_screen, arguments: {
          'masg': response.body?.msg,
          'transactionId': response.body?.transactionId,
          'status': response.body?.status,
          'totalPrice': totalAmount.toStringAsFixed(2),
          'totalSeat': totalSeats.toString(),
        });

        Get.find<BookingService>().reset();
      } else {
        // 💸 Money not enough
        showPassengerInfoDialog();
      }
    } catch (e) {
      uiState.value.errorMessage.value = e.toString();
    } finally {
      uiState.value.isLoading.value = false;
      uiState.value.buttonText.value = 'ដំណើរការដើម្បីចូលបង់ប្រាក់';
    }
  }

  void showPassengerInfoDialog() {
    Get.dialog(
      barrierColor: Colors.grey.withAlpha(80),
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: AppPadding.large),
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ព័ត៍មាន',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
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
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
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


  // Future<void> postBookingConfirm() async {
  //   final goBoarding = uiState.value.goBoardingStation.value;
  //   final goDrop = uiState.value.goDropStation.value;
  //   final returnBoarding = uiState.value.returnBoardingStation.value;
  //   final returnDrop = uiState.value.returnDropStation.value;

  //   // All seat data (each seat is a Map)
  //   final List<Map<String, String>> allSeats = [
  //     ...uiState.value.selectedSeats.map((seat) => {
  //           ...seat,
  //           'journeyId': booking.goScheduleId ?? '',
  //         }),
  //     ...uiState.value.selectedSeatback.map((seat) => {
  //           ...seat,
  //           'journeyId': booking.returnScheduleId ?? '',
  //         }),
  //   ];

  //   // Seat details
  //   final seatNumbers = allSeats.map((seat) => seat['value'] ?? '').toList();
  //   final seatGenders = allSeats.map((seat) {
  //     final id = seat['value'] ?? '';
  //     return uiState.value.passengerGenders[id]?.toString() ?? '1';
  //   }).toList();
  //   final seatPrices = [
  //     ...List.filled(
  //         booking.goSelectedSeats.length, booking.goSeatPrice ?? '0.0'),
  //     ...List.filled(
  //         booking.returnSelectedSeats.length, booking.returnSeatPrice ?? '0.0'),
  //   ];

  //   final List<String> boardingIds = [];
  //   final List<String> dropOffIds = [];
  //   final List<String> journeyIds = [];
  //   final List<String> dates = [];

  //   if (uiState.value.selectedSeats.isNotEmpty) {
  //     boardingIds.add(goBoarding?.id.toString() ?? '');
  //     dropOffIds.add(goDrop?.id.toString() ?? '');
  //     journeyIds.add(booking.goScheduleId ?? '');
  //     dates.add(booking.goDate ?? '');
  //   }

  //   if (uiState.value.selectedSeatback.isNotEmpty) {
  //     boardingIds.add(returnBoarding?.id.toString() ?? '');
  //     dropOffIds.add(returnDrop?.id.toString() ?? '');
  //     journeyIds.add(booking.returnScheduleId ?? '');
  //     dates.add(booking.returnDate ?? '');
  //   }

  //   final journeyType = booking.returnDate?.isNotEmpty == true ? '2' : '1';
  //   final totalAmount = booking.totalPrice;
  //   final phone = uiState.value.phoneController.text.trim();

  //   final body = BookingCfBody(
  //     boardingPointId: boardingIds,
  //     dropOffId: dropOffIds,
  //     journeyDate: dates,
  //     journeyId: journeyIds,
  //     journeyType: journeyType,
  //     markup: booking.markup.toString(),
  //     name: 'admin',
  //     email: 'kkk@gmail.com',
  //     nationally: uiState.value.selectedNationalityId.value.toString(),
  //     seatGender: seatGenders,
  //     seatJourney: allSeats.map((s) => s['journeyId'] ?? '').toList(),
  //     seatNum: seatNumbers,
  //     seatPrice: seatPrices + markup,
  //     telephone: phone,
  //     totalAmount: totalAmount.toString(),
  //     totalSeat: allSeats.length.toString(),
  //   );

  //   print("📦 Booking Confirmation Data:");
  //   print("📋 boardingPointId: $boardingIds");
  //   print("📋 dropOffId: $dropOffIds");
  //   print("📋 journeyDate: $dates");
  //   print("📋 journeyId: $journeyIds");
  //   print("📋 journeyType: $journeyType");
  //   print("📋 markup: ${booking.markup}");
  //   print("📋 name: admin");
  //   print("📋 email: kkk@gmail.com");
  //   print("📋 nationally: ${uiState.value.selectedNationalityId.value}");
  //   print("📋 seatGender: $seatGenders");
  //   print("📋 seatJourney: ${allSeats.map((s) => s['journeyId'])}");
  //   print("📋 seatNum: $seatNumbers");
  //   print("📋 seatPrice: $seatPrices");
  //   print("📋 telephone: $phone");
  //   print("📋 totalAmount: ${totalAmount.toString()}");
  //   print("📋 totalSeat: ${allSeats.length}");

  //   try {
  //     uiState.value.isLoading.value = true;
  //     final response = await passengerUscase.executeBookingComfirm(body);
  //     final status = response.body?.status ?? -1;

  //     if (status == 0) {
  //       // 🚫 Case: Seats not available
  //       Get.snackbar(
  //         "",
  //         "",
  //         titleText: TextSmall(
  //           text: "Error",
  //           color: AppColors.redColor,
  //           fontWeight: FontWeight.bold,
  //         ),
  //         messageText: TextSmall(
  //           text: "Sorry, some seats you selected are not available.",
  //           color: AppColors.redColor,
  //         ),
  //         borderWidth: 1,
  //         borderColor: AppColors.redColor,
  //         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 70),
  //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         backgroundColor: AppColors.whiteColor,
  //         duration: Duration(seconds: 2),
  //       );
  //     } else if (status == 1) {
  //       // ✅ Case: Booking success
  //       Get.offAllNamed(AppRoutes.transaction_screen, arguments: {
  //         'masg': response.body?.msg,
  //         'transactionId': response.body?.transactionId,
  //         'status': response.body?.status,
  //         'totalPrice': totalAmount.toString(),
  //         'totalSeat': allSeats.length.toString(),
  //       });

  //       Get.find<BookingService>().reset();
  //     } else {
  //       // 💸 Case: Money not enough
  //       showPassengerInfoDialog();
  //     }
  //   } catch (e) {
  //     uiState.value.errorMessage.value = e.toString();
  //   } finally {
  //     uiState.value.isLoading.value = false;
  //     uiState.value.buttonText.value = 'ដំណើរការដើម្បីចូលបង់ប្រាក់';
  //   }
  // }