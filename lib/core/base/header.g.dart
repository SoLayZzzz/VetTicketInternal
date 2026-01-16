// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Header<T> _$HeaderFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Header<T>(
      serverTimestamp: (json['serverTimestamp'] as num?)?.toInt(),
      result: json['result'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      body: _$nullableGenericFromJson(json['body'], fromJsonT),
    );

Map<String, dynamic> _$HeaderToJson<T>(
  Header<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'serverTimestamp': instance.serverTimestamp,
      'result': instance.result,
      'statusCode': instance.statusCode,
      'body': _$nullableGenericToJson(instance.body, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
