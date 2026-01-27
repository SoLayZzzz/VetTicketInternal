import 'package:get/get.dart';

class BookingService extends GetxService {
  final TripBookingData bookingData = TripBookingData();

  void reset() {
    bookingData.clear();
  }
}

class TripBookingData {
  // Go Trip
  String? goScheduleId;
  String? goFromId;
  String? goFromName;
  String? goToId;
  String? goToName;
  String? goDate;
  String? goSeatPrice;
  List<Map<String, String>> goSelectedSeats = [];
  int goMarkup = 0;

  // Return Trip
  String? returnScheduleId;
  String? returnFromId;
  String? returnFromName;
  String? returnToId;
  String? returnToName;
  String? returnDate;
  String? returnSeatPrice;
  List<Map<String, String>> returnSelectedSeats = [];
  int returnMarkup = 0;

  // Common
  String? selectType;
  int markup = 0;
  double totalPrice = 0;
  String? totalSeat;

  // ✅ Track state for navigation
  RxBool isSelectingReturnTripNow = false.obs;

  bool get isRoundTrip => returnScheduleId != null;

  void calculateTotalSeat() {
    totalSeat =
        (goSelectedSeats.length + returnSelectedSeats.length).toString();
  }

  void calculateTotalPrice() {
    final goPrice = double.tryParse(goSeatPrice ?? '0.0') ?? 0.0;
    final returnPrice = double.tryParse(returnSeatPrice ?? '0.0') ?? 0.0;
    final goTotal = goPrice * goSelectedSeats.length;
    final returnTotal = returnPrice * returnSelectedSeats.length;
    final goMarkupTotal = goMarkup * goSelectedSeats.length;
    final returnMarkupTotal = returnMarkup * returnSelectedSeats.length;
    totalPrice = goTotal + returnTotal + goMarkupTotal + returnMarkupTotal;
  }

  void clear() {
    goSelectedSeats.clear();
    returnSelectedSeats.clear();
    goScheduleId = returnScheduleId = null;
    goFromId = goToId = goFromName = goToName = null;
    returnFromId = returnToId = returnFromName = returnToName = null;
    goDate = returnDate = null;
    goSeatPrice = returnSeatPrice = null;
    totalSeat = null;
    totalPrice = 0;
    markup = 0;
    goMarkup = 0;
    returnMarkup = 0;
    isSelectingReturnTripNow.value = false;
  }

  void resetReturnSelection() {
    returnScheduleId = null;
    returnFromId = returnToId = null;
    returnFromName = returnToName = null;
    returnDate = null;
    returnSeatPrice = null;
    returnSelectedSeats.clear();
    returnMarkup = 0;
    isSelectingReturnTripNow.value = false;
  }

  void debugPrint() {
    print("🔍 Booking Trip Data");
    print("Go: $goFromName → $goToName Date: $goDate Seats: $goSelectedSeats");
    if (isRoundTrip) {
      print(
          "Return: $returnFromName → $returnToName Date: $returnDate Seats: $returnSelectedSeats");
    }
    print(
        "TotalPrice: $totalPrice, GoMarkup: $goMarkup, ReturnMarkup: $returnMarkup, Markup(legacy): $markup");
  }
}
