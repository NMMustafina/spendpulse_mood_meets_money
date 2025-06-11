import 'package:flutter/material.dart';
import 'package:spendpulse_mood_meets_money_208_t/sdsa_scr/emotions_category_tile.dart';

import '../models/mood_cart.dart';

class EmotionsCategoryList extends StatefulWidget {
  final List<MoodCart> carts;

  const EmotionsCategoryList(this.carts, {super.key});

  @override
  State<EmotionsCategoryList> createState() => _EmotionsCategoryListState();
}

class _EmotionsCategoryListState extends State<EmotionsCategoryList> {
  String? expandedCategory;

  @override
  Widget build(BuildContext context) {
    final Map<String, List<MoodCart>> grouped = {};

    for (final cart in widget.carts) {
      final category = cart.moodCartCategory.name;
      grouped.putIfAbsent(category, () => []).add(cart);
    }

    final items = grouped.entries.toList()
      ..sort((a, b) => b.value
          .fold(0.0, (sum, e) => sum + e.moodCartPrice)
          .compareTo(a.value.fold(0.0, (sum, e) => sum + e.moodCartPrice)));

    return Column(
      children: items.map((entry) {
        return EmotionsCategoryTile(
          categoryName: entry.key,
          carts: entry.value,
          isExpanded: expandedCategory == entry.key,
          onTap: () {
            setState(() {
              expandedCategory =
                  expandedCategory == entry.key ? null : entry.key;
            });
          },
        );
      }).toList(),
    );
  }
}
