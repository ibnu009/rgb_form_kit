import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../resources/constants/action_constants.dart';
import '../resources/constants/screening_constants.dart';
import '../styles/colors.dart';
import '../styles/text_styles/poppins_text_styles.dart';
import '../styles/values.dart';
import '../utils/ui_extensions.dart';
import '../components/radio_button/bordered_radio_button_boolean.dart';

class YesAndNoField extends FormBuilderField<bool> {
  final String? title;
  final String? yesText, noText, description;
  final Widget? titleWidget;
  final bool? selectedValue;
  final bool isEnabled, isRequired;
  final String? validatorErrorMessage;
  final List<Widget>? childrenOnYes, childrenOnNo;
  final String? Function(bool?)? customValidator;

  YesAndNoField({
    super.key,
    this.title,
    this.titleWidget,
    this.selectedValue,
    this.isEnabled = true,
    this.isRequired = true,
    this.validatorErrorMessage,
    this.description,
    this.yesText,
    this.noText,
    this.childrenOnYes,
    this.childrenOnNo,
    this.customValidator,
    FormFieldSetter<bool>? onSelect,
    required super.name,
    super.onChanged,
  }) : super(
          initialValue: selectedValue,
          onSaved: onSelect,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _buildDefaultValidator(
            isRequired: isRequired,
            validatorErrorMessage: validatorErrorMessage,
            customValidator: customValidator,
          ),
          builder: (FormFieldState<bool> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget ??
                    Visibility(
                      visible: title != null && titleWidget == null,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: AppValues.padding8.h,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: title,
                            style:
                                PoppinsTextStyles.textMd.textRegular().copyWith(
                                      color: isEnabled
                                          ? AppColors.black500
                                          : AppColors.black300,
                                    ),
                            children: [
                              if (isRequired == true)
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
                    ),
                Row(
                  children: [
                    Expanded(
                      child: BorderedRadioButtonBoolean(
                        title: yesText ?? ActionConstants.yes.tr,
                        groupValue: field.value,
                        value: true,
                        isEnabled: isEnabled,
                        onChanged: (value) {
                          field.didChange(value);
                        },
                        isError: field.hasError,
                      ),
                    ),
                    const SizedBox(width: 8), // Spacing between radio buttons
                    Expanded(
                      child: BorderedRadioButtonBoolean(
                        title: noText ?? ActionConstants.no.tr,
                        groupValue: field.value,
                        value: false,
                        isEnabled: isEnabled,
                        onChanged: (value) {
                          field.didChange(value);
                        },
                        isError: field.hasError,
                      ),
                    ),
                  ],
                ),
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        description,
                        textAlign: TextAlign.end,
                        style: PoppinsTextStyles.bodySmall.textRegular(),
                      ),
                    ),
                  ),
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
                if (field.value == true &&
                    childrenOnYes != null &&
                    isEnabled) ...[
                  ...childrenOnYes,
                ],
                if (field.value == false &&
                    childrenOnNo != null &&
                    isEnabled) ...[
                  ...childrenOnNo,
                ],
              ],
            );
          },
        );

  static String? Function(bool?)? _buildDefaultValidator({
    required bool isRequired,
    String? validatorErrorMessage,
    String? Function(bool?)? customValidator,
  }) {
    if (!isRequired) return null;
    return customValidator ??
        FormBuilderValidators.required(
          errorText: validatorErrorMessage ??
              ScreeningConstants.pleaseFillTheForm.tr,
        );
  }
}
