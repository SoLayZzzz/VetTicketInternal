// ignore_for_file: file_names, unnecessary_new, prefer_collection_literals

// No request body post to server

class AuthCheckTokenResponse {
  String? body;

  AuthCheckTokenResponse({this.body});

  factory AuthCheckTokenResponse.fromJson(dynamic json) {
    if (json is String) {
      return AuthCheckTokenResponse(body: json);
    } else if (json is Map<String, dynamic>) {
      return AuthCheckTokenResponse(body: json['body']?.toString());
    } else {
      return AuthCheckTokenResponse(body: null);
    }
  }

  Map<String, dynamic> toJson() {
    return {'body': body};
  }
}
