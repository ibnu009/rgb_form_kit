import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../model/dropdown_selection_model.dart';
import '../styles/colors.dart';
import '../styles/text_styles/poppins_text_styles.dart';
import '../styles/values.dart';
import '../utils/list_extension.dart';
import '../utils/ui_extensions.dart';

class DropdownSelectionWidget extends StatefulWidget {
  final String title;
  final String placeholder;
  final bool isEnabled;
  final String? selectedValue;
  final List<DropdownSelectionModel> options;
  final ValueChanged<DropdownSelectionModel> onSelect;
  final String Function(DropdownSelectionModel) displayText;
  final bool isError;
  final String name;
  final FontWeight? titleWeight;
  final bool? isShowMessageError;
  final bool? isRequired;
  final FormFieldValidator<DropdownSelectionModel>? validator;

  const DropdownSelectionWidget({super.key,
    required this.title,
    required this.placeholder,
    required this.selectedValue,
    required this.options,
    required this.onSelect,
    required this.displayText,
    this.isError = false,
    required this.name,
    this.validator,
    this.titleWeight = FontWeight.w400,
    this.isEnabled = true,
    this.isShowMessageError = true,
    this.isRequired,
  });

  @override
  State<DropdownSelectionWidget> createState() =>
      _DropdownSelectionWidgetState();
}

class _DropdownSelectionWidgetState extends State<DropdownSelectionWidget> {
  DropdownSelectionModel? selectedValue;
  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.options.firstWhereOrNull(
      (item) => item.identifier == (widget.selectedValue ?? ''),
    );
  }

  void toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  void selectOption(DropdownSelectionModel option) {
    setState(() {
      selectedValue = option;
      isDropdownOpen = false;
    });
    widget.onSelect(option);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedValue != null) {
      selectedValue = widget.options.firstWhereOrNull(
        (item) => item.identifier == (widget.selectedValue ?? ''),
      );
    }
    return FormBuilderField<DropdownSelectionModel>(
        name: widget.name,
        initialValue: selectedValue,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (DropdownSelectionModel? newValue) {
          if (newValue != null) {
            widget.onSelect.call(newValue);
          }
        },
        builder: (FormFieldState<DropdownSelectionModel> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: widget.title,
                  style: PoppinsTextStyles.label.textMedium().copyWith(
                        fontWeight: widget.titleWeight,
                        color: widget.isEnabled
                            ? AppColors.black500
                            : AppColors.black300,
                      ),
                  children: [
                    if (widget.isRequired ?? false)
                      TextSpan(
                        text: ' *',
                        style: PoppinsTextStyles.textSm.textRegular().copyWith(
                              color: AppColors.brightRed,
                            ),
                      ),
                  ],
                ),
              ),
              AppValues.spacing8.verticalSpace,
              GestureDetector(
                onTap: widget.isEnabled ? toggleDropdown : null,
                child: Container(
                  padding: const EdgeInsets.all(AppValues.padding16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: field.hasError
                          ? AppColors.alert700
                          : widget.isEnabled
                              ? AppColors.black200
                              : AppColors.black300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: !widget.isEnabled
                        ? AppColors.black100
                        : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedValue == null
                              ? widget.placeholder
                              : widget.displayText(selectedValue!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: PoppinsTextStyles.bodyRegular
                              .textRegular()
                              .copyWith(
                                color: selectedValue == null
                                    ? AppColors.black300
                                    : widget.isEnabled
                                        ? AppColors.black500
                                        : AppColors.black300,
                              ),
                        ),
                      ),
                      Icon(
                        isDropdownOpen
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: widget.isEnabled
                            ? Colors.black
                            : AppColors.black300,
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.isError && widget.isShowMessageError == true)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Please select an option",
                    style: PoppinsTextStyles.bodySmall.textRegular().copyWith(
                          color: AppColors.alert700,
                        ),
                  ),
                ),
              if (isDropdownOpen)
                Container(
                  height: widget.options.length > 10
                      ? MediaQuery.of(context).size.height * 0.3
                      : null,
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: widget.options.map((option) {
                      return GestureDetector(
                        onTap: () {
                          field.didChange(option);
                          selectOption(option);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
                                  widget.displayText(option),
                                  style:
                                      PoppinsTextStyles.bodySmall.textRegular(),
                                ),
                              ),
                              if (selectedValue == option)
                                const Icon(Icons.check, color: Colors.green),
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
                    style: PoppinsTextStyles.textSm
                        .textRegular()
                        .copyWith(color: AppColors.alert700),
                  ),
                ),
            ],
          );
        });
  }
}
