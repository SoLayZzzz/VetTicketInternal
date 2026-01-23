class BookingHistoryListResponseModel {
  Header? header;
  BookingHistoryListBodyResponse? body;

  BookingHistoryListResponseModel({this.header, this.body});

  BookingHistoryListResponseModel.fromJson(Map<String, dynamic> json) {
    header = json['header'] != null ? Header.fromJson(json['header']) : null;
    body = json['body'] != null
        ? BookingHistoryListBodyResponse.fromJson(json['body'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (header != null) {
      data['header'] = header!.toJson();
    }
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serverTimestamp'] = serverTimestamp;
    data['result'] = result;
    data['statusCode'] = statusCode;
    return data;
  }
}

class BookingHistoryListBodyResponse {
  bool? status;
  String? message;
  List<BookingHistoryItem>? data;
  Pagination? pagination;

  BookingHistoryListBodyResponse(
      {this.status, this.message, this.data, this.pagination});

  BookingHistoryListBodyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(BookingHistoryItem.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['status'] = status;
    jsonData['message'] = message;
    if (data != null) {
      jsonData['data'] = data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      jsonData['pagination'] = pagination!.toJson();
    }
    return jsonData;
  }
}

class BookingHistoryItem {
  int? id;
  String? bookingDate;
  String? travelDate;
  String? code;
  String? destinationFrom;
  String? destinationTo;
  String? departure;
  String? arrival;
  String? duration;
  String? paymentType;
  String? transportationType;
  String? boardingPoint;
  String? dropOffPoint;
  String? subTotal;
  String? discount;
  String? totalAmount;
  String? totalVat;
  int? isSurvey;
  int? isLuckyDraw;
  int? isTravelPackage;
  int? journeyType;
  int? totalSeat;

  BookingHistoryItem(
      {this.id,
      this.bookingDate,
      this.travelDate,
      this.code,
      this.destinationFrom,
      this.destinationTo,
      this.departure,
      this.arrival,
      this.duration,
      this.paymentType,
      this.transportationType,
      this.boardingPoint,
      this.dropOffPoint,
      this.subTotal,
      this.discount,
      this.totalAmount,
      this.totalVat,
      this.isSurvey,
      this.isLuckyDraw,
      this.isTravelPackage,
      this.journeyType,
      this.totalSeat});

  BookingHistoryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingDate = json['bookingDate'];
    travelDate = json['travelDate'];
    code = json['code'];
    destinationFrom = json['destinationFrom'];
    destinationTo = json['destinationTo'];
    departure = json['departure'];
    arrival = json['arrival'];
    duration = json['duration'];
    paymentType = json['paymentType'];
    transportationType = json['transportationType'];
    boardingPoint = json['boardingPoint'];
    dropOffPoint = json['dropOffPoint'];
    subTotal = json['subTotal'];
    discount = json['discount'];
    totalAmount = json['totalAmount'];
    totalVat = json['totalVat'];
    isSurvey = json['isSurvey'];
    isLuckyDraw = json['isLuckyDraw'];
    isTravelPackage = json['isTravelPackage'];
    journeyType = json['journeyType'];
    totalSeat = json['totalSeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookingDate'] = bookingDate;
    data['travelDate'] = travelDate;
    data['code'] = code;
    data['destinationFrom'] = destinationFrom;
    data['destinationTo'] = destinationTo;
    data['departure'] = departure;
    data['arrival'] = arrival;
    data['duration'] = duration;
    data['paymentType'] = paymentType;
    data['transportationType'] = transportationType;
    data['boardingPoint'] = boardingPoint;
    data['dropOffPoint'] = dropOffPoint;
    data['subTotal'] = subTotal;
    data['discount'] = discount;
    data['totalAmount'] = totalAmount;
    data['totalVat'] = totalVat;
    data['isSurvey'] = isSurvey;
    data['isLuckyDraw'] = isLuckyDraw;
    data['isTravelPackage'] = isTravelPackage;
    data['journeyType'] = journeyType;
    data['totalSeat'] = totalSeat;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['rowsPerPage'] = rowsPerPage;
    data['total'] = total;
    return data;
  }
}
