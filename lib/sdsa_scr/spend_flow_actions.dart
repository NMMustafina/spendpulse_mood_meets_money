import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/month_picker_dialog.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/weekly_wins_page.dart';

import '../g/moti_g.dart';
import '../providers/selected_month_provider.dart';
import '../sdsa_scr/premasdf.dart';
import '../sdsa_scr/speednapumoode.dart';

class SpendFlowActions extends StatelessWidget {
  const SpendFlowActions({super.key});

  @override
  Widget build(BuildContext context) {
    final monthProvider = context.watch<SelectedMonthProvider>();
    final hasMultipleMonths = monthProvider.availableMonths.length > 1;

    return Row(
      children: [
        FutureBuilder<bool>(
          future: getSpenpulseMood(),
          builder: (context, snapshot) {
            final isPremium = snapshot.data == true;

            return GMotiBut(
              onPressed: () {
                if (isPremium) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WeeklyWinsPage()),
                  );
                } else {
                  showCupertinoDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      title: const Text('Premium is required'),
                      content: const Text(
                          'You can’t use “Weekly wins” page without premium'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('No'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        CupertinoDialogAction(
                          child: const Text('Premium'),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Premasdf(isAs: true),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
              child: SvgPicture.asset(
                isPremium
                    ? 'assets/icons/kubk.svg'
                    : 'assets/icons/kubkprm.svg',
                height: 28.sp,
                width: 28.sp,
              ),
            );
          },
        ),
        SizedBox(width: 12.w),
        GMotiBut(
          onPressed: hasMultipleMonths
              ? () {
                  showDialog(
                    context: context,
                    builder: (_) => MonthPickerDialog(
                      initialDate: monthProvider.selectedMonth,
                      availableDates: monthProvider.availableMonths,
                      onSelected: (date) {
                        context.read<SelectedMonthProvider>().setMonth(date);
                      },
                    ),
                  );
                }
              : null,
          child: SvgPicture.asset(
            'assets/icons/calendar_search.svg',
            height: 28.sp,
            width: 28.sp,
            color: hasMultipleMonths ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }
}
