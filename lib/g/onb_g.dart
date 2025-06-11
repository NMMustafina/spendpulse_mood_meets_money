import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/color_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/moti_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/premasdf.dart';

class GOnBoDi extends StatefulWidget {
  const GOnBoDi({super.key});

  @override
  State<GOnBoDi> createState() => _GOnBoDiState();
}

class _GOnBoDiState extends State<GOnBoDi> {
  final PageController _controller = PageController();
  int introIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorG.white,
      body: Stack(
        children: [
          PageView(
            physics: const ClampingScrollPhysics(),
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                introIndex = index;
              });
            },
            children: const [
              OnWid(
                image: '1',
              ),
              OnWid(
                image: '2',
              ),
              OnWid(
                image: '3',
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 700.h),
            child: GMotiBut(
              onPressed: () {
                if (introIndex != 2) {
                  _controller.animateToPage(
                    introIndex + 1,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.ease,
                  );
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Premasdf(),
                    ),
                    (protected) => false,
                  );
                }
              },
              child: Container(
                height: 55.h,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF1068EC),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        color: ColorG.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        height: 1.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnWid extends StatelessWidget {
  const OnWid({
    super.key,
    required this.image,
  });
  final String image;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Image.asset(
        'assets/images/on$image.png',
        height: 700.h,
        width: 305.w,
        fit: BoxFit.cover,
        // alignment: Alignment.bottomCenter,
      ),
    );
  }
}
