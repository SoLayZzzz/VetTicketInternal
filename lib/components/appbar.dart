import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import '../utils/dimension.dart';
import '../utils/style.dart';

appBarHome(
    {required String title,
    bool center = true,
    Widget? leadingIcon,
    List<Widget>? actions,
    Color backgroundColor = AppColors.primaryColor,
    double elevation = 0,
    double font = Dimension.fontSize20}) {
  return AppBar(
    title: Text(title, style: styleAppBarHome),
    centerTitle: center,
    elevation: elevation,
    backgroundColor: backgroundColor,
    leading: leadingIcon,
    actions: actions,
  );
}

appBarDefault(
    {required String title,
    required VoidCallback onPressed,
    bool center = true,
    List<Widget>? actions,
    Color backgroundColor = AppColors.primaryColor,
    double elevation = 0}) {
  return AppBar(
    title: Text(title, style: styleAppBar),
    centerTitle: center,
    elevation: elevation,
    backgroundColor: backgroundColor,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios,
          color: AppColors.whiteColor, size: Dimension.iconSize20),
      onPressed: () {
        onPressed();
      },
    ),
    actions: actions,
  );
}
