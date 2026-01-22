import 'package:get/get.dart';

class CarHistoryState {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  RxList<Map<String, String>> histories = <Map<String, String>>[].obs;
}
