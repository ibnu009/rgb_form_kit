import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../styles/colors.dart';
import '../styles/form/form_input_borders.dart';
import '../styles/text_styles/poppins_text_styles.dart';
import '../styles/values.dart';
import '../utils/ui_extensions.dart';

Future<String?> openDatePicker(
  BuildContext context, {
  String? initialValue,
  DateTime? lastDate,
}) async {
  DateTime initialDate = DateTime.now();
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialValue != null
        ? DateFormat("dd/MM/yyyy").parse(initialValue)
        : initialDate,
    firstDate: DateTime(1920),
    lastDate: lastDate ?? DateTime(2101),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary500,
          ),
        ),
        child: child!,
      );
    },
  );

  if (pickedDate != null) {
    return DateFormat("dd/MM/yyyy").format(pickedDate);
  }
  return null;
}

class DatePickerField extends FormBuilderField<String> {
  final String? title;
  final String? hintText;
  final String? value;
  final DateTime? lastDate;
  final bool isEnabled;
  final bool? isRequired;
  final List<Widget>? childrenOnDateSelected;
  final Function(String?)? onDateSelected;

  DatePickerField({
    super.key,
    this.title,
    this.hintText,
    this.value,
    this.isEnabled = true,
    this.childrenOnDateSelected,
    this.onDateSelected,
    this.lastDate,
    this.isRequired,
    super.onSaved,
    required super.name,
    super.onChanged,
    super.validator,
    super.autovalidateMode,
  }) : super(
          initialValue: value,
          builder: (FormFieldState<String> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: title != null,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        text: title,
                        style: PoppinsTextStyles.textMd.textRegular().copyWith(
                              color: isEnabled
                                  ? AppColors.black500
                                  : AppColors.black300,
                            ),
                        children: [
                          if (isRequired ?? false)
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
                GestureDetector(
                  onTap: isEnabled
                      ? () async {
                          String? selectedDate = await openDatePicker(
                            field.context,
                            lastDate: lastDate,
                          );
                          if (selectedDate != null) {
                            field.didChange(selectedDate);
                            if (onDateSelected != null) {
                              onDateSelected(selectedDate);
                            }
                          }
                        }
                      : null,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: field.value,
                        ),
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: hintText ?? 'Select Date',
                            hintStyle: PoppinsTextStyles.textMd
                                .textRegular()
                                .copyWith(color: AppColors.black300),
                            border: FormInputBorders.normalBorder,
                            enabledBorder: FormInputBorders.normalBorder,
                            focusedBorder: FormInputBorders.focusedBorder,
                            errorBorder: FormInputBorders.errorBorder,
                            focusedErrorBorder: FormInputBorders.errorBorder,
                            disabledBorder: FormInputBorders.disabledBorder,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppValues.padding16.w,
                              vertical: 16,
                            ),
                            errorText: field.hasError ? field.errorText : null,
                            errorStyle: PoppinsTextStyles.textSm
                                .textRegular()
                                .copyWith(color: AppColors.alert700)),
                      ),
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
              ],
            );
          },
        );
}
