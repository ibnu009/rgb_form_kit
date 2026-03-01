import 'package:flutter/material.dart';

import '../../resources/constants/form_constants.dart';
import '../../styles/colors.dart';
import '../../styles/text_styles/poppins_text_styles.dart';
import '../../utils/ui_extensions.dart';

class DatePickerWidget extends StatefulWidget {
  final String? selectedDay;
  final String? selectedMonth;
  final String? selectedYear;
  final String? title;
  final Function(String) onDaySelected;
  final Function(String) onMonthSelected;
  final Function(String) onYearSelected;
  final String? errorMessage;

  const DatePickerWidget({
    super.key,
    this.selectedDay,
    this.selectedMonth,
    this.selectedYear,
    required this.onDaySelected,
    required this.onMonthSelected,
    required this.onYearSelected,
    this.errorMessage,
    this.title,
  });

  @override
  DatePickerWidgetState createState() => DatePickerWidgetState();
}

class DatePickerWidgetState extends State<DatePickerWidget> {
  late String currentYear;
  late List<String> years;

  @override
  void initState() {
    super.initState();
    currentYear = DateTime.now().year.toString();
    years = [(int.parse(currentYear) - 1).toString(), currentYear];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          widget.title ?? FormConstants.visitDate.tr,
          style: PoppinsTextStyles.textMd.textRegular().copyWith(
                color: AppColors.black500,
              ),),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  placeholder: FormConstants.day.tr,
                  selectedValue: widget.selectedDay,
                  options: List.generate(31, (index) => (index + 1).toString()),
                  onSelect: widget.onDaySelected,
                ),
              ),
              Expanded(
                child: _buildDropdown(
                  placeholder: FormConstants.month.tr,
                  selectedValue: widget.selectedMonth,
                  options: List.generate(
                      12, (index) => (index + 1).toString().padLeft(2, '0')),
                  onSelect: widget.onMonthSelected,
                ),
              ),
              Expanded(
                child: _buildDropdown(
                  placeholder: FormConstants.year.tr,
                  selectedValue: widget.selectedYear ?? currentYear,
                  options: years,
                  onSelect: widget.onYearSelected,
                ),
              ),
            ],
          ),
        if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdown({
    required String placeholder,
    required String? selectedValue,
    required List<String> options,
    required Function(String) onSelect,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: placeholder,
        border: const OutlineInputBorder(),
      ),
      initialValue: selectedValue,
      items: options.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onSelect(value);
        }
      },
    );
  }
}
