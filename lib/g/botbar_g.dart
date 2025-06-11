import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/color_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/moti_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/mood.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/spend.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/sssettingsss.dart';

class GBotomBar extends StatefulWidget {
  const GBotomBar({super.key, this.indexScr = 0});
  final int indexScr;

  @override
  State<GBotomBar> createState() => GBotomBarState();
}

class GBotomBarState extends State<GBotomBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexScr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 100.h,
        width: double.infinity,
        padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 40.h),
        decoration: BoxDecoration(
          color: ColorG.white,
          border: Border(
              top: BorderSide(
            color: Colors.white.withOpacity(0.1),
          )),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: buildNavItem(0, 'assets/icons/1.png',
                    'assets/icons/11.png', 'Mood Cart')),
            Expanded(
                child: buildNavItem(1, 'assets/icons/2.png',
                    'assets/icons/22.png', 'Spend Flow')),
            Expanded(
                child: buildNavItem(2, 'assets/icons/3.png',
                    'assets/icons/33.png', 'Settings')),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(int index, String iconPath, String icon, String t) {
    bool isActive = _currentIndex == index;

    return GMotiBut(
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: isActive
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconPath,
                      width: 26.w,
                      height: 26.h,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      t,
                      style: TextStyle(
                        color: ColorG.blueE,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        height: 1.sp,
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Image.asset(
                  icon,
                  width: 26.w,
                  height: 26.h,
                ),
              ),
      ),
    );
  }

  final _pages = <Widget>[
    const Mood(),
    const Spend(),
    const Sssettingsss(),
  ];
}
