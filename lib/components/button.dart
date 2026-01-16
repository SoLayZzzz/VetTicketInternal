import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimension.dart';

SizedBox buttonElevated(String title, Function() onClick) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimension.border6),
        ),
        padding: const EdgeInsets.symmetric(vertical: Dimension.padding20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.whiteColor,
          fontSize: Dimension.fontSize16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}

SizedBox buttonCupertino(String title, Function() onClick) {
  return SizedBox(
    width: double.infinity,
    child: CupertinoButton(
      onPressed: onClick,
      color: AppColors.primaryColor, // Button background color
      borderRadius: BorderRadius.circular(Dimension.border6),
      padding: const EdgeInsets.symmetric(vertical: Dimension.padding20),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.whiteColor,
          fontSize: Dimension.fontSize16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}
