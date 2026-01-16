import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Utils {
  static void flushBarErrorMessage(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(10),
        borderRadius: 8.0,
        icon: const Icon(Icons.copy, color: Colors.white),
      ),
    );
  }

  static void snackBar(String message) {
    Get.snackbar(
      '',
      message,
      backgroundColor: Colors.blue,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void snackbarTopSuccess(String message ){
    AnimatedSnackBar.material(
      message,
      duration: const Duration(seconds: 2),
      type: AnimatedSnackBarType.success,
    ).show(Get.context!);
  }
  static void snackbarTopError(String message ){
    AnimatedSnackBar.material(
      message,
      duration: const Duration(seconds: 2),
      type: AnimatedSnackBarType.error,
    ).show(Get.context!);
  }
}
