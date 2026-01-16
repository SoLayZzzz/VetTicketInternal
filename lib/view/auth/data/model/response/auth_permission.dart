// ignore_for_file: unnecessary_new, prefer_collection_literals

// No request body post to server
class AuthCheckPermissionResponse {
  AuthPermissionResult? body;

  AuthCheckPermissionResponse({this.body});

  AuthCheckPermissionResponse.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null
        ? new AuthPermissionResult.fromJson(json['body'])
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

class AuthPermissionResult {
  bool? status;
  String? message;
  List<AuthPermissionData>? data;

  AuthPermissionResult({this.status, this.message, this.data});

  AuthPermissionResult.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AuthPermissionData>[];
      json['data'].forEach((v) {
        data!.add(new AuthPermissionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AuthPermissionData {
  String? username;
  int? appVersion;
  int? showMarkup;
  int? showBusMenu;
  int? showBuvaSeaMenu;
  List<UserPermissions>? userPermissions;

  AuthPermissionData(
      {this.username,
      this.appVersion,
      this.showMarkup,
      this.showBusMenu,
      this.showBuvaSeaMenu,
      this.userPermissions});

  AuthPermissionData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    appVersion = json['appVersion'];
    showMarkup = json['showMarkup'];
    showBusMenu = json['showBusMenu'];
    showBuvaSeaMenu = json['showBuvaSeaMenu'];
    if (json['userPermissions'] != null) {
      userPermissions = <UserPermissions>[];
      json['userPermissions'].forEach((v) {
        userPermissions!.add(new UserPermissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['appVersion'] = this.appVersion;
    data['showMarkup'] = this.showMarkup;
    data['showBusMenu'] = this.showBusMenu;
    data['showBuvaSeaMenu'] = this.showBuvaSeaMenu;
    if (this.userPermissions != null) {
      data['userPermissions'] =
          this.userPermissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserPermissions {
  int? module;
  int? access;

  UserPermissions({this.module, this.access});

  UserPermissions.fromJson(Map<String, dynamic> json) {
    module = json['module'];
    access = json['access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module'] = this.module;
    data['access'] = this.access;
    return data;
  }
}
