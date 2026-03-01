import 'package:flutter/material.dart';

import '../colors.dart';

class FormInputBorders {
  static OutlineInputBorder get normalBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppColors.black200,
          width: 1.5,
        ),
      );

  static OutlineInputBorder get focusedBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppColors.black200,
          width: 1.5,
        ),
      );

  static OutlineInputBorder get errorBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppColors.alert700,
          width: 1.5,
        ),
      );

  static OutlineInputBorder get disabledBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppColors.black300,
          width: 1.5,
        ),
      );
}
