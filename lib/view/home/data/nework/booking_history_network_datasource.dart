import 'package:vet_internal_ticket/core/app_endpoint/booking_history_endpoint.dart';
import 'package:vet_internal_ticket/core/base/contentType.dart';
import 'package:vet_internal_ticket/core/network/network_data_source.dart';
import 'package:vet_internal_ticket/view/home/data/model/request/booking_history_find_body.dart';
import 'package:vet_internal_ticket/view/home/data/model/request/booking_history_list_body.dart';
import 'package:vet_internal_ticket/view/home/data/model/response/booking_history_find_response.dart';
import 'package:vet_internal_ticket/view/home/data/model/response/booking_history_list_response.dart';

class BookingHistoryNetworkDatasource {
  final NetworkDataSource networkDataSource;

  BookingHistoryNetworkDatasource(this.networkDataSource);

  Future<BookingHistoryListResponseModel> getBookingHistoryList(
      BookingHistoryListBody body) async {
    final response = await networkDataSource.safePost(
      BookingHistoryEndpoint.bookingHistoryList,
      body.toMap(),
      contentType: ContentTypeVET.contentTypeJson,
      decoder: (data) {
        return BookingHistoryListResponseModel.fromJson(data);
      },
    );
    if (response == null) {
      throw Exception('Fail to get booking history list');
    }
    return response;
  }

  Future<BookingHistoryFindResponseModel> getBookingHistoryById(
      {required int id, required BookingHistoryFindBody body}) async {
    final url = BookingHistoryEndpoint.bookingHistoryByID
        .replaceAll('{id}', id.toString());

    final response = await networkDataSource.safePost(
      url,
      body.toMap(),
      contentType: ContentTypeVET.contentTypeJson,
      decoder: (data) {
        return BookingHistoryFindResponseModel.fromJson(data);
      },
    );
    if (response == null) {
      throw Exception('Fail to get booking history detail');
    }
    return response;
  }
}
