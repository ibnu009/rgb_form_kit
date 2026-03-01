// Custom widget for RadioTile
import 'package:flutter/material.dart';

import '../../styles/colors.dart';
import '../../styles/text_styles/poppins_text_styles.dart';
import '../../styles/values.dart';
import '../../utils/ui_extensions.dart';

class BorderedRadioButton extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String?>? onChanged;
  final EdgeInsets? margin;
  final bool isError;
  final bool isEnable;
  final bool isRequired;
  final double? fontSize;

  const BorderedRadioButton({super.key, 
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.margin,
    this.isRequired = false,
    this.isError = false,
    this.isEnable = true,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isEnable) return;
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      child: Container(
        margin: margin,
        padding: EdgeInsets.all(AppValues.padding16.w),
        decoration: BoxDecoration(
          border: Border.all(
            width: isError ? 2 : 1,
            color: isError
                ? AppColors.alert700
                : isEnable
                    ? AppColors.black200
                    : AppColors.black300,
          ),
          borderRadius: BorderRadius.circular(AppValues.radius8.r),
          color: isEnable ? null : AppColors.black100,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: PoppinsTextStyles.bodyRegular.textRegular().copyWith(
                      color: groupValue != value
                          ? AppColors.black300
                          : AppColors.black500,
                      fontSize: fontSize,
                    ),
              ),
            ),
            AppValues.padding16.horizontalSpace,
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isEnable ? Colors.white : AppColors.black100,
                  border: Border.all(
                    width: 3,
                    color: AppColors.black200,
                  )),
              child: Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: groupValue != value
                      ? null
                      : BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary500,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
