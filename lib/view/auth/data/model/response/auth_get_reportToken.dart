// ignore_for_file: file_names, unnecessary_new, prefer_collection_literals

class AuthGetReportTokenResponse {
  AuthGetReportTokenResult? body;

  AuthGetReportTokenResponse({this.body});

  AuthGetReportTokenResponse.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null
        ? new AuthGetReportTokenResult.fromJson(json['body'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class AuthGetReportTokenResult {
  bool? status;
  String? message;

  AuthGetReportTokenResult({this.status, this.message});

  AuthGetReportTokenResult.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
