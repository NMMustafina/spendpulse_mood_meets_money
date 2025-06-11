import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/mood_cart.dart';

class EmotionsPieChart extends StatelessWidget {
  final List<MoodCart> carts;

  const EmotionsPieChart(this.carts, {super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, double> moodTotals = {};
    final Map<String, int> moodCounts = {};
    final Map<String, Color> moodColors = {
      'Happy': const Color(0xFF21FFB9),
      'Joyful': const Color(0xFF58F012),
      'Neutral': const Color(0xFFEDF419),
      'Sad': const Color(0xFFEE7F1E),
      'Angry': const Color(0xFFED0F0F),
    };

    double total = 0;

    for (var cart in carts) {
      final mood = cart.firstMood.moodName;
      moodTotals[mood] = (moodTotals[mood] ?? 0) + cart.moodCartPrice;
      moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
      total += cart.moodCartPrice;
    }

    final moodOrder = ['Happy', 'Joyful', 'Neutral', 'Sad', 'Angry'];

    final sortedTotals = moodTotals.entries.toList()
      ..sort((a, b) =>
          moodOrder.indexOf(a.key).compareTo(moodOrder.indexOf(b.key)));

    final sections = sortedTotals.map((entry) {
      final mood = entry.key;
      final value = entry.value;
      return PieChartSectionData(
        value: value,
        title: '',
        color: moodColors[mood] ?? Colors.grey,
        radius: 20.r,
      );
    }).toList();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            "Emotions of buying",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 160.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 63.r,
                    sectionsSpace: 3,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        formatAmount(total),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          ...sortedTotals.map((entry) {
            final mood = entry.key;
            final amount = entry.value;
            final count = moodCounts[mood]!;
            final percent = total == 0 ? 0 : ((amount / total) * 100).round();
            final color = moodColors[mood] ?? Colors.grey;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                children: [
                  Container(
                    width: 10.r,
                    height: 10.r,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      '$mood ($count)',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                  Text(
                    '$percent% - \$${amount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 100000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${amount.toStringAsFixed(2)}';
    }
  }
}
