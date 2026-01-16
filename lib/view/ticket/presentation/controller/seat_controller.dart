import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/seat_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_layout_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_unavailable_model.dart';
import 'package:vet_internal_ticket/booking_service.dart';
import 'package:vet_internal_ticket/view/ticket/domain/uscase/seat_uscase.dart';

import 'package:vet_internal_ticket/view/ticket/presentation/state/seat_state.dart';

class SeatController extends StateController<SeatState> {
  final SeatUscase seatUscase;
  SeatController(this.seatUscase);

  @override
  SeatState onInitUiState() => SeatState();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null) {
      getAgrumentFromSchedule(
        date: args['date'],
        dateBack: args['dateback'],
        id: args['id'],
        fromName: args['fromName'],
        toName: args['toName'],
        seatPrice: args['seatPrice'],
        totalSeat: args['totalSeat'],
        fromId: args['fromId'],
        toId: args['toId'],
        markup: args['markup'],
        totalPrice: args['totalPrice'],
        type: args['type'],
        isReturnTrip: args['isReturnTrip'] ?? false,
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
    fetchSeatLayout();
  }

  void getAgrumentFromSchedule({
    required String date,
    required String dateBack,
    required String id,
    required String fromName,
    required String toName,
    required String seatPrice,
    required String totalSeat,
    required String fromId,
    required String toId,
    required RxInt markup,
    required double totalPrice,
    required dynamic type,
    required RxBool isReturnTrip,
  }) {
    uiState.value.date = date;
    uiState.value.dateBack = dateBack;
    uiState.value.journey = id;
    uiState.value.fromName = fromName;
    uiState.value.toName = toName;
    uiState.value.seatPrice = seatPrice;
    uiState.value.totalSeat = totalSeat;
    uiState.value.fromId = fromId;
    uiState.value.toId = toId;
    uiState.value.markup = markup;
    uiState.value.totalPrice = totalPrice;
    uiState.value.selectType = type.toString();
    uiState.value.isReturnTrip.value = isReturnTrip.value;
  }

  void goBackToSchedule() {
    Get.back(result: 'cancelled');
  }

  Future<void> fetchSeatLayout() async {
    try {
      uiState.value.isLoading.value = true;
      final body =
          SeatBody(date: uiState.value.date, shecduleid: uiState.value.journey);
      final [layoutResult, unavailableResult] = await Future.wait([
        seatUscase.executeSeatLayout(body),
        seatUscase.executeSeatUnvailable(body)
      ]);
      uiState.value.seatModel.value = layoutResult as SeatLayoutModel?;
      uiState.value.seatUnavailableModel.value =
          unavailableResult as SeatUnavailableModel?;
      _initializeSeatStatus(unavailableResult as SeatUnavailableModel);
    } finally {
      uiState.value.isLoading.value = false;
    }
  }

  void _initializeSeatStatus(SeatUnavailableModel? model) {
    uiState.value.occupiedSeats.clear();
    if (model != null && model.body != null) {
      for (var seat in model.body!) {
        if (seat.seatNumber?.isNotEmpty ?? false) {
          uiState.value.occupiedSeats.add(seat.seatNumber!.trim());
        }
      }
    }
  }

  void selectSeat(String seatValue, String seatLabel) {
    final seat = {'value': seatValue, 'label': seatLabel};
    if (uiState.value.selectedSeats.any((s) => s['value'] == seatValue)) {
      uiState.value.selectedSeats.removeWhere((s) => s['value'] == seatValue);
    } else {
      uiState.value.selectedSeats.add(seat);
    }
    uiState.value.update();
  }

  // SeatController.dart

  void navigateToPassengerDetail(String scheduleId) {
    final booking = Get.find<BookingService>().bookingData;
    final selectedSeats = state.selectedSeats.toList();

    if (!state.isReturnTrip.value) {
      // Save Go Trip
      booking.goScheduleId = scheduleId;
      booking.goFromId = state.fromId;
      booking.goToId = state.toId;
      booking.goFromName = state.fromName;
      booking.goToName = state.toName;
      booking.goDate = state.date;
      booking.goSelectedSeats = selectedSeats;
      booking.goSeatPrice = state.seatPrice;

      // If there is a return date, signal Schedule to flip
      if ((state.dateBack ?? '').isNotEmpty) {
        Get.back(result: 'go_confirmed');
        return;
      }
    } else {
      // Save Return Trip
      booking.returnScheduleId = scheduleId;
      booking.returnFromId = state.fromId;
      booking.returnToId = state.toId;
      booking.returnFromName = state.fromName;
      booking.returnToName = state.toName;
      booking.returnDate = state.date;
      booking.returnSelectedSeats = selectedSeats;
      booking.returnSeatPrice = state.seatPrice;
    }

    booking.selectType = state.selectType;
    booking.markup = state.markup?.value ?? 0;
    booking.calculateTotalSeat();
    booking.calculateTotalPrice();

    // If return is done (or there was no return), go to passenger details
    Get.toNamed(AppRoutes.passenger_detail_screen, arguments: {
      'isReturnTrip': uiState.value.isReturnTrip,
    });
  }
}
