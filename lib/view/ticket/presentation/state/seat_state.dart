import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_layout_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/seat_unavailable_model.dart';

class SeatState {
  final RxBool isLoading = false.obs;
  final RxString errorMessange = ''.obs;
  final Rx<SeatLayoutModel?> seatModel = Rx<SeatLayoutModel?>(null);
  final Rx<SeatUnavailableModel?> seatUnavailableModel =
      Rx<SeatUnavailableModel?>(null);

  String date = "";
  String? dateBack;
  String fromName = "";
  String toName = "";
  String? fromId;
  String? toId;
  String? selectType;
  RxInt? markup;

  String journey = "";
  String? seatPrice;
  double? totalPrice;
  String? totalSeat;
  RxBool isReturnTrip = false.obs;

  String? journeyGo;
  String? journeyBack;

  final RxList<Map<String, String>> goTripSeats = <Map<String, String>>[].obs;

  final RxList<Map<String, String>> selectedSeats = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> selectedSeatback =
      <Map<String, String>>[].obs;

  final RxList<String> occupiedSeats = <String>[].obs;

  void update() {
    isLoading.trigger(!isLoading.value);
    isLoading.trigger(!isLoading.value);
  }

  var selectedGoSeats = <Map<String, String>>[].obs;
  var selectedReturnSeats = <Map<String, String>>[].obs;

  //

  // String? journeyGo;
  // String? journeyBack;

  String goFromName = "";
  String goToName = "";
  String? goFromId;
  String? goToId;

  List<Map<String, String>> goTripSelectedSeats = [];
}
