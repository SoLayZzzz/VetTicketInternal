// ignore_for_file: unnecessary_new, prefer_collection_literals

class BusListModel {
  Header? header;
  List<BusResult>? body;

  BusListModel({this.header, this.body});

  BusListModel.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['body'] != null) {
      body = <BusResult>[];
      json['body'].forEach((v) {
        body!.add(new BusResult.fromJson(v));
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

class BusResult {
  String? id;
  String? name;

  BusResult({this.id, this.name});

  BusResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Header {
  String? errorCode;
  String? errorText;
  Pagination? pagination;
  bool? result;
  int? serverTimestamp;
  int? statusCode;

  Header(
      {this.errorCode,
      this.errorText,
      this.pagination,
      this.result,
      this.serverTimestamp,
      this.statusCode});

  Header.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorText = json['errorText'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    result = json['result'];
    serverTimestamp = json['serverTimestamp'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorText'] = this.errorText;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    data['result'] = this.result;
    data['serverTimestamp'] = this.serverTimestamp;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class Pagination {
  int? page;
  int? rowsPerPage;
  int? total;

  Pagination({this.page, this.rowsPerPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    rowsPerPage = json['rowsPerPage'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['rowsPerPage'] = this.rowsPerPage;
    data['total'] = this.total;
    return data;
  }
}
