import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../g/color_g.dart';
import '../providers/mood_cart_provider.dart';
import '../providers/selected_month_provider.dart';

class SpendingLineChart extends StatelessWidget {
  const SpendingLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final carts = context.watch<MoodCartProvider>().moodCarts;
    final selectedMonth = context.watch<SelectedMonthProvider>().selectedMonth;

    final monthCarts = carts
        .where((e) =>
            e.moodCartDatePurch.year == selectedMonth.year &&
            e.moodCartDatePurch.month == selectedMonth.month)
        .toList();

    if (monthCarts.isEmpty) return const SizedBox();

    final Map<int, double> dayTotals = {};
    for (var cart in monthCarts) {
      final day = cart.moodCartDatePurch.day;
      dayTotals[day] = (dayTotals[day] ?? 0) + cart.moodCartPrice;
    }

    final spots = dayTotals.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    final daysInMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    final maxYRaw =
        spots.map((e) => e.y).fold<double>(0, (a, b) => a > b ? a : b);

    final horizontalLineCount = maxYRaw < 10 ? 4 : 10;
    final interval = ((maxYRaw / horizontalLineCount).ceil())
        .clamp(1, double.infinity)
        .toDouble();
    final maxY = (interval * horizontalLineCount).toDouble();

    final singlePoint = spots.length == 1;
    final verticalLine = [
      FlSpot(spots.first.x, 0),
      FlSpot(spots.first.x, spots.first.y)
    ];

    return SizedBox(
      height: 240.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: daysInMonth * 20.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 40.h, right: 12.w, left: 8.w, bottom: 8.h),
                child: LineChart(
                  LineChartData(
                    minX: 1,
                    maxX: daysInMonth.toDouble(),
                    minY: 0,
                    maxY: maxY,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      horizontalInterval: interval,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (_) => FlLine(
                        color: Colors.grey.withOpacity(0.08),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: interval,
                          getTitlesWidget: (value, _) => Padding(
                            padding: EdgeInsets.only(right: 4.w),
                            child: Text(
                              '\$${value.toInt()}',
                              style: TextStyle(
                                  fontSize: 10.sp, color: Colors.black),
                            ),
                          ),
                          reservedSize: 40.w,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, _) {
                            final day = value.toInt();
                            if (day >= 1 && day <= daysInMonth) {
                              return Text(
                                day.toString().padLeft(2, '0'),
                                style: TextStyle(
                                    fontSize: 10.sp, color: Colors.black),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: singlePoint ? verticalLine : spots,
                        isCurved: false,
                        color: ColorG.blueE,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: !singlePoint,
                          gradient: LinearGradient(
                            colors: [
                              ColorG.blueE.withOpacity(0.4),
                              ColorG.blueE.withOpacity(0.05)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                left: 6.w,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'Your spending for ${DateFormat('MMMM').format(selectedMonth)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
