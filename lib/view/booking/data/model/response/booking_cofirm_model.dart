// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

class Header {
  int? serverTimestamp;
  bool? result;
  int? statusCode;

  Header({this.serverTimestamp, this.result, this.statusCode});

  Header.fromJson(Map<String, dynamic> json) {
    serverTimestamp = json['serverTimestamp'];
    result = json['result'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serverTimestamp'] = this.serverTimestamp;
    data['result'] = this.result;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class BookingCofirmModel {
  Header? header;
  BookingCFResponse? body;

  BookingCofirmModel({this.header, this.body});

  BookingCofirmModel.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    body = json['body'] != null
        ? new BookingCFResponse.fromJson(json['body'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header!.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class BookingCFResponse {
  String? msg;
  String? transactionId;
  int? status;

  BookingCFResponse({this.msg, this.transactionId, this.status});

  BookingCFResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    transactionId = json['transactionId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['transactionId'] = this.transactionId;
    data['status'] = this.status;
    return data;
  }
}
