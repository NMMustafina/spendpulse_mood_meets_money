import 'dart:convert';
import 'dart:typed_data';

class Mood {
  final int moodId;
  final String moodName;
  final DateTime moodDate;
  final String moodDescription;

  const Mood({
    required this.moodId,
    required this.moodName,
    required this.moodDate,
    required this.moodDescription,
  });

  Map<String, dynamic> toJson() => {
        'moodId': moodId,
        'moodName': moodName,
        'moodDate': moodDate.toIso8601String(),
        'moodDescription': moodDescription,
      };

  factory Mood.fromJson(Map<String, dynamic> json) => Mood(
        moodId: json['moodId'] as int,
        moodName: json['moodName'] as String,
        moodDate: DateTime.parse(json['moodDate'] as String),
        moodDescription: json['moodDescription'] as String,
      );

  Mood copyWith({
    int? moodId,
    String? moodName,
    DateTime? moodDate,
    String? moodDescription,
  }) {
    return Mood(
      moodId: moodId ?? this.moodId,
      moodName: moodName ?? this.moodName,
      moodDate: moodDate ?? this.moodDate,
      moodDescription: moodDescription ?? this.moodDescription,
    );
  }
}

class MoodCartCategory {
  final bool isCustom;
  final int id;
  final String icon;
  final String name;

  const MoodCartCategory({
    required this.isCustom,
    required this.id,
    required this.icon,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'isCustom': isCustom,
        'id': id,
        'icon': icon,
        'name': name,
      };

  factory MoodCartCategory.fromJson(Map<String, dynamic> json) =>
      MoodCartCategory(
        isCustom: json['isCustom'] as bool,
        id: json['id'] as int,
        icon: json['icon'] as String,
        name: json['name'] as String,
      );

  MoodCartCategory copyWith({
    bool? isCustom,
    int? id,
    String? icon,
    String? name,
  }) {
    return MoodCartCategory(
      isCustom: isCustom ?? this.isCustom,
      id: id ?? this.id,
      icon: icon ?? this.icon,
      name: name ?? this.name,
    );
  }
}

class MoodCart {
  final int moodCartId;
  final Uint8List? moodCartPhoto;
  final String moodCartName;
  final double moodCartPrice;
  final MoodCartCategory moodCartCategory;
  final String moodCartDescription;
  final DateTime moodCartDatePurch;
  final Mood firstMood;
  final List<Mood> allMood;

  const MoodCart({
    required this.moodCartId,
    this.moodCartPhoto,
    required this.moodCartName,
    required this.moodCartPrice,
    required this.moodCartCategory,
    required this.moodCartDescription,
    required this.moodCartDatePurch,
    required this.firstMood,
    required this.allMood,
  });

  // JSON serialization
  Map<String, dynamic> toJson() => {
        'moodCartId': moodCartId,
        'moodCartPhoto':
            moodCartPhoto != null ? base64Encode(moodCartPhoto!) : null,
        'moodCartName': moodCartName,
        'moodCartPrice': moodCartPrice,
        'moodCartCategory': moodCartCategory.toJson(),
        'moodCartDescription': moodCartDescription,
        'moodCartDatePurch': moodCartDatePurch.toIso8601String(),
        'firstMood': firstMood.toJson(),
        'allMood': allMood.map((mood) => mood.toJson()).toList(),
      };

  factory MoodCart.fromJson(Map<String, dynamic> json) => MoodCart(
        moodCartId: json['moodCartId'] as int,
        moodCartPhoto: json['moodCartPhoto'] != null
            ? base64Decode(json['moodCartPhoto'] as String)
            : null,
        moodCartName: json['moodCartName'] as String,
        moodCartPrice: (json['moodCartPrice'] as num).toDouble(),
        moodCartCategory: MoodCartCategory.fromJson(
            json['moodCartCategory'] as Map<String, dynamic>),
        moodCartDescription: json['moodCartDescription'] as String,
        moodCartDatePurch: DateTime.parse(json['moodCartDatePurch'] as String),
        firstMood: Mood.fromJson(json['firstMood'] as Map<String, dynamic>),
        allMood: (json['allMood'] as List<dynamic>)
            .map((e) => Mood.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  MoodCart copyWith({
    int? moodCartId,
    Uint8List? moodCartPhoto,
    String? moodCartName,
    double? moodCartPrice,
    MoodCartCategory? moodCartCategory,
    String? moodCartDescription,
    DateTime? moodCartDatePurch,
    Mood? firstMood,
    List<Mood>? allMood,
  }) {
    return MoodCart(
      moodCartId: moodCartId ?? this.moodCartId,
      moodCartPhoto: moodCartPhoto ?? this.moodCartPhoto,
      moodCartName: moodCartName ?? this.moodCartName,
      moodCartPrice: moodCartPrice ?? this.moodCartPrice,
      moodCartCategory: moodCartCategory ?? this.moodCartCategory,
      moodCartDescription: moodCartDescription ?? this.moodCartDescription,
      moodCartDatePurch: moodCartDatePurch ?? this.moodCartDatePurch,
      firstMood: firstMood ?? this.firstMood,
      allMood: allMood ?? this.allMood,
    );
  }
}
