// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class BookingCheckTransactionModel {
  Header? header;
  BookingTransactionResponse? body;

  BookingCheckTransactionModel({this.header, this.body});

  BookingCheckTransactionModel.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    body = json['body'] != null
        ? new BookingTransactionResponse.fromJson(json['body'])
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

class BookingTransactionResponse {
  String? transactionId;
  String? transactionDate;
  String? totalAmount;
  int? status;
  int? companyType;
  List<Ticket>? ticket;

  BookingTransactionResponse(
      {this.transactionId,
      this.transactionDate,
      this.totalAmount,
      this.status,
      this.companyType,
      this.ticket});

  BookingTransactionResponse.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    transactionDate = json['transactionDate'];
    totalAmount = json['totalAmount'];
    status = json['status'];
    companyType = json['companyType'];
    if (json['ticket'] != null) {
      ticket = <Ticket>[];
      json['ticket'].forEach((v) {
        ticket!.add(new Ticket.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['transactionDate'] = this.transactionDate;
    data['totalAmount'] = this.totalAmount;
    data['status'] = this.status;
    data['companyType'] = this.companyType;
    if (this.ticket != null) {
      data['ticket'] = this.ticket!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ticket {
  String? bookingDate;
  String? travelDate;
  String? departure;
  String? destinationFrom;
  String? destinationTo;
  String? boardingPoint;
  String? dropOffPoint;
  String? telephone;
  String? totalAmount;
  String? totalVat;
  String? total;
  String? totalRiel;
  String? companyName;
  String? branchFromName;
  String? branchFromTel;
  String? branchToName;
  String? branchToTel;
  String? printDate;
  String? seatLabel;
  String? seatUnitPrice;
  int? totalSeat;
  List<Seat>? seat;

  Ticket(
      {this.bookingDate,
      this.travelDate,
      this.departure,
      this.destinationFrom,
      this.destinationTo,
      this.boardingPoint,
      this.dropOffPoint,
      this.telephone,
      this.totalAmount,
      this.totalVat,
      this.total,
      this.totalRiel,
      this.companyName,
      this.branchFromName,
      this.branchFromTel,
      this.branchToName,
      this.branchToTel,
      this.printDate,
      this.seatLabel,
      this.seatUnitPrice,
      this.totalSeat,
      this.seat});

  Ticket.fromJson(Map<String, dynamic> json) {
    bookingDate = json['bookingDate'];
    travelDate = json['travelDate'];
    departure = json['departure'];
    destinationFrom = json['destinationFrom'];
    destinationTo = json['destinationTo'];
    boardingPoint = json['boardingPoint'];
    dropOffPoint = json['dropOffPoint'];
    telephone = json['telephone'];
    totalAmount = json['totalAmount'];
    totalVat = json['totalVat'];
    total = json['total'];
    totalRiel = json['totalRiel'];
    companyName = json['companyName'];
    branchFromName = json['branchFromName'];
    branchFromTel = json['branchFromTel'];
    branchToName = json['branchToName'];
    branchToTel = json['branchToTel'];
    printDate = json['printDate'];
    seatLabel = json['seatLabel'];
    seatUnitPrice = json['seatUnitPrice'];
    totalSeat = json['totalSeat'];
    if (json['seat'] != null) {
      seat = <Seat>[];
      json['seat'].forEach((v) {
        seat!.add(new Seat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingDate'] = this.bookingDate;
    data['travelDate'] = this.travelDate;
    data['departure'] = this.departure;
    data['destinationFrom'] = this.destinationFrom;
    data['destinationTo'] = this.destinationTo;
    data['boardingPoint'] = this.boardingPoint;
    data['dropOffPoint'] = this.dropOffPoint;
    data['telephone'] = this.telephone;
    data['totalAmount'] = this.totalAmount;
    data['totalVat'] = this.totalVat;
    data['total'] = this.total;
    data['totalRiel'] = this.totalRiel;
    data['companyName'] = this.companyName;
    data['branchFromName'] = this.branchFromName;
    data['branchFromTel'] = this.branchFromTel;
    data['branchToName'] = this.branchToName;
    data['branchToTel'] = this.branchToTel;
    data['printDate'] = this.printDate;
    data['seatLabel'] = this.seatLabel;
    data['seatUnitPrice'] = this.seatUnitPrice;
    data['totalSeat'] = this.totalSeat;
    if (this.seat != null) {
      data['seat'] = this.seat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Seat {
  String? seatNumber;
  String? price;

  Seat({this.seatNumber, this.price});

  Seat.fromJson(Map<String, dynamic> json) {
    seatNumber = json['seatNumber'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seatNumber'] = this.seatNumber;
    data['price'] = this.price;
    return data;
  }
}
