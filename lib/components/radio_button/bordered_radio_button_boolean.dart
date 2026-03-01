import 'package:flutter/material.dart';

import '../../styles/colors.dart';
import '../../styles/text_styles/poppins_text_styles.dart';
import '../../styles/values.dart';
import '../../utils/ui_extensions.dart';

class BorderedRadioButtonBoolean extends StatelessWidget {
  final String title;
  final bool value;
  final bool? groupValue; // Allow nullable groupValue to represent no selection
  final ValueChanged<bool?>? onChanged;
  final EdgeInsets? margin;
  final bool isError;
  final bool isEnabled;
  final bool isRequired;

  const BorderedRadioButtonBoolean({super.key, 
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.margin,
    this.isRequired = false,
    this.isError = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null && isEnabled) {
          onChanged!(value); // Trigger onChanged with the value
        }
      },
      child: Container(
        margin: margin,
        padding: EdgeInsets.all(AppValues.padding16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isError
                ? AppColors.alert700
                : isEnabled
                    ? AppColors.black200
                    : AppColors.black300,
          ),
          borderRadius: BorderRadius.circular(AppValues.radius8.r),
          color: isEnabled ? null : AppColors.black100,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: PoppinsTextStyles.bodyRegular.textRegular().copyWith(
                      color: groupValue != value ? AppColors.black300: AppColors.black500,
                    ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isEnabled ? Colors.white : AppColors.black100,
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
