import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../model/check_box_model.dart';
import '../styles/colors.dart';
import '../styles/text_styles/poppins_text_styles.dart';
import '../styles/values.dart';
import '../utils/ui_extensions.dart';

class CheckBoxField extends StatelessWidget {
  final CheckBoxModel item;
  final Color? textColor;
  final bool isBoldTitle;
  final Function(bool?)? onChanged;
  final bool isLockedAfterChecked;
  final bool isRequired;
  final String? validatorErrorMessage;
  final bool? isEnabled;
  final String? debugIdentifier;
  final FormFieldValidator<bool?>? validator;

  const CheckBoxField({
    super.key,
    required this.item,
    this.isBoldTitle = false,
    this.textColor,
    this.onChanged,
    this.isLockedAfterChecked = false,
    this.isRequired = false,
    this.validatorErrorMessage,
    this.isEnabled = true,
    this.debugIdentifier = '',
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<bool>(
      name: item.identifier,
      initialValue: item.isSelected,
      validator: validator ??
          (isRequired
              ? (value) {
                  if (value == true) return null;
                  return validatorErrorMessage ?? 'Please check this option';
                }
              : null),
      onChanged: (bool? newValue) {
        if (newValue != null) {
          onChanged?.call(newValue);
        }
      },
      builder: (FormFieldState<bool> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: AppValues.spacing8.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppValues.radius8.r),
                  border: Border.all(
                    width: 1,
                    color: field.hasError
                        ? AppColors.alert700
                        : (isEnabled == true)
                            ? AppColors.black200
                            : AppColors.black300,
                  ),
                  color: (isEnabled == true) ? Colors.white : AppColors.black100),
              child: CheckboxListTile(
                value: field.value ?? false,
                enabled: isEnabled,
                controlAffinity: ListTileControlAffinity.trailing,
                isError: field.hasError,
                onChanged: (bool? value) {
                  if (isLockedAfterChecked &&
                      field.value == true &&
                      value == false) {
                    return;
                  }
                  field.didChange(value);
                  if (onChanged != null) {
                    onChanged!(value);
                  }
                },
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppValues.padding16.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.radius8.r),
                  side: BorderSide(color: AppColors.black200),
                ),
                checkColor: AppColors.primary500,
                activeColor: const Color(0xff86D6CD),
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.radius4.r),
                  side: BorderSide(
                    color: AppColors.primary500,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                title: Text(
                  item.title,
                  style: _titleStyle.copyWith(
                    color: field.value == true
                        ? AppColors.black500
                        : (textColor ?? AppColors.black300),
                  ),
                ),
                subtitle: item.subTitle != null
                    ? Text(
                        item.subTitle!,
                        style:
                            PoppinsTextStyles.bodyRegular.textRegular().copyWith(
                                  color: field.value == true
                                      ? AppColors.black500
                                      : (textColor ?? AppColors.black300),
                                ),
                      )
                    : null,
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  field.errorText ?? '',
                  style: PoppinsTextStyles.textSm
                      .textRegular()
                      .copyWith(color: AppColors.alert700),
                ),
              ),
          ],
        );
      },
    );
  }

  TextStyle get _titleStyle {
    return item.subTitle != null
        ? PoppinsTextStyles.textMd.textSemiBold()
        : isBoldTitle
            ? PoppinsTextStyles.textMd.textSemiBold()
            : PoppinsTextStyles.textMd.textRegular();
  }
}
