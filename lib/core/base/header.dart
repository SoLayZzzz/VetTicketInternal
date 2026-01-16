import 'package:json_annotation/json_annotation.dart';

part 'header.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Header<T> {
  int? serverTimestamp;
  bool? result;
  int? statusCode;
  T? body;

  Header({
    required this.serverTimestamp,
    required this.result,
    required this.statusCode,
    required this.body,
  });

  factory Header.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final headerJson = json['header'] as Map<String, dynamic>?;

    return Header<T>(
      serverTimestamp: (headerJson?['serverTimestamp'] as num?)?.toInt(),
      result: headerJson?['result'] as bool?,
      statusCode: (headerJson?['statusCode'] as num?)?.toInt(),
      body: _$nullableGenericFromJson(json['body'], fromJsonT),
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$HeaderToJson(this, toJsonT);

  @override
  String toString() {
    return 'Header(statusCode: $statusCode, result: $result, body: $body)';
  }
}
