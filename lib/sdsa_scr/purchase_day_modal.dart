import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/mood_cart_detail.dart';

import '../../../g/color_g.dart';
import '../../../models/mood_cart.dart';

class PurchaseDayModal extends StatelessWidget {
  final List<MoodCart> carts;

  const PurchaseDayModal({super.key, required this.carts});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                Text(
                  'Purchases',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Container(
                  height: 24.r,
                  width: 24.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.9),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon:
                        const Icon(Icons.close, size: 16, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                itemCount: carts.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final cart = carts[index];
                  final mood = cart.allMood.isNotEmpty
                      ? cart.allMood.last.moodName
                      : 'Unknown';

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.all(12.r),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: cart.moodCartPhoto != null
                              ? Image.memory(
                                  cart.moodCartPhoto!,
                                  width: 140.h,
                                  height: 140.h,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 140.h,
                                  height: 140.h,
                                  color: Colors.grey.shade200,
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    'assets/icons/image.svg',
                                    width: 36.w,
                                    height: 36.w,
                                  ),
                                ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cart.moodCartName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(getMoodIcon(mood),
                                      size: 18, color: Colors.black),
                                  SizedBox(width: 6.w),
                                  Text(
                                    mood,
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  const Icon(Icons.monetization_on_outlined,
                                      size: 18, color: Colors.black),
                                  SizedBox(width: 6.w),
                                  Text(
                                    cart.moodCartPrice.toStringAsFixed(2),
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorG.blueE,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MoodCartDetail(moodCart1: cart),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Go to purchase',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData getMoodIcon(String moodName) {
  switch (moodName.toLowerCase()) {
    case 'happy':
      return Icons.sentiment_very_satisfied;
    case 'joyful':
      return Icons.sentiment_satisfied_alt;
    case 'neutral':
      return Icons.sentiment_neutral;
    case 'sad':
      return Icons.sentiment_dissatisfied;
    case 'angry':
      return Icons.sentiment_very_dissatisfied;
    default:
      return Icons.sentiment_neutral;
  }
}
