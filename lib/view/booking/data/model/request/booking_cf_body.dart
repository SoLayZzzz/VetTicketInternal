class BookingCfBody {
  final List<String> boardingPointId;
  final List<String> dropOffId;
  final String email;
  final List<String> journeyDate;
  final List<String> journeyId;
  final String journeyType;
  final String markup;
  final String name;
  final String nationally;
  final List<String> seatGender;
  final List<String> seatJourney;
  final List<String> seatNum;
  final List<String> seatPrice;
  final String telephone;
  final String totalAmount;
  final String totalSeat;

  BookingCfBody({
    required this.boardingPointId,
    required this.dropOffId,
    required this.email,
    required this.journeyDate,
    required this.journeyId,
    required this.journeyType,
    required this.markup,
    required this.name,
    required this.nationally,
    required this.seatGender,
    required this.seatJourney,
    required this.seatNum,
    required this.seatPrice,
    required this.telephone,
    required this.totalAmount,
    required this.totalSeat,
  });

  Map<String, String> toMap() {
    return {
      'boardingPointId': boardingPointId.join(','),
      'dropOffId': dropOffId.join(','),
      'email': email,
      'journeyDate': journeyDate.join(','),
      'journeyId': journeyId.join(','),
      'journeyType': journeyType,
      'markup': markup,
      'name': name,
      'nationally': nationally,
      'seatGender': seatGender.join(','),
      'seatJourney': seatJourney.join(','),
      'seatNum': seatNum.join(','),
      'seatPrice': seatPrice.join(','),
      'telephone': telephone,
      'totalAmount': totalAmount,
      'totalSeat': totalSeat,
    };
  }
}
