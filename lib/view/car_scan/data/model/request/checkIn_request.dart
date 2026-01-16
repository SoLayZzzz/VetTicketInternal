class CheckinBodyRequest {
  final String busId;
  final String code;
  final String scanType;

  CheckinBodyRequest(
      {required this.busId, required this.code, required this.scanType});

  Map<String, String> toMap() {
    return {'busId': busId, 'code': code, 'scanType': scanType};
  }
}
