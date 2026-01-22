class BookingHistoryFindBody {
  final int id;

  BookingHistoryFindBody({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }
}
