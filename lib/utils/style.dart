import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimension.dart';

/// style app bar home
const TextStyle styleNormal14White = TextStyle(
    color: AppColors.whiteColor, fontSize: Dimension.fontSize14, fontWeight: FontWeight.w400);


/// font size 14
const TextStyle styleNormal14 = TextStyle(
  fontSize: Dimension.fontSize14,
  fontWeight: FontWeight.w400,
  color: AppColors.textColor,
);

const TextStyle styleBold14 = TextStyle(
  fontSize: Dimension.fontSize14,
  fontWeight: FontWeight.w600,
  color: AppColors.textColor,
);

/// font size 16
const TextStyle styleNormal16 = TextStyle(
  fontSize: Dimension.fontSize16,
  fontWeight: FontWeight.w400,
  color: AppColors.textColor,
);

const TextStyle styleBold16 = TextStyle(
  fontSize: Dimension.fontSize16,
  fontWeight: FontWeight.w600,
  color: AppColors.textColor,
);

/// style app bar
const TextStyle styleAppBar = TextStyle(
    color: AppColors.whiteColor, fontSize: Dimension.fontSize18, fontWeight: FontWeight.w600);

/// style app bar home
const TextStyle styleAppBarHome = TextStyle(
    color: AppColors.whiteColor, fontSize: Dimension.fontSize20, fontWeight: FontWeight.w600);


///text field
OutlineInputBorder outlineInputBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.borderColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );
}

InputDecoration inputText(hint, icon) {
  return InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    prefixIcon: icon,
    hintText: hint,
    enabledBorder: outlineInputBorder(),
    border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5))),
  );
}
