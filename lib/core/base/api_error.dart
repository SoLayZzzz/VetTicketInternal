// class ApiError implements Exception {
//   final String? message;
//   final int? statusCode;
//   ApiError(this.message, this.statusCode);
// }

class ApiError implements Exception {
  final String? message;
  final int? statusCode;

  ApiError(this.message, this.statusCode);

  @override
  String toString() => 'ApiError: $message (Status code: $statusCode)';
}
