class ScheduleBody {
  final String date;
  final String destinationFrom;
  final String destinationTo;
  final String nationally;
  final String type;

  ScheduleBody(
      {required this.date,
      required this.destinationFrom,
      required this.destinationTo,
      required this.nationally,
      required this.type});

  Map<String, String> toMap() {
    return {
      'date': date,
      'destinationFrom': destinationFrom,
      'destinationTo': destinationTo,
      'nationally': nationally,
      'type': type
    };
  }
}
