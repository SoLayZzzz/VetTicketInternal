class SeatUrl {
  static const seatLayout = 'seat/layout';
  static const seatList = 'seat/list';
  static const seatUnavailable = 'seat/unavailable';

  static String seatCheckInLayout(String id) {
    return 'booking/checkInLayout?busId=$id';
  }
}
