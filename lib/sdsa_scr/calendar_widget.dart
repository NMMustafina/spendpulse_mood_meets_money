import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/mood_marker_builder.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/purchase_day_modal.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../models/mood_cart.dart';

class CalendarWidget extends StatefulWidget {
  final List<MoodCart> moodCarts;

  const CalendarWidget({super.key, required this.moodCarts});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedDay;
  late List<DateTime> _availableMonths;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _availableMonths = widget.moodCarts
        .map((e) =>
            DateTime(e.moodCartDatePurch.year, e.moodCartDatePurch.month))
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b));
  }

  Map<DateTime, List<MoodCart>> _groupCartsByDay(List<MoodCart> carts) {
    final Map<DateTime, List<MoodCart>> map = {};
    for (var cart in carts) {
      final day = DateTime(cart.moodCartDatePurch.year,
          cart.moodCartDatePurch.month, cart.moodCartDatePurch.day);
      if (!map.containsKey(day)) {
        map[day] = [];
      }
      map[day]!.add(cart);
    }
    return map;
  }

  bool _hasNextMonth() {
    return _availableMonths.any((month) =>
        (month.year > _focusedDay.year) ||
        (month.year == _focusedDay.year && month.month > _focusedDay.month));
  }

  bool _hasPreviousMonth() {
    return _availableMonths.any((month) =>
        (month.year < _focusedDay.year) ||
        (month.year == _focusedDay.year && month.month < _focusedDay.month));
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsMap = _groupCartsByDay(widget.moodCarts);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _hasPreviousMonth() ? _goToPreviousMonth : null,
                icon: Icon(Icons.arrow_back_ios,
                    color: _hasPreviousMonth() ? Colors.black : Colors.grey),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat('MMMM yyyy').format(_focusedDay),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              IconButton(
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _hasNextMonth() ? _goToNextMonth : null,
                icon: Icon(Icons.arrow_forward_ios,
                    color: _hasNextMonth() ? Colors.black : Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TableCalendar<MoodCart>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            headerVisible: false,
            rowHeight: 38,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              isTodayHighlighted: false,
              markersMaxCount: 0,
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.black),
              weekendStyle: TextStyle(color: Colors.black),
            ),
            eventLoader: (day) {
              return eventsMap[DateTime(day.year, day.month, day.day)] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final carts =
                    eventsMap[DateTime(day.year, day.month, day.day)] ?? [];
                if (carts.isNotEmpty) {
                  return buildMoodCircle(carts, day);
                }
                return Center(
                  child: Text('${day.day}',
                      style: const TextStyle(color: Colors.black)),
                );
              },
              outsideBuilder: (context, day, focusedDay) {
                return Center(
                  child: Text('${day.day}',
                      style: const TextStyle(color: Colors.grey)),
                );
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              final carts = eventsMap[DateTime(
                      selectedDay.year, selectedDay.month, selectedDay.day)] ??
                  [];
              if (carts.isNotEmpty) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => PurchaseDayModal(carts: carts),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
