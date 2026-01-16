// ignore_for_file: unnecessary_new, prefer_collection_literals

class CheckInModel {
  String? errorCode;
  String? errorText;
  Pagination? pagination;
  bool? result;
  int? serverTimestamp;
  int? statusCode;

  CheckInModel(
      {this.errorCode,
      this.errorText,
      this.pagination,
      this.result,
      this.serverTimestamp,
      this.statusCode});

  CheckInModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorText = json['errorText'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    result = json['result'];
    serverTimestamp = json['serverTimestamp'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorText'] = this.errorText;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    data['result'] = this.result;
    data['serverTimestamp'] = this.serverTimestamp;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class CheckinResponse {
  CheckInModel? header;
  CheckinResult? body;

  CheckinResponse({this.header, this.body});

  CheckinResponse.fromJson(Map<String, dynamic> json) {
    header = json['header'] != null
        ? new CheckInModel.fromJson(json['header'])
        : null;
    body =
        json['body'] != null ? new CheckinResult.fromJson(json['body']) : null;
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

class CheckinResult {
  String? code;
  String? seatNumber;
  String? desc;
  String? seatLabel;
  int? status;

  CheckinResult(
      {this.code, this.seatNumber, this.desc, this.seatLabel, this.status});

  CheckinResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    seatNumber = json['seatNumber'];
    desc = json['desc'];
    seatLabel = json['seatLabel'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['seatNumber'] = this.seatNumber;
    data['desc'] = this.desc;
    data['seatLabel'] = this.seatLabel;
    data['status'] = this.status;
    return data;
  }
}

class Pagination {
  int? page;
  int? rowsPerPage;
  int? total;

  Pagination({this.page, this.rowsPerPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    rowsPerPage = json['rowsPerPage'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['rowsPerPage'] = this.rowsPerPage;
    data['total'] = this.total;
    return data;
  }
}
