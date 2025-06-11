import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/mood.dart';
import '../g/color_g.dart';
import '../g/moti_g.dart';
import '../models/mood_cart.dart';
import '../providers/mood_cart_provider.dart';

class HistoPage extends StatelessWidget {
  const HistoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorG.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GMotiBut(
          child: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<MoodCartProvider>(
        builder: (context, moodCartProvider, child) {
          if (moodCartProvider.moodCarts.isEmpty) {
            return const Center(
              child: Text('No history found'),
            );
          }

          return GroupedListView<MoodCart, DateTime>(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            elements: moodCartProvider.moodCarts,
            groupBy: (element) => DateTime(
              element.moodCartDatePurch.year,
              element.moodCartDatePurch.month,
              element.moodCartDatePurch.day,
            ),
            groupSeparatorBuilder: (DateTime date) => Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMMM dd, yyyy').format(date),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '\$${_calculateDayTotal(moodCartProvider.moodCarts.where((cart) => DateTime(cart.moodCartDatePurch.year, cart.moodCartDatePurch.month, cart.moodCartDatePurch.day) == date).toList())}',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            groupItemBuilder: (context, element, groupStart, groupEnd) {
              return Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: ColorG.grey,
                      width: 1.h,
                    ),
                  ),
                  borderRadius: groupStart && groupEnd
                      ? BorderRadius.circular(15.r)
                      : groupStart
                          ? BorderRadius.only(
                              topLeft: Radius.circular(15.r),
                              topRight: Radius.circular(15.r),
                            )
                          : groupEnd
                              ? BorderRadius.only(
                                  bottomLeft: Radius.circular(15.r),
                                  bottomRight: Radius.circular(15.r),
                                )
                              : BorderRadius.circular(15.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (element.moodCartCategory.icon.isNotEmpty)
                          SvgPicture.asset(
                            element.moodCartCategory.icon,
                            height: 20.sp,
                          ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            element.moodCartName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          '\$${element.moodCartPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          getMoodIcon(element.firstMood.moodName),
                          color: Colors.black,
                          size: 20.sp,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            element.firstMood.moodName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            order: GroupedListOrder.DESC,
          );
        },
      ),
    );
  }

  String _calculateDayTotal(List<MoodCart> dayPurchases) {
    final total = dayPurchases.fold<double>(
      0,
      (sum, cart) => sum + cart.moodCartPrice,
    );
    return total.toStringAsFixed(2);
  }
}
