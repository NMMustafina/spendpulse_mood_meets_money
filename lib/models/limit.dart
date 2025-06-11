import '../models/mood_cart.dart';

class Limit {
  final int limitId;
  final double amount;
  final MoodCartCategory category;
  final DateTime endDate;
  final bool includeCurrentItems;
  final double spentAmount;

  const Limit({
    required this.limitId,
    required this.amount,
    required this.category,
    required this.endDate,
    required this.includeCurrentItems,
    this.spentAmount = 0,
  });

  Map<String, dynamic> toJson() => {
        'limitId': limitId,
        'amount': amount,
        'category': category.toJson(),
        'endDate': endDate.toIso8601String(),
        'includeCurrentItems': includeCurrentItems,
        'spentAmount': spentAmount,
      };

  factory Limit.fromJson(Map<String, dynamic> json) => Limit(
        limitId: json['limitId'] as int,
        amount: json['amount'] as double,
        category:
            MoodCartCategory.fromJson(json['category'] as Map<String, dynamic>),
        endDate: DateTime.parse(json['endDate'] as String),
        includeCurrentItems: json['includeCurrentItems'] as bool,
        spentAmount: json['spentAmount'] as double? ?? 0,
      );

  Limit copyWith({
    int? limitId,
    double? amount,
    MoodCartCategory? category,
    DateTime? endDate,
    bool? includeCurrentItems,
    double? spentAmount,
  }) {
    return Limit(
      limitId: limitId ?? this.limitId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      endDate: endDate ?? this.endDate,
      includeCurrentItems: includeCurrentItems ?? this.includeCurrentItems,
      spentAmount: spentAmount ?? this.spentAmount,
    );
  }

  double get remainingAmount => amount - spentAmount;
  bool get isExpired => DateTime.now().isAfter(endDate);
  double get progress => spentAmount / amount;
}
