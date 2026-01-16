import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar({
  required String title,
  required String message,
  required bool isError,
}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: isError ? Colors.red.withOpacity(0.9) : Colors.green.withOpacity(0.9),
    colorText: Colors.white,
    margin: const EdgeInsets.all(10),
    borderRadius: 10,
    duration: const Duration(seconds: 3),
    icon: Icon(
      isError ? Icons.error_outline : Icons.check_circle_outline,
      color: Colors.white,
    ),
  );
}