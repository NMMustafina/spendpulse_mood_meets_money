import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MonthPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final List<DateTime> availableDates;
  final void Function(DateTime) onSelected;

  const MonthPickerDialog({
    super.key,
    required this.initialDate,
    required this.availableDates,
    required this.onSelected,
  });

  @override
  State<MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late List<DateTime> _uniqueMonthYear;
  late List<int> _years;
  late int selectedMonth;
  late int selectedYear;

  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  @override
  void initState() {
    super.initState();

    _uniqueMonthYear = widget.availableDates
        .map((d) => DateTime(d.year, d.month))
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b));

    _years = _uniqueMonthYear.map((d) => d.year).toSet().toList()..sort();

    selectedMonth = widget.initialDate.month;
    selectedYear = widget.initialDate.year;

    monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    yearController =
        FixedExtentScrollController(initialItem: _years.indexOf(selectedYear));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  Text(
                    'Select a month',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: 24.r,
                    width: 24.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.9),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.close,
                          size: 16, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: monthController,
                          itemExtent: 32.h,
                          onSelectedItemChanged: (index) {
                            final newMonth = index + 1;
                            final validYears = _years
                                .where((y) => _uniqueMonthYear
                                    .contains(DateTime(y, newMonth)))
                                .toList();
                            final updatedYear =
                                validYears.contains(selectedYear)
                                    ? selectedYear
                                    : validYears.isNotEmpty
                                        ? validYears.first
                                        : selectedYear;

                            setState(() {
                              selectedMonth = newMonth;
                              selectedYear = updatedYear;
                              yearController
                                  .jumpToItem(_years.indexOf(updatedYear));
                            });
                          },
                          selectionOverlay: Container(),
                          children: List.generate(12, (i) {
                            final monthName =
                                DateFormat.MMMM().format(DateTime(0, i + 1));
                            return Center(
                              child: Text(
                                monthName,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: yearController,
                          itemExtent: 32.h,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedYear = _years[index];
                            });
                          },
                          selectionOverlay: Container(),
                          children: _years.map((y) {
                            return Center(
                              child: Text(
                                '$y',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: (150.h - 32.h) / 2,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 32.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1.2),
                      borderRadius: BorderRadius.circular(6.r),
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final selected = DateTime(selectedYear, selectedMonth);
                  final isValid = _uniqueMonthYear.contains(selected);

                  if (isValid) {
                    Navigator.of(context).pop();
                    widget.onSelected(selected);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Select',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
