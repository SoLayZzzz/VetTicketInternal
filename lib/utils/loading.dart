import 'package:flutter/material.dart';

import 'colors.dart';

class Loading {
  void loadingShow(context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.7),
      context: context,
      builder: (context) {
        return const Center(
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(
              value: null,
              color: AppColors.primaryColor,
              strokeWidth: 5.0,
            ),
          ),
        );
      },
    );
  }

  void loadingClose(context) {
    Navigator.pop(context);
  }
}
