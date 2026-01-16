import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/schedule_response.dart';

class ScheduleState {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<ScheduleModel?> scheduleData = Rx<ScheduleModel?>(null);
  final RxInt markup = 0.obs;
  final RxString selectDate = "".obs;

  // Route arguments
  String? fromId;
  String? fromName;
  String? toId;
  String? toName;
  String? selectType;

  // Date information
  RxString selectDateBack = "".obs;

  RxBool isReturnTrip = false.obs;

  // For seat
  List<String> goingTripSelectedSeats = [];
  String? originalDate;

  // For seat selection
  String? journeyId;
  String? seatJourney;
  String? seatPrice;
  String? totalAmount;
  String? totalSeat;
  String? id;
}
