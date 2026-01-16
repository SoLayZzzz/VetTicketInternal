// ignore_for_file: unnecessary_new, prefer_collection_literals

class CheckinLayoutModel {
  String? errorCode;
  String? errorText;
  Pagination? pagination;
  bool? result;
  int? serverTimestamp;
  int? statusCode;

  CheckinLayoutModel(
      {this.errorCode,
      this.errorText,
      this.pagination,
      this.result,
      this.serverTimestamp,
      this.statusCode});

  CheckinLayoutModel.fromJson(Map<String, dynamic> json) {
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

class CheckinLayoutResponse {
  CheckinLayoutModel? header;
  CheckinLayoutResult? body;

  CheckinLayoutResponse({this.header, this.body});

  CheckinLayoutResponse.fromJson(Map<String, dynamic> json) {
    header = json['header'] != null
        ? new CheckinLayoutModel.fromJson(json['header'])
        : null;
    body = json['body'] != null
        ? new CheckinLayoutResult.fromJson(json['body'])
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

class CheckinLayoutResult {
  List<SeatSelected>? seatSelected;
  String? layoutSeat;
  String? destinationTo;
  String? departure;

  CheckinLayoutResult(
      {this.seatSelected, this.layoutSeat, this.destinationTo, this.departure});

  CheckinLayoutResult.fromJson(Map<String, dynamic> json) {
    if (json['seatSelected'] != null) {
      seatSelected = <SeatSelected>[];
      json['seatSelected'].forEach((v) {
        seatSelected!.add(new SeatSelected.fromJson(v));
      });
    }
    layoutSeat = json['layoutSeat'];
    destinationTo = json['destinationTo'];
    departure = json['departure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.seatSelected != null) {
      data['seatSelected'] = this.seatSelected!.map((v) => v.toJson()).toList();
    }
    data['layoutSeat'] = this.layoutSeat;
    data['destinationTo'] = this.destinationTo;
    data['departure'] = this.departure;
    return data;
  }
}

class SeatSelected {
  String? seatNumber;
  String? seatLabel;
  String? ticketCode;
  String? reference;
  String? telephone;
  String? scanCode;
  String? soldBy;
  String? note;
  int? enable;
  int? checkIn;

  SeatSelected(
      {this.seatNumber,
      this.seatLabel,
      this.ticketCode,
      this.reference,
      this.telephone,
      this.scanCode,
      this.soldBy,
      this.note,
      this.enable,
      this.checkIn});

  SeatSelected.fromJson(Map<String, dynamic> json) {
    seatNumber = json['seatNumber'];
    seatLabel = json['seatLabel'];
    ticketCode = json['ticketCode'];
    reference = json['reference'];
    telephone = json['telephone'];
    scanCode = json['scanCode'];
    soldBy = json['soldBy'];
    note = json['note'];
    enable = json['enable'];
    checkIn = json['checkIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seatNumber'] = this.seatNumber;
    data['seatLabel'] = this.seatLabel;
    data['ticketCode'] = this.ticketCode;
    data['reference'] = this.reference;
    data['telephone'] = this.telephone;
    data['scanCode'] = this.scanCode;
    data['soldBy'] = this.soldBy;
    data['note'] = this.note;
    data['enable'] = this.enable;
    data['checkIn'] = this.checkIn;
    return data;
  }
}
