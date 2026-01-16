import 'package:vet_internal_ticket/core/app_url/booking_url.dart';
import 'package:vet_internal_ticket/core/base/contentType.dart';
import 'package:vet_internal_ticket/core/network/network_data_source.dart';
import 'package:vet_internal_ticket/view/booking/data/model/request/booking_transaction_body.dart';
import 'package:vet_internal_ticket/view/booking/data/model/response/booking_transaction_response.dart';

class BookingNetworkDatasourece {
  final NetworkDataSource networkDataSource;

  BookingNetworkDatasourece(this.networkDataSource);

  Future<BookingCheckTransactionModel> getBookingTransaction(
      BookingTransactionBody body) async {
    final reponse = await networkDataSource.safePost(
      BookingUrl.bookingCheckTransaction,
      body.toMap(),
      contentType: ContentTypeVET.contentType,
      decoder: (data) {
        return BookingCheckTransactionModel.fromJson(data);
      },
    );
    if (reponse == null) {
      throw Exception('Fail to get transaction');
    }
    return reponse;
  }
}
