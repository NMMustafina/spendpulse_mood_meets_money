import 'package:apphud/apphud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/botbar_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/color_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/dok_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/moti_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/pro_m.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/speednapumoode.dart';

class Premasdf extends StatefulWidget {
  const Premasdf({super.key, this.isAs = false});
  final bool isAs;

  @override
  State<Premasdf> createState() => _PremasdfState();
}

class _PremasdfState extends State<Premasdf> {
  bool issssff = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorG.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/prem.png')),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GMotiBut(
                      onPressed: () {
                        spenpulseMoodRes(context);
                      },
                      child: Text(
                        'Restore Purchase',
                        style: TextStyle(
                          color: ColorG.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          height: 1.sp,
                        ),
                      ),
                    ),
                    GMotiBut(
                      onPressed: () {
                        if (widget.isAs) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GBotomBar(),
                            ),
                            (protected) => false,
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/images/x.png',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GMotiBut(
                onPressed: () async {
                  setState(() {
                    issssff = true;
                  });
                  final rerrr = await Apphud.placements();
                  print(rerrr);

                  await Apphud.purchase(
                          product: rerrr.first.paywall?.products?.first)
                      .whenComplete(
                    () async {
                      if (await Apphud.hasPremiumAccess() ||
                          await Apphud.hasActiveSubscription()) {
                        await setSpenpulseMood();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GBotomBar(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  );
                  setState(() {
                    issssff = false;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF1068EC),
                  ),
                  child: Center(
                    child: issssff
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(
                            'Get Premium',
                            style: TextStyle(
                              color: ColorG.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              height: 1.sp,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GMotiBut(
                    onPressed: () {
                      lauchUrl(context, DokG.terOfUse);
                    },
                    child: Text(
                      'Terms of use',
                      style: TextStyle(
                        color: ColorG.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        height: 1.sp,
                      ),
                    ),
                  ),
                  GMotiBut(
                    onPressed: () {
                      lauchUrl(context, DokG.priPoli);
                    },
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: ColorG.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        height: 1.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
