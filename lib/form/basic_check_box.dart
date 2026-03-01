import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../model/check_box_model.dart';
import '../styles/colors.dart';
import '../styles/text_styles/poppins_text_styles.dart';

class BasicCheckBox extends StatelessWidget {
  final CheckBoxModel item;
  final Color? textColor;
  final Function(String?)? onChanged;
  final bool isLockedAfterChecked;
  final bool? isEnabled;
  final bool isRequired;
  final String? validatorErrorMessage;
  final FormFieldValidator<bool?>? validator;

  const BasicCheckBox({
    super.key,
    required this.item,
    this.textColor,
    this.onChanged,
    this.isLockedAfterChecked = true,
    this.isEnabled,
    this.isRequired = false,
    this.validatorErrorMessage,
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
          onChanged?.call(item.identifier);
        }
      },
      builder: (FormFieldState<bool> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: Checkbox(
                    value: field.value ?? false,
                    onChanged: (bool? value) {
                      if (isLockedAfterChecked &&
                          field.value == true &&
                          value == false) {
                        return;
                      }
                      field.didChange(value);
                      if (onChanged != null) {
                        onChanged?.call(item.identifier);
                      }
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: AppColors.primary500,
                    side: BorderSide(
                      color: AppColors.black200,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    checkColor: AppColors.primary500,
                    fillColor: WidgetStateProperty.all(AppColors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.title,
                    style: PoppinsTextStyles.textMd
                        .textRegular()
                        .copyWith(color: textColor ?? AppColors.black300),
                  ),
                ),
              ],
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
}
