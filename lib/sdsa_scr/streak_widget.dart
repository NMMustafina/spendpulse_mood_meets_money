import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/streak_messages.dart';
import '../../../models/mood_cart.dart';

class StreakWidget extends StatelessWidget {
  final List<MoodCart> moodCarts;

  const StreakWidget({super.key, required this.moodCarts});

  int getDaysSinceLastPurchase() {
    if (moodCarts.isEmpty) return 0;
    final last = moodCarts
        .map((e) => e.moodCartDatePurch)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    return DateTime.now()
        .difference(DateTime(last.year, last.month, last.day))
        .inDays;
  }

  @override
  Widget build(BuildContext context) {
    final days = getDaysSinceLastPurchase();
    if (days == 0) return const SizedBox();

    final dayKey = days >= 8 ? 8 : days;
    final messageList = streakMessages[dayKey] ?? [];
    final message = (messageList..shuffle()).first;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$days',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/kubk.svg',
                height: 24.sp,
                width: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Your streak',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 8.w),
              SvgPicture.asset(
                'assets/icons/kubk.svg',
                height: 24.sp,
                width: 24.sp,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
