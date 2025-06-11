import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/mood_cart.dart';

class EmotionsChangeSummary extends StatelessWidget {
  final List<MoodCart> carts;

  const EmotionsChangeSummary(this.carts, {super.key});

  @override
  Widget build(BuildContext context) {
    int totalChanges = 0;
    int improved = 0;
    int worsened = 0;

    for (final cart in carts) {
      final changes = cart.allMood.length - 1;
      if (changes > 0) {
        totalChanges += changes;
        final firstMoodScore = _score(cart.firstMood.moodName);
        for (int i = 1; i < cart.allMood.length; i++) {
          final newScore = _score(cart.allMood[i].moodName);
          if (newScore > firstMoodScore) improved++;
          if (newScore < firstMoodScore) worsened++;
        }
      }
    }

    if (totalChanges == 0) return const SizedBox();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: _buildChangeTile(
                  '$totalChanges', 'Changed your\nmind about the purchase')),
          Expanded(
              child: _buildChangeTile('$improved', 'Opinion has\nimproved')),
          Expanded(
              child: _buildChangeTile('$worsened', 'Opinion has\nworsened')),
        ],
      ),
    );
  }

  Widget _buildChangeTile(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$value times',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  int _score(String moodName) {
    const order = ['Angry', 'Sad', 'Neutral', 'Joyful', 'Happy'];
    return order.indexOf(moodName);
  }
}
