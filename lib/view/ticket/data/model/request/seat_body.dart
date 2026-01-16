class SeatBody {
  final String date;
  final String shecduleid;

  SeatBody({required this.date, required this.shecduleid});

  Map<String, String> toMap() {
    return {'date': date, 'journey': shecduleid};
  }
}
