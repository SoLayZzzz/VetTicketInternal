class BookingTransactionBody {
  final String transactionId;

  BookingTransactionBody({required this.transactionId});

  Map<String, String> toMap() {
    return {'transactionId': transactionId};
  }
}
