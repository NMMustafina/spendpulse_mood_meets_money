import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../g/color_g.dart';
import '../g/moti_g.dart';
import '../models/limit.dart';
import '../providers/limit_provider.dart';
import 'add_edit_limit_page.dart';

class LimitsPage extends StatelessWidget {
  const LimitsPage({super.key});

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
          'Limits',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<LimitProvider>(
        builder: (context, limitProvider, child) {
          if (limitProvider.limits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/siren.svg',
                    height: 64.sp,
                    width: 64.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'You have no limits yet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: limitProvider.limits.length,
            itemBuilder: (context, index) {
              final limit = limitProvider.limits[index];
              return nnhhh(context, limit);
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GMotiBut(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: ColorG.blueE,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create limit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8.w),
              const Icon(Icons.add, color: Colors.white),
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditLimitPage(),
            ),
          );
        },
      ),
    );
  }

  Widget nnhhh(BuildContext context, Limit limit) {
    final isExpired = limit.isExpired;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (limit.category.icon.isNotEmpty)
                SvgPicture.asset(
                  limit.category.icon,
                  height: 24.sp,
                  width: 24.sp,
                ),
              if (limit.category.icon.isNotEmpty) SizedBox(width: 8.w),
              Text(
                limit.category.name,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz),
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditLimitPage(limit: limit),
                      ),
                    );
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, limit);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit, color: Colors.black),
                        SizedBox(width: 8.w),
                        const Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8.w),
                        const Text('Delete',
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/dollar.png',
                height: 24.sp,
                width: 24.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Limit amount: \$${limit.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: isExpired ? Colors.red : Colors.black,
                      ),
                    ),
                    Text(
                      '\$${limit.remainingAmount.toStringAsFixed(2)} left',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: isExpired ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              SvgPicture.asset('assets/icons/alarm.svg'),
              SizedBox(width: 8.w),
              Text(
                'Valid until ${DateFormat('MMMM dd, yyyy').format(limit.endDate)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: DateTime.now().isAfter(limit.endDate)
                      ? Colors.red
                      : Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Limit limit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Limit'),
          content: const Text('Are you sure you want to delete this limit?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                context.read<LimitProvider>().deleteLimit(limit.limitId);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
