// ignore_for_file: unnecessary_new, prefer_collection_literals

class LogoutModel {
  int? serverTimestamp;
  bool? result;
  int? statusCode;

  LogoutModel({this.serverTimestamp, this.result, this.statusCode});

  LogoutModel.fromJson(Map<String, dynamic> json) {
    serverTimestamp = json['serverTimestamp'];
    result = json['result'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['serverTimestamp'] = serverTimestamp;
    data['result'] = result;
    data['statusCode'] = statusCode;
    return data;
  }
}

class LogoutResponse {
  LogoutModel? header;
  LogoutResult? body;

  LogoutResponse({this.header, this.body});

  LogoutResponse.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? LogoutModel.fromJson(json['header']) : null;
    body = json['body'] != null ? LogoutResult.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (header != null) {
      data['header'] = header!.toJson();
    }
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class LogoutResult {
  bool? status;
  String? message;

  LogoutResult({this.status, this.message});

  LogoutResult.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
