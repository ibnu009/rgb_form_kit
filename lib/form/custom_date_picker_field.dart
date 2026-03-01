import 'dart:nativewrappers/_internal/vm/lib/developer.dart' as RgbFormKitLogger;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../resources/constants/form_validator_constants.dart';
import '../styles/colors.dart';
import '../styles/text_styles/poppins_text_styles.dart';
import '../utils/ui_extensions.dart';
import '../components/datepicker/custom_date_picker.dart';

class CustomDatePickerField extends FormBuilderField<String> {
  final String format;
  final bool isRequired;
  final String? errorMessage;
  final TextStyle? titleStyle;
  final bool yearMonthOnly;
  final bool prefillYearMonth;
  final bool useDefaultValue; // ← Tambah flag ini

  CustomDatePickerField({
    super.key,
    DateTime? initialDate,
    super.onSaved,
    DateTime? firstDate,
    DateTime? lastDate,
    bool isEnabled = true,
    String? title,
    this.format = 'yyyy-MM-dd',
    required super.name,
    this.isRequired = false,
    this.errorMessage,
    this.titleStyle,
    this.yearMonthOnly = false,
    this.prefillYearMonth = false,
    this.useDefaultValue = true, // ← Default true untuk backward compatibility
    super.onChanged,
  }) : super(
          initialValue: prefillYearMonth
              ? null // Untuk prefillYearMonth, form value harus null
              : _getInitialValue(initialDate, format, useDefaultValue),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            RgbFormKitLogger.log('🔍 Validator called with value: $value');

            if (isRequired && (value == null || value.isEmpty)) {
              return errorMessage ?? FormValidatorConstants.addDobFirst.tr;
            }
            return null;
          },
          builder: (FormFieldState<String> field) {
            DateTime? parsedDate;
            try {
              if (field.value != null && field.value!.isNotEmpty) {
                parsedDate = DateFormat(format).parse(field.value!);
              }
            } catch (e) {
              e.printError();
            }

            // Pass initial date hanya untuk prefill internal di CustomDatePicker
            DateTime? internalInitialDate;
            if (prefillYearMonth && initialDate != null) {
              // Mode prefillYearMonth: selalu gunakan initialDate untuk prefill visual
              internalInitialDate = initialDate;
            } else if (parsedDate != null) {
              // Mode normal: gunakan parsed value dari form
              internalInitialDate = parsedDate;
            } else if (initialDate != null && !prefillYearMonth) {
              // Mode normal dengan initialDate
              internalInitialDate = initialDate;
            } else if (useDefaultValue) {
              // Gunakan default value (sekarang) jika flag true dan tidak ada initialDate
              internalInitialDate = DateTime.now();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDatePicker(
                  initialDate: internalInitialDate,
                  firstDate: firstDate,
                  lastDate: lastDate ?? DateTime.now(),
                  isEnabled: isEnabled,
                  yearMonthOnly: yearMonthOnly,
                  hasError: field.hasError,
                  prefillYearMonth: prefillYearMonth,
                  title: title,
                  isRequired: isRequired,
                  titleStyle: titleStyle,
                  useDefaultValue:
                      useDefaultValue,
                  onDateChanged: (selectedDate) {
                    String formatted = DateFormat(format).format(selectedDate);
                    field.didChange(formatted);
                    onChanged?.call(formatted);
                  },
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      field.errorText ?? '',
                      style: PoppinsTextStyles.textSm.textRegular().copyWith(
                            color: AppColors.alert700,
                          ),
                    ),
                  ),
              ],
            );
          },
        );

  // ← Tambah helper method ini
  static String? _getInitialValue(
      DateTime? initialDate, String format, bool useDefaultValue) {
    if (initialDate != null) {
      return DateFormat(format).format(initialDate);
    } else if (useDefaultValue) {
      return DateFormat(format).format(DateTime.now());
    }
    return null;
  }
}
