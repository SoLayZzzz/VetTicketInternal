class BoardingUrl {
  static String boardingPointById(String id) {
    return 'boarding-point/findBySchedule/$id';
  }

  static String downPointById(String id) {
    return 'drop-off-point/findBySchedule/$id';
  }
}
