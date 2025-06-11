import 'package:flutter/material.dart';

int getMoodScore(String moodName) {
  switch (moodName.toLowerCase()) {
    case 'angry':
      return 1;
    case 'sad':
      return 2;
    case 'neutral':
      return 3;
    case 'joyful':
      return 4;
    case 'happy':
      return 5;
    default:
      return 3;
  }
}

Color getMoodColor(int moodScore) {
  switch (moodScore) {
    case 1:
      return const Color(0xFFED0F0F);
    case 2:
      return const Color(0xFFEE7F1E);
    case 3:
      return const Color(0xFFEDF419);
    case 4:
      return const Color(0xFF58F012);
    case 5:
      return const Color(0xFF21FFB9);
    default:
      return Colors.grey;
  }
}

int getAverageMoodScore(List<String> moodNames) {
  if (moodNames.isEmpty) return 3;
  final total = moodNames.map(getMoodScore).reduce((a, b) => a + b);
  return (total / moodNames.length).floor();
}
