import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../resources/constants/form_constants.dart';
import '../styles/colors.dart';
import '../styles/text_styles/poppins_text_styles.dart';
import '../styles/values.dart';
import '../utils/ui_extensions.dart';

class DropdownField extends StatefulWidget {
  final String name;
  final String label;
  final String? hint;
  final List<String> options;
  final bool isEnabled;
  final bool isRequired;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String?>? onChanged;

  const DropdownField({
    super.key,
    required this.name,
    required this.label,
    required this.options,
    this.hint,
    this.isEnabled = true,
    this.isRequired = false,
    this.initialValue,
    this.validator,
    this.onChanged,
  });

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  bool _isOpen = false;

  void _toggle() {
    if (!widget.isEnabled) return;
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _select(FormFieldState<String> field, String value) {
    field.didChange(value);
    widget.onChanged?.call(value);
    setState(() {
      _isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: widget.name,
      initialValue: widget.initialValue,
      enabled: widget.isEnabled,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> field) {
        final currentValue = field.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.label, style: PoppinsTextStyles.label.textMedium()),
                if (widget.isRequired)
                  Text(
                    ' *',
                    style: PoppinsTextStyles.textSm
                        .textRegular()
                        .copyWith(color: AppColors.brightRed),
                  ),
              ],
            ),
            AppValues.spacing8.verticalSpace,
            GestureDetector(
              onTap: _toggle,
              child: Container(
                padding: EdgeInsets.all(AppValues.padding16.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: field.hasError
                        ? AppColors.alert700
                        : widget.isEnabled
                            ? AppColors.black200
                            : AppColors.black300,
                  ),
                  borderRadius: BorderRadius.circular(AppValues.radius8.r),
                  color: widget.isEnabled ? AppColors.white : AppColors.black100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        (currentValue == null || currentValue.isEmpty)
                            ? (widget.hint ?? FormConstants.selectStatus.tr)
                            : currentValue,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: PoppinsTextStyles.bodyRegular.textRegular().copyWith(
                              color: (currentValue == null || currentValue.isEmpty)
                                  ? AppColors.black300
                                  : widget.isEnabled
                                      ? AppColors.black500
                                      : AppColors.black300,
                            ),
                      ),
                    ),
                    Icon(
                      _isOpen
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: AppValues.iconSize24,
                      color:
                          widget.isEnabled ? AppColors.black500 : AppColors.black300,
                    ),
                  ],
                ),
              ),
            ),
            if (_isOpen)
              Container(
                margin: EdgeInsets.only(top: AppValues.spacing8.h),
                padding: EdgeInsets.symmetric(horizontal: AppValues.padding16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.black200),
                  borderRadius: BorderRadius.circular(AppValues.radius8.r),
                ),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: widget.options.map((option) {
                    return GestureDetector(
                      onTap: () => _select(field, option),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: AppValues.spacing12.h),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.black200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option,
                                style: PoppinsTextStyles.bodySmall.textRegular(),
                              ),
                            ),
                            if (currentValue == option)
                              Icon(
                                Icons.check,
                                color: AppColors.primary500,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  field.errorText ?? '',
                  style: PoppinsTextStyles.bodySmall
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

