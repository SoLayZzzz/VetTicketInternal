class BookingHistoryFindResponseModel {
  Header? header;
  BookingHistoryFindBodyResponse? body;

  BookingHistoryFindResponseModel({this.header, this.body});

  BookingHistoryFindResponseModel.fromJson(Map<String, dynamic> json) {
    header = json['header'] != null ? Header.fromJson(json['header']) : null;
    body = json['body'] != null
        ? BookingHistoryFindBodyResponse.fromJson(json['body'])
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

class BookingHistoryFindBodyResponse {
  bool? status;
  String? message;
  List<BookingHistoryDetailItem>? data;

  BookingHistoryFindBodyResponse({this.status, this.message, this.data});

  BookingHistoryFindBodyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(BookingHistoryDetailItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['status'] = status;
    jsonData['message'] = message;
    if (data != null) {
      jsonData['data'] = data!.map((v) => v.toJson()).toList();
    }
    return jsonData;
  }
}

class BookingHistoryDetailItem {
  int? id;
  String? bookingDate;
  String? travelDate;
  String? code;
  String? telephone;
  String? destinationFrom;
  String? destinationTo;
  String? departure;
  String? arrival;
  String? duration;
  String? paymentType;
  String? transportationType;
  String? boardingPoint;
  String? boardingPointLat;
  String? boardingPointLong;
  String? boardingPointAddress;
  String? dropOffPoint;
  String? dropOffPointLat;
  String? dropOffPointLong;
  String? dropOffPointAddress;
  String? subTotal;
  String? discount;
  String? discountPercent;
  String? totalAmount;
  String? totalVat;
  String? luckDrawFee;
  int? companyType;
  String? transactionId;
  int? journeyType;
  List<BookingSeatDetail>? bookingSeatDetailList;

  BookingHistoryDetailItem(
      {this.id,
      this.bookingDate,
      this.travelDate,
      this.code,
      this.telephone,
      this.destinationFrom,
      this.destinationTo,
      this.departure,
      this.arrival,
      this.duration,
      this.paymentType,
      this.transportationType,
      this.boardingPoint,
      this.boardingPointLat,
      this.boardingPointLong,
      this.boardingPointAddress,
      this.dropOffPoint,
      this.dropOffPointLat,
      this.dropOffPointLong,
      this.dropOffPointAddress,
      this.subTotal,
      this.discount,
      this.discountPercent,
      this.totalAmount,
      this.totalVat,
      this.luckDrawFee,
      this.companyType,
      this.transactionId,
      this.journeyType,
      this.bookingSeatDetailList});

  BookingHistoryDetailItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingDate = json['bookingDate'];
    travelDate = json['travelDate'];
    code = json['code'];
    telephone = json['telephone'];
    destinationFrom = json['destinationFrom'];
    destinationTo = json['destinationTo'];
    departure = json['departure'];
    arrival = json['arrival'];
    duration = json['duration'];
    paymentType = json['paymentType'];
    transportationType = json['transportationType'];
    boardingPoint = json['boardingPoint'];
    boardingPointLat = json['boardingPointLat'];
    boardingPointLong = json['boardingPointLong'];
    boardingPointAddress = json['boardingPointAddress'];
    dropOffPoint = json['dropOffPoint'];
    dropOffPointLat = json['dropOffPointLat'];
    dropOffPointLong = json['dropOffPointLong'];
    dropOffPointAddress = json['dropOffPointAddress'];
    subTotal = json['subTotal'];
    discount = json['discount'];
    discountPercent = json['discountPercent'];
    totalAmount = json['totalAmount'];
    totalVat = json['totalVat'];
    luckDrawFee = json['luckDrawFee'];
    companyType = json['companyType'];
    transactionId = json['transactionId'];
    journeyType = json['journeyType'];
    if (json['bookingSeatDetailList'] != null) {
      bookingSeatDetailList = [];
      json['bookingSeatDetailList'].forEach((v) {
        bookingSeatDetailList!.add(BookingSeatDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookingDate'] = bookingDate;
    data['travelDate'] = travelDate;
    data['code'] = code;
    data['telephone'] = telephone;
    data['destinationFrom'] = destinationFrom;
    data['destinationTo'] = destinationTo;
    data['departure'] = departure;
    data['arrival'] = arrival;
    data['duration'] = duration;
    data['paymentType'] = paymentType;
    data['transportationType'] = transportationType;
    data['boardingPoint'] = boardingPoint;
    data['boardingPointLat'] = boardingPointLat;
    data['boardingPointLong'] = boardingPointLong;
    data['boardingPointAddress'] = boardingPointAddress;
    data['dropOffPoint'] = dropOffPoint;
    data['dropOffPointLat'] = dropOffPointLat;
    data['dropOffPointLong'] = dropOffPointLong;
    data['dropOffPointAddress'] = dropOffPointAddress;
    data['subTotal'] = subTotal;
    data['discount'] = discount;
    data['discountPercent'] = discountPercent;
    data['totalAmount'] = totalAmount;
    data['totalVat'] = totalVat;
    data['luckDrawFee'] = luckDrawFee;
    data['companyType'] = companyType;
    data['transactionId'] = transactionId;
    data['journeyType'] = journeyType;
    if (bookingSeatDetailList != null) {
      data['bookingSeatDetailList'] =
          bookingSeatDetailList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingSeatDetail {
  String? gender;
  String? seatNumber;
  String? price;
  String? nationalityName;
  String? passport;
  String? dob;

  BookingSeatDetail(
      {this.gender,
      this.seatNumber,
      this.price,
      this.nationalityName,
      this.passport,
      this.dob});

  BookingSeatDetail.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    seatNumber = json['seatNumber'];
    price = json['price'];
    nationalityName = json['nationalityName'];
    passport = json['passport'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    data['seatNumber'] = seatNumber;
    data['price'] = price;
    data['nationalityName'] = nationalityName;
    data['passport'] = passport;
    data['dob'] = dob;
    return data;
  }
}
