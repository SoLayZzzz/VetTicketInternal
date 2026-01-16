// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import '../app_url/base_url.dart';
// import '../../data/app_exception.dart';
// import 'base_api_services.dart';

// class NetworkApiService extends BaseApiService {
//   dynamic responseJson;

//   @override
//   Future<dynamic> uploadImageService(
//       String url, String token, File file) async {
//     try {
//       var request = http.MultipartRequest('POST', Uri.parse(url));
//       request.headers['Content-Type'] = 'multipart/form-data';
//       request.fields['token'] = token;
//       request.files.add(await http.MultipartFile.fromPath('photo', file.path));

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//       } else {}
//     } catch (e) {
//       throw Exception('Error uploading image: $e');
//     }
//   }

//   @override
//   Future<dynamic> getApi(String url, dynamic jsonBody,
//       {Map<String, String>? headers}) async {
//     try {
//       final response = await http.get(
//         Uri.parse(BaseUrl.baseUrl + url),
//         headers: headers,
//       );
//       responseJson = returnResponse(response);
//     } on SocketException {
//       throw FetchDataException('No Internet Connection');
//     }
//     return responseJson;
//   }

//   @override
//   Future<dynamic> postApi(String url, dynamic jsonBody,
//       {Map<String, String>? headers}) async {
//     try {
//       final response = await http.post(
//         Uri.parse(BaseUrl.baseUrl + url),
//         body: jsonBody,
//         headers: headers,
//       );
//       responseJson = returnResponse(response);
//     } on SocketException {
//       throw FetchDataException('No Internet Connection');
//     }
//     return responseJson;
//   }

//   dynamic returnResponse(http.Response response) {
//     switch (response.statusCode) {
//       case 200:
//         return jsonDecode(response.body);
//       case 400:
//         throw BadRequestException(response.body.toString());
//       case 401:
//       case 403:
//         throw UnauthorisedException(response.body.toString());
//       case 404:
//         throw UnauthorisedException(response.body.toString());
//       case 500:
//         throw ServerException(response.body.toString());
//       default:
//         throw FetchDataException(
//             'Error occurred while communication with server with status code : ${response.statusCode}');
//     }
//   }
// }
