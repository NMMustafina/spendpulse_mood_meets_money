import 'package:flutter/material.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/mood_utils.dart';

import '../../../models/mood_cart.dart';

Widget buildMoodCircle(List<MoodCart> carts, DateTime day) {
  final allMoods = carts.expand((e) => e.allMood).toList();
  final moodNames = allMoods.map((e) => e.moodName).toList();
  final avgScore = getAverageMoodScore(moodNames);
  final color = getMoodColor(avgScore);

  return Container(
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
    margin: const EdgeInsets.all(6),
    alignment: Alignment.center,
    child: Text(
      '${day.day}',
      style: const TextStyle(color: Colors.white),
    ),
  );
}
