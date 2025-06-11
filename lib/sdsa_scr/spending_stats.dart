import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/mood_cart.dart';

class SpendingStats extends StatelessWidget {
  final List<MoodCart> carts;

  const SpendingStats(this.carts, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
              child: _buildStatTile("\$${_total(carts)}", "Total spending")),
          Expanded(child: _buildStatTile("${carts.length}", "Total purchases")),
          Expanded(
              child: _buildStatTile("\$${_average(carts)}", "Average cost")),
        ],
      ),
    );
  }

  Widget _buildStatTile(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 1,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _total(List<MoodCart> carts) {
    final total = carts.fold(0.0, (sum, e) => sum + e.moodCartPrice);
    return total.toStringAsFixed(2);
  }

  String _average(List<MoodCart> carts) {
    if (carts.isEmpty) return '0.00';
    final avg =
        carts.fold(0.0, (sum, e) => sum + e.moodCartPrice) / carts.length;
    return avg.toStringAsFixed(2);
  }
}
