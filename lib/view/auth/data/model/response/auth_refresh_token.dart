// ignore_for_file: unnecessary_new, prefer_collection_literals

// Have body request post to server // ===> Class name LoginRefreshTokenBodyRequest

class AuthRefreshTokenResponse {
  AuthRefreshTokenResult? body;

  AuthRefreshTokenResponse({this.body});

  AuthRefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null
        ? new AuthRefreshTokenResult.fromJson(json['body'])
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

class AuthRefreshTokenResult {
  String? accessToken;
  String? tokenType;
  String? refreshToken;
  int? expiresIn;
  String? scope;

  AuthRefreshTokenResult(
      {this.accessToken,
      this.tokenType,
      this.refreshToken,
      this.expiresIn,
      this.scope});

  AuthRefreshTokenResult.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    tokenType = json['tokenType'];
    refreshToken = json['refreshToken'];
    expiresIn = json['expiresIn'];
    scope = json['scope'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['tokenType'] = this.tokenType;
    data['refreshToken'] = this.refreshToken;
    data['expiresIn'] = this.expiresIn;
    data['scope'] = this.scope;
    return data;
  }
}
