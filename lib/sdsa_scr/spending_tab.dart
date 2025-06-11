import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/mood_cart_provider.dart';
import '../providers/selected_month_provider.dart';
import 'spending_category_list.dart';
import 'spending_line_chart.dart';
import 'spending_stats.dart';

class SpendingTab extends StatelessWidget {
  const SpendingTab({super.key});

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
            const SpendingLineChart(),
            SizedBox(height: 16.h),
            SpendingStats(filtered),
            SizedBox(height: 16.h),
            SpendingCategoryList(filtered),
          ],
        );
      },
    );
  }
}
