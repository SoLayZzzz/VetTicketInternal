import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:vet_internal_ticket/view/booking/data/model/response/booking_cofirm_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/boarding_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/national_model.dart';

class PasengerDetailState {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt status = 0.obs;
  final RxString buttonText = "ដំណើរការដើម្បីចូលបង់ប្រាក់".obs;
  final RxBool hasSubmitted = false.obs;

  final phoneController = TextEditingController();
  final RxBool showPhoneError = false.obs;
  final RxBool showGenderError = false.obs;
  final RxBool showNationalError = false.obs;

  RxBool isReturnTrip = true.obs;

  // Gender Selection
  final RxMap<String, int> passengerGenders = <String, int>{}.obs;
  RxInt male = 1.obs;
  RxInt female = 2.obs;
  String? gender;

  // Nationality Selection
  final Rx<NationalistModel?> national = Rx<NationalistModel?>(null);
  final RxList<String> nationalityNames = <String>[].obs;
  final RxInt selectedNationalityId = 0.obs;
  final RxBool showNationalityError = false.obs;
  final isSelectingNationality = false.obs;

  String? fromName;
  String? toName;
  String? date;
  String? dateBack;
  String? seatPrice;
  double totalPrice = 0;
  String? totalSeat;
  int? markup;

  String? journeyId;
  String? journeyBack;
  String scheduleId = "";

  final selectedSeats = <Map<String, String>>[].obs; // "Go" trip seats
  final selectedSeatback = <Map<String, String>>[].obs; // "Back" trip seats

  final Rx<BoardingResponse?> boardingStaion = Rx<BoardingResponse?>(null);
  final Rx<BoardingResponse?> downStaion = Rx<BoardingResponse?>(null);
  final Rx<BookingCofirmModel?> bookingCFModel = Rx<BookingCofirmModel?>(null);
  //
  final Rx<BoardingResponse?> goBoardingStation = Rx<BoardingResponse?>(null);
  final Rx<BoardingResponse?> goDropStation = Rx<BoardingResponse?>(null);
  final Rx<BoardingResponse?> returnBoardingStation =
      Rx<BoardingResponse?>(null);
  final Rx<BoardingResponse?> returnDropStation = Rx<BoardingResponse?>(null);

  // ✅ NEW: Lists of available stations
  final RxList<BoardingResponse> goBoardingStationList =
      <BoardingResponse>[].obs;
  final RxList<BoardingResponse> goDropStationList = <BoardingResponse>[].obs;
  final RxList<BoardingResponse> returnBoardingStationList =
      <BoardingResponse>[].obs;
  final RxList<BoardingResponse> returnDropStationList =
      <BoardingResponse>[].obs;

  String? seatJourney;
  String? transactionId;
}
