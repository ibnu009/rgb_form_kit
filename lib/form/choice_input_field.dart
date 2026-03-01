import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../components/radio_button/bordered_radio_button.dart';
import '../model/check_box_model.dart';
import '../styles/colors.dart';
import '../styles/text_styles/poppins_text_styles.dart';
import '../styles/values.dart';
import '../utils/ui_extensions.dart';

class ChoiceInputField extends FormBuilderField<CheckBoxModel> {
  final String? title;
  final bool? canClear;
  final String? selectedValue;
  final List<CheckBoxModel>? choices;
  final bool isEnabled;
  final bool isRequired;
  final bool isAutoValidate;
  final String? validatorErrorMessage;

  ChoiceInputField({
    super.key,
    this.title,
    this.selectedValue,
    this.isEnabled = true,
    this.isRequired = false,
    this.validatorErrorMessage,
    this.choices,
    this.isAutoValidate = false,
    this.canClear = false,
    FormFieldSetter<CheckBoxModel>? onSelect,
    FormFieldValidator<CheckBoxModel>? validator,
    required super.name,
    super.onChanged,
  }) : super(
            initialValue: selectedValue == null
                ? null
                : choices?.firstWhere(
                    (element) => element.identifier == selectedValue),
            onSaved: onSelect,
            validator: validator ??
                (isRequired
                    ? (value) {
                        if (value != null) return null;
                        return validatorErrorMessage ?? 'Please select one option';
                      }
                    : null),
            autovalidateMode: isAutoValidate == true
                ? AutovalidateMode.onUserInteraction
                : null,
            builder: (FormFieldState<CheckBoxModel> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: title != null,
                    child: RichText(
                      text: TextSpan(
                        text: title,
                        style: PoppinsTextStyles.textMd.textRegular().copyWith(
                              color: isEnabled
                                  ? AppColors.black500
                                  : AppColors.black300,
                            ),
                        children: [
                          if (isRequired)
                            TextSpan(
                              text: ' *',
                              style: PoppinsTextStyles.textSm
                                  .textRegular()
                                  .copyWith(
                                    color: AppColors.brightRed,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  AppValues.spacing8.verticalSpace,
                  ...choices
                          ?.map(
                            (e) => Padding(
                              padding:
                                  EdgeInsets.only(bottom: AppValues.padding8.h),
                              child: BorderedRadioButton(
                                title: e.title,
                                groupValue: field.value?.identifier,
                                value: e.identifier,
                                onChanged: (value) {
                                  if (canClear == true &&
                                      field.value?.identifier == value) {
                                    field.didChange(null);
                                  } else {
                                    field.didChange(choices.firstWhere(
                                        (element) =>
                                            element.identifier == value));
                                  }
                                  // if (field.value?.identifier == value) {
                                  //   field.didChange(null);
                                  // } else {
                                  //   field.didChange(choices.firstWhere(
                                  //       (element) =>
                                  //           element.identifier == value));
                                  // }
                                },
                                isError: field.hasError,
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        field.errorText ?? '',
                        style: PoppinsTextStyles.textSm
                            .textRegular()
                            .copyWith(color: AppColors.alert700),
                      ),
                    ),
                ],
              );
            });
}
