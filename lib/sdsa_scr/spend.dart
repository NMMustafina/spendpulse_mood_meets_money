import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../g/color_g.dart';
import '../providers/mood_cart_provider.dart';
import '../providers/selected_month_provider.dart';
import 'emotions_tab.dart';
import 'spend_flow_actions.dart';
import 'spend_flow_tabs.dart';
import 'spending_tab.dart';

class Spend extends StatefulWidget {
  const Spend({super.key});

  @override
  State<Spend> createState() => _SpendState();
}

class _SpendState extends State<Spend> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final moodCarts = context.watch<MoodCartProvider>().moodCarts;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SelectedMonthProvider>().setAvailableMonths(
            moodCarts.map((e) => e.moodCartDatePurch).toList(),
          );
    });

    return Scaffold(
      backgroundColor: ColorG.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spend Flow',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SpendFlowActions(),
                ],
              ),
            ),
            SpendFlowTabs(
              selectedIndex: selectedTab,
              onChanged: (index) => setState(() => selectedTab = index),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child:
                  selectedTab == 0 ? const SpendingTab() : const EmotionsTab(),
            ),
          ],
        ),
      ),
    );
  }
}
