import 'dart:io';

abstract class BaseApiService {
  Future<dynamic> getApi(String url, Map<String, String> jsonBody);

  Future<dynamic> postApi(String url, Map<String, String> jsonBody);

  Future<dynamic> uploadImageService(String url, String token, File file);
}
