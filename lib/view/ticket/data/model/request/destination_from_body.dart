class DestinationFromBody {
  final String lang;
  final String searchText;
  final String type;

  DestinationFromBody({
    required this.lang,
    required this.searchText,
    required this.type,
  });

  Map<String, String> toMap() {
    return {
      'lang': lang,
      'searchText': searchText,
      'type': type,
    };
  }
}
