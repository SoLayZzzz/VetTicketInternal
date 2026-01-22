import 'dart:convert';

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final v = value.trim();
    if (v.isEmpty) return null;
    return int.tryParse(v) ?? double.tryParse(v)?.toInt();
  }
  return null;
}

num? _asNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) {
    final v = value.trim();
    if (v.isEmpty) return null;
    return num.tryParse(v);
  }
  return null;
}

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
  String? boardingPoint;
  int? boardingPointId;
  String? dropOffPoint;
  int? dropOffPointId;
  int? airCon;
  int? wc;
  int? snack;
  int? wifi;
  String? transportationType;
  num? price;
  num? priceForeigner;
  num? agencyPrice;
  num? agencyPriceForeigner;
  num? companyPrice;
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
  String? transportationPhoto;
  String? note;
  List<SlidePhoto>? slidePhoto;
  List<Amenity>? amenities;
  String? transportRouteDisplay;
  String? nationRoad;
  int? scheduleType;
  List<SchedulePoint>? boardingPointList;
  List<SchedulePoint>? dropOffPointList;
  int? vehicleType;

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
    this.transportationPhoto,
    this.note,
    this.slidePhoto,
    this.amenities,
    this.transportRouteDisplay,
    this.nationRoad,
    this.scheduleType,
    this.boardingPointList,
    this.dropOffPointList,
    this.vehicleType,
  });

  factory ScheduleListResponse.fromJson(Map<String, dynamic> json) =>
      ScheduleListResponse(
        id: json["id"],
        description: json["description"],
        departure: json["departure"],
        arrival: json["arrival"],
        duration: json["duration"],
        boardingPoint: json["boardingPoint"],
        boardingPointId: _asInt(json["boardingPointId"]),
        dropOffPoint: json["dropOffPoint"],
        dropOffPointId: _asInt(json["dropOffPointId"]),
        airCon: _asInt(json["airCon"]),
        wc: _asInt(json["wc"]),
        snack: _asInt(json["snack"]),
        wifi: _asInt(json["wifi"]),
        transportationType: json["transportationType"],
        price: _asNum(json["price"]),
        priceForeigner: _asNum(json["priceForeigner"]),
        agencyPrice: _asNum(json["agencyPrice"]),
        agencyPriceForeigner: _asNum(json["agencyPriceForeigner"]),
        companyPrice: _asNum(json["companyPrice"]),
        totalSeat: _asInt(json["totalSeat"]),
        seatAvailable: _asInt(json["seatAvailable"]),
        status: _asInt(json["status"]),
        allowPricePeriod: _asInt(json["allowPricePeriod"]),
        transportationTypeId: _asInt(json["transportationTypeId"]),
        type: _asInt(json["type"]),
        routeId: _asInt(json["routeId"]),
        companyId: _asInt(json["companyId"]),
        journeyId: _asInt(json["journeyId"]),
        steward: _asInt(json["steward"]),
        transportationPhoto: json["transportationPhoto"],
        note: json["note"],
        slidePhoto: json["slidePhoto"] == null
            ? []
            : List<SlidePhoto>.from(
                json["slidePhoto"]!.map((x) => SlidePhoto.fromJson(x))),
        amenities: json["amenities"] == null
            ? []
            : List<Amenity>.from(
                json["amenities"]!.map((x) => Amenity.fromJson(x))),
        transportRouteDisplay: json["transportRouteDisplay"],
        nationRoad: json["nationRoad"],
        scheduleType: _asInt(json["scheduleType"]),
        boardingPointList: json["boardingPointList"] == null
            ? []
            : List<SchedulePoint>.from(json["boardingPointList"]!
                .map((x) => SchedulePoint.fromJson(x))),
        dropOffPointList: json["dropOffPointList"] == null
            ? []
            : List<SchedulePoint>.from(json["dropOffPointList"]!
                .map((x) => SchedulePoint.fromJson(x))),
        vehicleType: _asInt(json["vehicleType"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "departure": departure,
        "arrival": arrival,
        "duration": duration,
        "boardingPoint": boardingPoint,
        "boardingPointId": boardingPointId,
        "dropOffPoint": dropOffPoint,
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
        "transportationPhoto": transportationPhoto,
        "note": note,
        "slidePhoto":
            List<dynamic>.from((slidePhoto ?? []).map((x) => x.toJson())),
        "amenities":
            List<dynamic>.from((amenities ?? []).map((x) => x.toJson())),
        "transportRouteDisplay": transportRouteDisplay,
        "nationRoad": nationRoad,
        "scheduleType": scheduleType,
        "boardingPointList": List<dynamic>.from(
            (boardingPointList ?? []).map((x) => x.toJson())),
        "dropOffPointList":
            List<dynamic>.from((dropOffPointList ?? []).map((x) => x.toJson())),
        "vehicleType": vehicleType,
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

class SlidePhoto {
  String? photo;

  SlidePhoto({this.photo});

  factory SlidePhoto.fromJson(Map<String, dynamic> json) =>
      SlidePhoto(photo: json["photo"]);

  Map<String, dynamic> toJson() => {
        "photo": photo,
      };
}

class Amenity {
  String? icon;
  String? name;

  Amenity({this.icon, this.name});

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
        icon: json["icon"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "name": name,
      };
}

class SchedulePoint {
  String? id;
  String? name;
  String? address;
  String? longs;
  String? lats;

  SchedulePoint({this.id, this.name, this.address, this.longs, this.lats});

  factory SchedulePoint.fromJson(Map<String, dynamic> json) => SchedulePoint(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        longs: json["longs"],
        lats: json["lats"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "longs": longs,
        "lats": lats,
      };
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
