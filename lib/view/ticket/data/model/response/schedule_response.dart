import 'dart:convert';

import 'package:vet_internal_ticket/core/base/header.dart';

ScheduleModel scheduleModelFromJson(String str) =>
    ScheduleModel.fromJson(json.decode(str));

String scheduleModelToJson(ScheduleModel data) => json.encode(data.toJson());

class Headerr {
  int? serverTimestamp;
  bool? result;
  int? statusCode;

  Headerr({
    this.serverTimestamp,
    this.result,
    this.statusCode,
  });

  factory Headerr.fromJson(Map<String, dynamic> json) => Headerr(
        serverTimestamp: json["serverTimestamp"],
        result: json["result"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "serverTimestamp": serverTimestamp,
        "result": result,
        "statusCode": statusCode,
      };
}

class ScheduleModel {
  Headerr? header;
  // Header? header;
  List<ScheduleListResponse>? body;

  ScheduleModel({
    this.header,
    this.body,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        header:
            json["header"] == null ? null : Headerr.fromJson(json["header"]),
        body: json["body"] == null
            ? []
            : List<ScheduleListResponse>.from(
                json["body"]!.map((x) => ScheduleListResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "body": body == null
            ? []
            : List<dynamic>.from(body!.map((x) => x.toJson())),
      };
}

class ScheduleListResponse {
  String? id;
  String? description;
  String? departure;
  String? arrival;
  String? duration;
  BoardingPoint? boardingPoint;
  int? boardingPointId;
  DropOffPoint? dropOffPoint;
  int? dropOffPointId;
  int? airCon;
  int? wc;
  int? snack;
  int? wifi;
  String? transportationType;
  int? price;
  int? priceForeigner;
  int? agencyPrice;
  int? agencyPriceForeigner;
  int? companyPrice;
  int? totalSeat;
  int? seatAvailable;
  int? status;
  int? allowPricePeriod;
  int? transportationTypeId;
  int? type;
  int? routeId;
  int? companyId;
  int? journeyId;
  int? steward;

  ScheduleListResponse({
    this.id,
    this.description,
    this.departure,
    this.arrival,
    this.duration,
    this.boardingPoint,
    this.boardingPointId,
    this.dropOffPoint,
    this.dropOffPointId,
    this.airCon,
    this.wc,
    this.snack,
    this.wifi,
    this.transportationType,
    this.price,
    this.priceForeigner,
    this.agencyPrice,
    this.agencyPriceForeigner,
    this.companyPrice,
    this.totalSeat,
    this.seatAvailable,
    this.status,
    this.allowPricePeriod,
    this.transportationTypeId,
    this.type,
    this.routeId,
    this.companyId,
    this.journeyId,
    this.steward,
  });

  factory ScheduleListResponse.fromJson(Map<String, dynamic> json) =>
      ScheduleListResponse(
        id: json["id"],
        description: json["description"],
        departure: json["departure"],
        arrival: json["arrival"],
        duration: json["duration"],
        boardingPoint: boardingPointValues.map[json["boardingPoint"]],
        boardingPointId: (json["boardingPointId"] as num?)?.toInt(),
        dropOffPoint: dropOffPointValues.map[json["dropOffPoint"]],
        dropOffPointId: (json["dropOffPointId"] as num?)?.toInt(),
        airCon: (json["airCon"] as num?)?.toInt(),
        wc: (json["wc"] as num?)?.toInt(),
        snack: (json["snack"] as num?)?.toInt(),
        wifi: (json["wifi"] as num?)?.toInt(),
        transportationType: json["transportationType"],
        price: (json["price"] as num?)?.toInt(),
        priceForeigner: (json["priceForeigner"] as num?)?.toInt(),
        agencyPrice: (json["agencyPrice"] as num?)?.toInt(),
        agencyPriceForeigner: (json["agencyPriceForeigner"] as num?)?.toInt(),
        companyPrice: (json["companyPrice"] as num?)?.toInt(),
        totalSeat: (json["totalSeat"] as num?)?.toInt(),
        seatAvailable: (json["seatAvailable"] as num?)?.toInt(),
        status: (json["status"] as num?)?.toInt(),
        allowPricePeriod: (json["allowPricePeriod"] as num?)?.toInt(),
        transportationTypeId: (json["transportationTypeId"] as num?)?.toInt(),
        type: (json["type"] as num?)?.toInt(),
        routeId: (json["routeId"] as num?)?.toInt(),
        companyId: (json["companyId"] as num?)?.toInt(),
        journeyId: (json["journeyId"] as num?)?.toInt(),
        steward: (json["steward"] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "departure": departure,
        "arrival": arrival,
        "duration": duration,
        "boardingPoint": boardingPointValues.reverse[boardingPoint],
        "boardingPointId": boardingPointId,
        "dropOffPoint": dropOffPointValues.reverse[dropOffPoint],
        "dropOffPointId": dropOffPointId,
        "airCon": airCon,
        "wc": wc,
        "snack": snack,
        "wifi": wifi,
        "transportationType": transportationType,
        "price": price,
        "priceForeigner": priceForeigner,
        "agencyPrice": agencyPrice,
        "agencyPriceForeigner": agencyPriceForeigner,
        "companyPrice": companyPrice,
        "totalSeat": totalSeat,
        "seatAvailable": seatAvailable,
        "status": status,
        "allowPricePeriod": allowPricePeriod,
        "transportationTypeId": transportationTypeId,
        "type": type,
        "routeId": routeId,
        "companyId": companyId,
        "journeyId": journeyId,
        "steward": steward,
      };

  String get formattedDeparture {
    if (departure == null) return "";
    try {
      final parts = departure!.split(":");
      if (parts.length >= 2) {
        final hour = parts[0].padLeft(2, '0');
        return "$hour:00";
      }
    } catch (_) {}
    return departure ?? "";
  }

  String get formattedarrival {
    if (departure == null) return "";
    try {
      final parts = arrival!.split(":");
      if (parts.length >= 2) {
        final hour = parts[0].padLeft(2, '0');
        return "$hour:00";
      }
    } catch (_) {}
    return departure ?? "";
  }

  String get formattedduration {
    if (departure == null) return "";
    try {
      final parts = duration!.split(":");
      if (parts.length >= 2) {
        final hour = parts[0].padLeft(2, '0');
        return "$hour:00";
      }
    } catch (_) {}
    return departure ?? "";
  }
}

enum BoardingPoint { PHNOM_PENH_CANNON_RIFLE_ROUNDABOUT_PARK }

final boardingPointValues = EnumValues({
  "Phnom Penh (Cannon Rifle Roundabout Park)":
      BoardingPoint.PHNOM_PENH_CANNON_RIFLE_ROUNDABOUT_PARK
});

enum DropOffPoint {
  SIEM_REAP_BOREY_SEANG_NAM,
  SIEM_REAP_HUY_LENG_MARKET,
  SIEM_REAP_PHSAR_SAMKI
}

final dropOffPointValues = EnumValues({
  "Siem Reap (Borey Seang Nam)": DropOffPoint.SIEM_REAP_BOREY_SEANG_NAM,
  "Siem Reap Huy Leng Market": DropOffPoint.SIEM_REAP_HUY_LENG_MARKET,
  "Siem Reap Phsar Samki": DropOffPoint.SIEM_REAP_PHSAR_SAMKI
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
