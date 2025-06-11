import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/mood_cart.dart';

class SpendingCategoryList extends StatelessWidget {
  final List<MoodCart> carts;

  const SpendingCategoryList(this.carts, {super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, double> categoryTotals = {};
    final Map<String, String> categoryIcons = {};
    final Map<String, bool> customFlags = {};
    final total = carts.fold(0.0, (sum, e) => sum + e.moodCartPrice);

    for (final e in carts) {
      final key = e.moodCartCategory.name;
      categoryTotals[key] = (categoryTotals[key] ?? 0) + e.moodCartPrice;
      categoryIcons[key] = e.moodCartCategory.icon;
      customFlags[key] = e.moodCartCategory.isCustom;
    }

    final items = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: items.map((entry) {
        final percent = total == 0 ? 0 : (entry.value / total * 100).round();
        final isCustom = customFlags[entry.key] ?? false;
        final iconPath =
            isCustom ? 'assets/icons/all.svg' : categoryIcons[entry.key];

        return Container(
          width: (MediaQuery.of(context).size.width - 16.w * 2 - 12.w) / 2,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    iconPath ?? '',
                    width: 20.r,
                    height: 20.r,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\$${entry.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '  - $percent%',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
