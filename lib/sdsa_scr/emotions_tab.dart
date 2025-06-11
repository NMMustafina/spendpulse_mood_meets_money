import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/emotions_category_list.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/emotions_change_summary.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/emotions_pie_chart.dart';

import '../providers/mood_cart_provider.dart';
import '../providers/selected_month_provider.dart';

class EmotionsTab extends StatelessWidget {
  const EmotionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MoodCartProvider>(
      builder: (context, moodCartProvider, _) {
        final moodCarts = moodCartProvider.moodCarts;
        final selectedMonth =
            context.watch<SelectedMonthProvider>().selectedMonth;
        final filtered = moodCarts
            .where((e) =>
                e.moodCartDatePurch.month == selectedMonth.month &&
                e.moodCartDatePurch.year == selectedMonth.year)
            .toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/chart.svg',
                  height: 64.sp,
                  width: 64.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 16.h),
                Text(
                  "You don't have data to analyze yet",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            EmotionsPieChart(filtered),
            SizedBox(height: 16.h),
            EmotionsChangeSummary(filtered),
            SizedBox(height: 16.h),
            EmotionsCategoryList(filtered),
          ],
        );
      },
    );
  }
}
