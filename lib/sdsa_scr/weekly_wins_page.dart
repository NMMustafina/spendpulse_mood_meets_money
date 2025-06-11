import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/streak_widget.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/tips_widget.dart';

import '../g/color_g.dart';
import '../g/moti_g.dart';
import '../providers/limit_provider.dart';
import '../providers/mood_cart_provider.dart';
import 'calendar_widget.dart';

class WeeklyWinsPage extends StatefulWidget {
  const WeeklyWinsPage({super.key});

  @override
  State<WeeklyWinsPage> createState() => _WeeklyWinsPageState();
}

class _WeeklyWinsPageState extends State<WeeklyWinsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorG.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GMotiBut(
                      onPressed: () => Navigator.pop(context),
                      child:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Weekly wins',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer2<MoodCartProvider, LimitProvider>(
                builder: (context, moodProvider, limitProvider, child) {
                  return Padding(
                    padding:
                        EdgeInsets.only(left: 16.w, right: 16.w, bottom: 32.h),
                    child: ListView(
                      padding: EdgeInsets.only(bottom: 32.h),
                      children: [
                        CalendarWidget(moodCarts: moodProvider.moodCarts),
                        SizedBox(height: 16.h),
                        StreakWidget(moodCarts: moodProvider.moodCarts),
                        SizedBox(height: 16.h),
                        const TipsWidget(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
