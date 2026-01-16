// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

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

class BoardingModel {
  Header? header;
  List<BoardingResponse>? body;

  BoardingModel({this.header, this.body});

  BoardingModel.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['body'] != null) {
      body = <BoardingResponse>[];
      json['body'].forEach((v) {
        body!.add(new BoardingResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header!.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BoardingResponse {
  int? id;
  String? name;
  String? address;
  String? longs;
  String? lats;

  BoardingResponse({this.id, this.name, this.address, this.longs, this.lats});

  BoardingResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    longs = json['longs'];
    lats = json['lats'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['longs'] = this.longs;
    data['lats'] = this.lats;
    return data;
  }
}
