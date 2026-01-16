// ignore_for_file: unnecessary_this, unnecessary_new

import 'package:vet_internal_ticket/core/base/header.dart';

class SeatUnavailableModel {
  Header? header;
  List<SeatUnavailableModelResponse>? body;

  SeatUnavailableModel({this.header, this.body});

  SeatUnavailableModel.fromJson(Map<String, dynamic> json) {
    header = json['header'] != null
        ? new Header.fromJson(json['header'], (data) => data)
        : null;
    if (json['body'] != null) {
      body = <SeatUnavailableModelResponse>[];
      json['body'].forEach((v) {
        body!.add(new SeatUnavailableModelResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.header != null) {
      data['header'] = this.header!.toJson((data) => data);
    }
    if (this.body != null) {
      data['body'] = this.body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeatUnavailableModelResponse {
  String? seatNumber;
  String? gender;
  int? status;
  int? allowGender;

  SeatUnavailableModelResponse(
      {this.seatNumber, this.gender, this.status, this.allowGender});

  SeatUnavailableModelResponse.fromJson(Map<String, dynamic> json) {
    seatNumber = json['seatNumber'];
    gender = json['gender'];
    status = json['status'];
    allowGender = json['allowGender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seatNumber'] = this.seatNumber;
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['allowGender'] = this.allowGender;
    return data;
  }
}
