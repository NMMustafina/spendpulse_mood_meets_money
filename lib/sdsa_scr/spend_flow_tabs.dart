import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../g/color_g.dart';
import '../g/moti_g.dart';

class SpendFlowTabs extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onChanged;

  const SpendFlowTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GMotiBut(
            onPressed: () => onChanged(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'Spending',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: selectedIndex == 0 ? ColorG.blueE : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  height: 8.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color:
                        selectedIndex == 0 ? ColorG.blueE : Colors.transparent,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GMotiBut(
            onPressed: () => onChanged(1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'Emotions',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: selectedIndex == 1 ? ColorG.blueE : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  height: 8.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color:
                        selectedIndex == 1 ? ColorG.blueE : Colors.transparent,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
