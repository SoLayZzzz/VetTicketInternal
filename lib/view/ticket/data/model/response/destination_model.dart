import 'package:vet_internal_ticket/core/base/header.dart';

class Headerrr {
  int? serverTimestamp;
  bool? result;
  int? statusCode;

  Headerrr({
    this.serverTimestamp,
    this.result,
    this.statusCode,
  });

  factory Headerrr.fromJson(Map<String, dynamic> json) => Headerrr(
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

class DestinationFromModel {
  Headerrr? header;
  List<DestinationResponse>? body;
  DestinationFromModel({
    this.header,
    this.body,
  });

  factory DestinationFromModel.fromJson(Map<String, dynamic> json) =>
      DestinationFromModel(
        header:
            json["header"] == null ? null : Headerrr.fromJson(json["header"]),
        body: json["body"] == null
            ? []
            : List<DestinationResponse>.from(
                json["body"]!.map((x) => DestinationResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "body": body == null
            ? []
            : List<dynamic>.from(body!.map((x) => x.toJson())),
      };
}

class DestinationResponse {
  String? id;
  String? name;

  DestinationResponse({
    this.id,
    this.name,
  });

  factory DestinationResponse.fromJson(Map<String, dynamic> json) =>
      DestinationResponse(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
