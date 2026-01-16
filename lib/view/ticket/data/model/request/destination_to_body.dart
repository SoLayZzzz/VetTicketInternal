class DestinationToBody {
  final String fromId;
  final String lang;
  final String searchText;
  final String type;

  DestinationToBody(
      {required this.fromId,
      required this.lang,
      required this.searchText,
      required this.type});

  Map<String, String> toMap() {
    return {
      'fromId': fromId,
      'lang': lang,
      'searchText': searchText,
      'type': type
    };
  }
}
