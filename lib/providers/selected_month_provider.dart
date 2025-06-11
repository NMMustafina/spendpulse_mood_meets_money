import 'package:flutter/material.dart';

class SelectedMonthProvider with ChangeNotifier {
  DateTime _selectedMonth = DateTime.now();

  DateTime get selectedMonth => _selectedMonth;

  List<DateTime> _availableMonths = [];

  List<DateTime> get availableMonths => _availableMonths;

  void setMonth(DateTime newMonth) {
    _selectedMonth = newMonth;
    notifyListeners();
  }

  void setAvailableMonths(List<DateTime> dates) {
    final unique = dates.map((d) => DateTime(d.year, d.month)).toSet().toList()
      ..sort((a, b) => a.compareTo(b));

    _availableMonths = unique;
    notifyListeners();
  }
}
