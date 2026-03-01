import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/text_styles/poppins_text_styles.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? dividerColor, textColor;
  final double? dividerThickness;
  final double? padding;

  const DividerWithText({
    super.key,
    required this.text,
    this.textStyle,
    this.dividerColor,
    this.dividerThickness,
    this.padding,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: dividerColor ?? AppColors.black200,
              thickness: dividerThickness ?? 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              text,
              style: textStyle ??
                  PoppinsTextStyles.bodySmall.textRegular().copyWith(
                        color: textColor ?? AppColors.black300,
                        fontStyle: FontStyle.italic,
                      ),
            ),
          ),
          Expanded(
            child: Divider(
              color: dividerColor ?? AppColors.black200,
              thickness: dividerThickness ?? 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
