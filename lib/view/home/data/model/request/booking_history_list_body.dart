class BookingHistoryListBody {
  final int page;
  final int rowsPerPage;
  final String searchText;
  final String orderBy;
  final String session;

  BookingHistoryListBody({
    required this.page,
    required this.rowsPerPage,
    required this.searchText,
    required this.orderBy,
    required this.session,
  });

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'rowsPerPage': rowsPerPage,
      'searchText': searchText,
      'orderBy': orderBy,
      'session': session,
    };
  }
}
