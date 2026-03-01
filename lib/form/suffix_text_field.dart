import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../resources/constants/screening_constants.dart';
import '../styles/colors.dart';
import '../styles/text_styles/poppins_text_styles.dart';
import '../styles/values.dart';
import '../utils/ui_extensions.dart';
import 'text_divider.dart';

class SuffixTextField extends StatelessWidget {
  final String name;
  final String title;
  final String suffixText;
  final TextInputType inputType;
  final bool isRequired;
  final GlobalKey<FormBuilderState>? formKey;
  final String? hintText;
  final FormFieldValidator<String?>? validator;
  final Function(String?)? onSaved;
  final String? initialValue;
  final Function(String?)? onChanged;
  final bool isEnable;
  final bool? isAutoValidate;
  final List<TextInputFormatter>? inputFormatters;
  final bool showOptionalText;
  final TextStyle? titleTextStyle;

  const SuffixTextField({
    super.key,
    required this.name,
    required this.title,
    required this.suffixText,
    this.isRequired = false,
    this.inputType = TextInputType.text,
    this.formKey,
    this.showOptionalText = false,
    this.hintText,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.initialValue,
    this.inputFormatters,
    this.isEnable = true,
    this.isAutoValidate,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: (titleTextStyle ?? PoppinsTextStyles.label.textMedium())
                .copyWith(
              color: isEnable ? AppColors.black500 : AppColors.black300,
            ),
            children: [
              TextSpan(
                text: isRequired ? ' *' : '',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        showOptionalText
            ? Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppValues.spacing12.h,
                ),
                child: DividerWithText(
                  text: ScreeningConstants.skipIfDontKnow.tr,
                ),
              )
            : AppValues.spacing8.verticalSpace,
        Container(
          constraints: BoxConstraints(minHeight: 56.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.radius12.r),
            color: isEnable ? Colors.transparent : AppColors.black100,
          ),
          child: FormBuilderTextField(
            name: name,
            readOnly: !isEnable,
            style: PoppinsTextStyles.bodyRegular.textRegular().copyWith(
                  color: isEnable ? AppColors.black500 : AppColors.black300,
                ),
            validator: validator,
            onSaved: onSaved,
            inputFormatters: inputFormatters,
            initialValue: initialValue,
            onChanged: onChanged,
            autovalidateMode: isAutoValidate == null
                ? null
                : AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: hintText ?? "",
              hintStyle: PoppinsTextStyles.bodyRegular.textRegular().copyWith(
                    color: AppColors.black300,
                  ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radius12.r),
                borderSide: BorderSide(
                  color: AppColors.black200,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radius12.r),
                borderSide: BorderSide(
                  color: AppColors.black200,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radius12.r),
                borderSide: BorderSide(
                  color: AppColors.alert700,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radius12.r),
                borderSide: BorderSide(
                  color: AppColors.black200,
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppValues.padding16.w,
                vertical: AppValues.padding12.h,
              ),
              suffixIcon: Container(
                padding: EdgeInsets.all(
                  AppValues.padding16.w,
                ),
                decoration: BoxDecoration(
                  color: AppColors.black200,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      AppValues.radius8.r,
                    ),
                    bottomRight: Radius.circular(
                      AppValues.radius8.r,
                    ),
                  ),
                ),
                child: Text(
                  suffixText,
                  style: PoppinsTextStyles.bodyRegular.textRegular().copyWith(
                        color: AppColors.black300,
                      ),
                ),
              ),
              errorMaxLines: 1,
              errorStyle: PoppinsTextStyles.textSm
                  .textRegular()
                  .copyWith(color: AppColors.alert700),
            ),
            keyboardType: inputType,
          ),
        ),
        AppValues.spacing8.verticalSpace,
      ],
    );
  }
}
