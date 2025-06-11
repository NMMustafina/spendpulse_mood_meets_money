import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/color_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/dok_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/moti_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/pro_m.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/premasdf.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/speednapumoode.dart';

class Sssettingsss extends StatelessWidget {
  const Sssettingsss({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getSpenpulseMood(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                'Settings',
                style: TextStyle(
                  color: ColorG.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 28.sp,
                  height: 1.sp,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  if (snapshot.data == false)
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/s_pr.png',
                        ),
                        Positioned(
                          top: 12,
                          bottom: 12,
                          right: 20,
                          left: 20,
                          child: Column(
                            children: [
                              const Spacer(flex: 10),
                              GMotiBut(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Premasdf(
                                        isAs: true,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFF1068EC),
                                  ),
                                  child: Center(
                                    child: Text(
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
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  GMotiBut(
                    onPressed: () {
                      lauchUrl(context, DokG.priPoli);
                    },
                    child: Image.asset(
                      'assets/images/s1.png',
                    ),
                  ),
                  const SizedBox(height: 16),
                  GMotiBut(
                    onPressed: () {
                      lauchUrl(context, DokG.terOfUse);
                    },
                    child: Image.asset(
                      'assets/images/s2.png',
                    ),
                  ),
                  const SizedBox(height: 16),
                  GMotiBut(
                    onPressed: () {
                      lauchUrl(context, DokG.suprF);
                    },
                    child: Image.asset(
                      'assets/images/s3.png',
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
