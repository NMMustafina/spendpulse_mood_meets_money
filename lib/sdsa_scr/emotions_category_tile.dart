import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/mood_cart.dart';

class EmotionsCategoryTile extends StatelessWidget {
  final String categoryName;
  final List<MoodCart> carts;
  final bool isExpanded;
  final VoidCallback onTap;

  const EmotionsCategoryTile({
    super.key,
    required this.categoryName,
    required this.carts,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final total = carts.fold<double>(
      0,
      (sum, e) => sum + e.moodCartPrice,
    );

    final moodIcons = {
      'Angry': '😠',
      'Sad': '😔',
      'Neutral': '😐',
      'Joyful': '😊',
      'Happy': '😄',
    };

    final moodOrder = ['Happy', 'Joyful', 'Neutral', 'Sad', 'Angry'];

    final iconPath = carts.first.moodCartCategory.isCustom
        ? 'assets/icons/all.svg'
        : carts.first.moodCartCategory.icon;

    final Map<String, List<MoodCart>> groupedByMood = {};
    for (final cart in carts) {
      final mood = cart.firstMood.moodName;
      groupedByMood.putIfAbsent(mood, () => []).add(cart);
    }

    final sortedMoodEntries = groupedByMood.entries.toList()
      ..sort((a, b) =>
          moodOrder.indexOf(a.key).compareTo(moodOrder.indexOf(b.key)));

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      width: 20.w,
                      height: 20.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "\$${total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Column(
                children: sortedMoodEntries.map((entry) {
                  final mood = entry.key;
                  final icon = moodIcons[mood] ?? '';
                  final count = entry.value.length;
                  final total = entry.value
                      .fold<double>(
                        0,
                        (sum, e) => sum + e.moodCartPrice,
                      )
                      .toStringAsFixed(2);

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(icon, style: TextStyle(fontSize: 18.sp)),
                            SizedBox(width: 6.w),
                            Text(
                              '$mood – $count ${count == 1 ? "purchase" : "purchases"}',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                        Text(
                          '\$$total',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
