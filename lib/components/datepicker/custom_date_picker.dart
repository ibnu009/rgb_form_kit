import 'dart:developer' as RgbFormKitLogger;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../resources/constants/form_constants.dart';
import '../../resources/constants/general_constans.dart';
import '../../styles/colors.dart';
import '../../styles/text_styles/poppins_text_styles.dart';
import '../../styles/values.dart';
import '../../utils/ui_extensions.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateChanged;
  final bool isEnabled;
  final bool hasError;
  final String? title;
  final bool isRequired;
  final TextStyle? titleStyle;
  final bool yearMonthOnly;
  final bool prefillYearMonth;
  final bool useDefaultValue;

  const CustomDatePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateChanged,
    this.isEnabled = true,
    this.hasError = false,
    this.title,
    this.isRequired = false,
    this.titleStyle,
    this.yearMonthOnly = false,
    this.prefillYearMonth = false,
    this.useDefaultValue = true,
  });

  @override
  CustomDatePickerState createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;
  late bool _hasSelectedDay;
  late bool _hasSelectedMonth;
  late bool _hasSelectedYear;

  List<int> dayOptions = [];
  final List<int> monthOptions = List.generate(12, (index) => index + 1);
  List<int> yearOptions = [];

  bool isDayDropdownOpen = false;
  bool isMonthDropdownOpen = false;
  bool isYearDropdownOpen = false;

  final ScrollController _dayScrollController = ScrollController();
  final ScrollController _monthScrollController = ScrollController();
  final ScrollController _yearScrollController = ScrollController();

  static const double _itemHeight = 48.0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    // ← Modifikasi logika inisialisasi
    DateTime? effectiveInitialDate = widget.initialDate;

    // Jika tidak ada initialDate tapi useDefaultValue true, gunakan sekarang
    if (effectiveInitialDate == null && widget.useDefaultValue) {
      effectiveInitialDate = now;
    }

    if (effectiveInitialDate != null) {
      selectedMonth = effectiveInitialDate.month;
      selectedYear = effectiveInitialDate.year;
      selectedDay = effectiveInitialDate.day;

      if (widget.prefillYearMonth) {
        // Mode: Prefill year-month, user harus pilih day
        _hasSelectedYear = true; // Year sudah prefilled
        _hasSelectedMonth = true; // Month sudah prefilled
        _hasSelectedDay = false; // Day belum dipilih user
      } else if (widget.yearMonthOnly) {
        // Mode: Hanya butuh year-month
        selectedDay = 1; // Default day = 1
        _hasSelectedYear = widget.useDefaultValue; // ← Gunakan flag
        _hasSelectedMonth = widget.useDefaultValue; // ← Gunakan flag
        _hasSelectedDay = false; // Day tidak perlu dipilih
      } else {
        // Mode: Normal
        _hasSelectedYear = widget.useDefaultValue; // ← Gunakan flag
        _hasSelectedMonth = widget.useDefaultValue; // ← Gunakan flag
        _hasSelectedDay = widget.useDefaultValue; // ← Gunakan flag
      }
    } else {
      // Tidak ada initialDate dan useDefaultValue false
      selectedDay = now.day;
      selectedMonth = now.month;
      selectedYear = now.year;
      _hasSelectedDay = false;
      _hasSelectedMonth = false;
      _hasSelectedYear = false;
    }

    int startYear = widget.firstDate?.year ?? (now.year - 100);
    int endYear = widget.lastDate?.year ?? now.year;
    yearOptions = List.generate(endYear - startYear + 1, (i) => startYear + i);

    _updateDayOptions();
  }

  // Metode didUpdateWidget untuk menangani perubahan widget.initialDate
  @override
  void didUpdateWidget(covariant CustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      setState(() {
        if (widget.initialDate != null) {
          selectedMonth = widget.initialDate!.month;
          selectedYear = widget.initialDate!.year;
          selectedDay = widget.initialDate!.day;

          // Untuk yearMonthOnly dengan prefill: year dan month sudah terpilih, day belum
          if (widget.yearMonthOnly) {
            _hasSelectedMonth = true;
            _hasSelectedYear = true;
            // Cek apakah ini update dari form value (user sudah pilih lengkap)
            // atau hanya prefill initial (belum ada day selection)
            bool isFromFormValue = oldWidget.initialDate != null;
            _hasSelectedDay = isFromFormValue;
          } else {
            _hasSelectedMonth = true;
            _hasSelectedYear = true;
            _hasSelectedDay = true;
          }
        } else {
          // Reset semua ke belum terpilih
          final now = DateTime.now();
          selectedDay = now.day;
          selectedMonth = now.month;
          selectedYear = now.year;
          _hasSelectedDay = false;
          _hasSelectedMonth = false;
          _hasSelectedYear = false;
        }
        _updateDayOptions();
      });
    }
  }

  // Update day options based on selected month/year and widget.lastDate.
  void _updateDayOptions() {
    final now = DateTime.now();
    final effectiveFirstDate = widget.firstDate ?? DateTime((now.year - 100));

    final fullDaysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    int maxDay = fullDaysInMonth;
    int minDay = 1;

    // Check if selected year/month equals firstDate constraints
    if (selectedYear == effectiveFirstDate.year &&
        selectedMonth == effectiveFirstDate.month) {
      minDay = effectiveFirstDate.day;
    }

    // Check if selected year/month equals lastDate constraints
    if (widget.lastDate != null &&
        selectedYear == widget.lastDate!.year &&
        selectedMonth == widget.lastDate!.month) {
      maxDay = widget.lastDate!.day;
    }

    // Ensure we have at least one valid day
    if (minDay > maxDay) {
      dayOptions = [];
      return;
    }

    dayOptions = List.generate(maxDay - minDay + 1, (i) => minDay + i);

    // Auto-adjust selected day if it's outside the valid range
    if (selectedDay > maxDay) {
      selectedDay = maxDay;
      if (_hasSelectedDay) {
        // If day was previously selected, update the callback
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _notifyDateChangedIfComplete();
        });
      }
    } else if (selectedDay < minDay) {
      selectedDay = minDay;
      if (_hasSelectedDay) {
        // If day was previously selected, update the callback
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _notifyDateChangedIfComplete();
        });
      }
    }
  }

  // Notify onDateChanged if all fields are selected.
  void _notifyDateChangedIfComplete() {
    bool dayCondition = widget.yearMonthOnly ? true : _hasSelectedDay;

    RgbFormKitLogger.log(
        '🔍 Debug: dayCondition=$dayCondition, month=$_hasSelectedMonth, year=$_hasSelectedYear');

    if (dayCondition && _hasSelectedMonth && _hasSelectedYear) {
      RgbFormKitLogger.log('✅ Calling onDateChanged');
      if (widget.onDateChanged != null) {
        widget
            .onDateChanged!(DateTime(selectedYear, selectedMonth, selectedDay));
      }
    } else {
      RgbFormKitLogger.log('❌ NOT calling onDateChanged');
    }
  }

  // Toggle day dropdown and scroll to selected day.
  void _toggleDayDropdown() {
    if (!widget.isEnabled) return;
    setState(() {
      isDayDropdownOpen = !isDayDropdownOpen;
      if (isDayDropdownOpen) {
        isMonthDropdownOpen = false;
        isYearDropdownOpen = false;
      }
    });
    if (isDayDropdownOpen && _hasSelectedDay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final index = dayOptions.indexOf(selectedDay);
        if (_dayScrollController.hasClients) {
          _dayScrollController.animateTo(
            index * _itemHeight,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _toggleMonthDropdown() {
    if (!widget.isEnabled) return;
    setState(() {
      isMonthDropdownOpen = !isMonthDropdownOpen;
      if (isMonthDropdownOpen) {
        isDayDropdownOpen = false;
        isYearDropdownOpen = false;
      }
    });
    if (isMonthDropdownOpen && _hasSelectedMonth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final index = monthOptions.indexOf(selectedMonth);
        if (_monthScrollController.hasClients) {
          _monthScrollController.animateTo(
            index * _itemHeight,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _toggleYearDropdown() {
    if (!widget.isEnabled) return;
    setState(() {
      isYearDropdownOpen = !isYearDropdownOpen;
      if (isYearDropdownOpen) {
        isDayDropdownOpen = false;
        isMonthDropdownOpen = false;
      }
    });
    if (isYearDropdownOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final index = yearOptions.indexOf(selectedYear);
        if (_yearScrollController.hasClients) {
          _yearScrollController.animateTo(
            index * _itemHeight,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  Widget _buildDropdownButton({
    required String placeholder,
    required String displayText,
    required bool isOpen,
    required VoidCallback toggleDropdown,
    required bool hasSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          placeholder,
          style: PoppinsTextStyles.label.textMedium().copyWith(
                color:
                    widget.isEnabled ? AppColors.black500 : AppColors.black300,
              ),
        ),
        AppValues.spacing8.verticalSpace,
        GestureDetector(
          onTap: widget.isEnabled ? toggleDropdown : null,
          child: Container(
            padding: const EdgeInsets.all(AppValues.padding12),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.hasError
                    ? AppColors.alert700
                    : widget.isEnabled
                        ? AppColors.black200
                        : AppColors.black300,
              ),
              borderRadius: BorderRadius.circular(8),
              color:
                  widget.isEnabled ? Colors.transparent : Colors.grey.shade200,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    !hasSelected ? placeholder : displayText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: PoppinsTextStyles.bodySmall.textRegular().copyWith(
                          color: !hasSelected
                              ? AppColors.black300
                              : AppColors.black500,
                        ),
                  ),
                ),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: widget.isEnabled ? Colors.black : Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownList({
    required List<int> options,
    required int selectedValue,
    required Function(int) onOptionSelected,
    required ScrollController controller,
    required bool showCheckmark,
    String Function(int)? displayFormatter,
  }) {
    return Container(
      height:
          options.length > 10 ? MediaQuery.of(context).size.height * 0.3 : null,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return GestureDetector(
            onTap: () {
              onOptionSelected(option);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              height: _itemHeight,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayFormatter != null
                          ? displayFormatter(option)
                          : option.toString(),
                      style: PoppinsTextStyles.bodySmall.textRegular(),
                    ),
                  ),
                  if (showCheckmark && selectedValue == option)
                    const Icon(Icons.check, color: Colors.green),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _dayScrollController.dispose();
    _monthScrollController.dispose();
    _yearScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Limit month options if selected year equals lastDate.year.
    // final currentMonthOptions =
    //     (widget.lastDate != null && selectedYear == widget.lastDate!.year)
    //         ? List.generate(widget.lastDate!.month, (index) => index + 1)
    //         : monthOptions;

    final now = DateTime.now();
    final effectiveFirstDate = widget.firstDate ?? now.subtract(const Duration(days: 100));

    // Calculate current month options based on selected year and date constraints
    List<int> currentMonthOptions = [];

    if (selectedYear < effectiveFirstDate.year) {
      // Selected year is before the minimum allowed year - no months should be available
      currentMonthOptions = [];
    } else if (selectedYear == effectiveFirstDate.year) {
      // Selected year equals firstDate year - start from firstDate.month
      int startMonth = effectiveFirstDate.month;
      int endMonth = 12;

      // If lastDate is also in the same year, limit end month
      if (widget.lastDate != null && selectedYear == widget.lastDate!.year) {
        endMonth = widget.lastDate!.month;
      }

      currentMonthOptions = List.generate(
          endMonth - startMonth + 1,
              (index) => startMonth + index
      );
    } else if (widget.lastDate != null && selectedYear == widget.lastDate!.year) {
      // Selected year equals lastDate year only - limit to lastDate.month
      currentMonthOptions = List.generate(widget.lastDate!.month, (index) => index + 1);
    } else if (widget.lastDate != null && selectedYear > widget.lastDate!.year) {
      // Selected year is after the maximum allowed year - no months should be available
      currentMonthOptions = [];
    } else {
      // Selected year is between firstDate and lastDate years - show all months
      currentMonthOptions = monthOptions;
    }

    // Auto-adjust selected month if it's not in the available options
    if (currentMonthOptions.isNotEmpty && !currentMonthOptions.contains(selectedMonth)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedMonth = currentMonthOptions.first;
          _updateDayOptions();
          if (_hasSelectedYear && currentMonthOptions.isNotEmpty) {
            _hasSelectedMonth = true;
            _notifyDateChangedIfComplete();
          }
        });
      });
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title != null
            ? RichText(
                text: TextSpan(
                  text: widget.title,
                  style: widget.titleStyle ??
                      PoppinsTextStyles.bodyRegular.textRegular().copyWith(
                            color: widget.isEnabled
                                ? AppColors.black500
                                : AppColors.black300,
                          ),
                  children: [
                    if (widget.isRequired)
                      TextSpan(
                        text: ' *',
                        style: PoppinsTextStyles.textSm
                            .textRegular()
                            .copyWith(color: AppColors.brightRed),
                      ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        AppValues.spacing8.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year dropdown.
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDropdownButton(
                    placeholder: GeneralConstants.year.tr,
                    displayText: selectedYear.toString(),
                    isOpen: isYearDropdownOpen,
                    toggleDropdown: _toggleYearDropdown,
                    hasSelected: _hasSelectedYear,
                  ),
                  if (isYearDropdownOpen)
                    _buildDropdownList(
                      options: yearOptions,
                      selectedValue: selectedYear,
                      onOptionSelected: (int value) {
                        setState(() {
                          selectedYear = value;
                          // Adjust month if it exceeds lastDate.month when year equals lastDate.year.
                          if (widget.lastDate != null &&
                              selectedYear == widget.lastDate!.year &&
                              selectedMonth > widget.lastDate!.month) {
                            selectedMonth = widget.lastDate!.month;
                          }
                          _updateDayOptions();
                          isYearDropdownOpen = false;
                          _hasSelectedYear = true;
                          _notifyDateChangedIfComplete();
                        });
                      },
                      controller: _yearScrollController,
                      showCheckmark: _hasSelectedYear,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Month dropdown.
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDropdownButton(
                    placeholder: GeneralConstants.month.tr,
                    // displayText: selectedMonth.toString(),
                    displayText: getFormattedMonth(selectedMonth),
                    isOpen: isMonthDropdownOpen,
                    toggleDropdown: _toggleMonthDropdown,
                    hasSelected: _hasSelectedMonth,
                  ),
                  if (isMonthDropdownOpen)
                    _buildDropdownList(
                      options: currentMonthOptions,
                      selectedValue: selectedMonth,
                      onOptionSelected: (int value) {
                        setState(() {
                          selectedMonth = value;
                          _updateDayOptions();
                          isMonthDropdownOpen = false;
                          _hasSelectedMonth = true;
                          _notifyDateChangedIfComplete();
                        });
                      },
                      controller: _monthScrollController,
                      showCheckmark: _hasSelectedMonth,
                      displayFormatter: getFormattedMonth,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Day dropdown.
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDropdownButton(
                    placeholder: FormConstants.date.tr,
                    displayText: selectedDay.toString(),
                    isOpen: isDayDropdownOpen,
                    toggleDropdown: _toggleDayDropdown,
                    hasSelected: _hasSelectedDay,
                  ),
                  if (isDayDropdownOpen)
                    _buildDropdownList(
                      options: dayOptions,
                      selectedValue: selectedDay,
                      onOptionSelected: (int value) {
                        setState(() {
                          selectedDay = value;
                          isDayDropdownOpen = false;
                          _hasSelectedDay = true;
                          _notifyDateChangedIfComplete();
                        });
                      },
                      controller: _dayScrollController,
                      showCheckmark: _hasSelectedDay,
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String getFormattedMonth(int monthNumber) {
    // Membuat tanggal acuan yang menunjukkan bulan yang diinginkan.
    DateTime date = DateTime(2000, monthNumber);
    // Format singkatan bulan, misalnya "MMM" akan menghasilkan "Jan", "Feb", dll.
    String monthAbbreviation = DateFormat.MMM().format(date);
    return "$monthNumber - $monthAbbreviation";
  }
}
