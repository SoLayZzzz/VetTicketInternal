// ignore_for_file: avoid_print

import 'package:vet_internal_ticket/core/app_url/boarding_url.dart';
import 'package:vet_internal_ticket/core/app_url/booking_url.dart';
import 'package:vet_internal_ticket/core/app_url/national_url.dart';
import 'package:vet_internal_ticket/core/base/contentType.dart';
import 'package:vet_internal_ticket/core/network/network_data_source.dart';
import 'package:vet_internal_ticket/view/booking/data/model/request/booking_cf_body.dart';
import 'package:vet_internal_ticket/view/booking/data/model/response/booking_cofirm_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/boarding_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/national_model.dart';

class PassengerNetwork {
  final NetworkDataSource _networkDataSource;
  PassengerNetwork(this._networkDataSource);

  Future<BoardingModel> boardingStation(String id) async {
    var body = {'id': id};

    final response = await _networkDataSource.safePost(
      BoardingUrl.boardingPointById(id),
      body,
      contentType: ContentTypeVET.contentType,
      decoder: (data) {
        return BoardingModel.fromJson(data);
      },
    );
    if (response == null) {
      throw Exception('Faild to get boarding station');
    }

    return response;
  }

  Future<BoardingModel> downStation(String id) async {
    var body = {'id': id};

    final response = await _networkDataSource.safePost(
      BoardingUrl.downPointById(id),
      body,
      contentType: ContentTypeVET.contentType,
      decoder: (data) {
        return BoardingModel.fromJson(data);
      },
    );

    if (response == null) {
      throw Exception('Faild to fetch down station');
    }

    return response;
  }

  Future<BookingCofirmModel> bookingCofirm(BookingCfBody body) async {
    final bodyData = body.toMap();

    print("📤 ======>> Sending as form-urlencoded:");
    print(Uri(queryParameters: bodyData).query);

    final response = await _networkDataSource.safePost(
      BookingUrl.bookingConfirm,
      bodyData,
      contentType: ContentTypeVET.contentType,
      decoder: (data) => BookingCofirmModel.fromJson(data),
    );

    if (response == null) {
      throw Exception('Failed to post Booking Cofirm');
    }

    return response;
  }

  Future<NationalistModel> getNational() async {
    final response = await _networkDataSource.safePost(
        NationalUrl.bookingCheckIn, null,
        contentType: ContentTypeVET.contentType, decoder: (data) {
      return NationalistModel.fromJson(data);
    });

    if (response == null) {
      throw Exception('Faild to get national');
    }

    return response;
  }
}
