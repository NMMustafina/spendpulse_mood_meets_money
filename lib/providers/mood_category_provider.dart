import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_cart.dart';

class MoodCategoryProvider with ChangeNotifier {
  List<MoodCartCategory> _categories = [];
  static const String _storageKey = 'mood_categories_data';

  static const List<MoodCartCategory> _defaultCategories = [
    MoodCartCategory(
      isCustom: false,
      id: 1,
      icon: 'assets/icons/food.svg',
      name: 'Food',
    ),
    MoodCartCategory(
      isCustom: false,
      id: 2,
      icon: 'assets/icons/shopping.svg',
      name: 'Shopping',
    ),
    MoodCartCategory(
      isCustom: false,
      id: 3,
      icon: 'assets/icons/entertainment.svg',
      name: 'Entertainment',
    ),
    MoodCartCategory(
      isCustom: false,
      id: 4,
      icon: 'assets/icons/electronics.svg',
      name: 'Electronics',
    ),
    MoodCartCategory(
      isCustom: false,
      id: 5,
      icon: 'assets/icons/other.svg',
      name: 'Other',
    ),
  ];

  MoodCategoryProvider() {
    _loadCategories();
  }

  List<MoodCartCategory> get categories => _categories;
  List<MoodCartCategory> get defaultCategories => _defaultCategories;

  Future<void> _loadCategories() async {
    final ghggkk = await SharedPreferences.getInstance();

    final String? jsonStr = ghggkk.getString(_storageKey);
    if (jsonStr != null) {
      final List<dynamic> jsonList = json.decode(jsonStr);
      _categories =
          jsonList.map((json) => MoodCartCategory.fromJson(json)).toList();
    } else {
      _categories = List.from(_defaultCategories);
    }
    notifyListeners();
  }

  Future<void> _saveCategories() async {
    final ghggkk = await SharedPreferences.getInstance();

    final String jsonStr =
        json.encode(_categories.map((cat) => cat.toJson()).toList());
    await ghggkk.setString(_storageKey, jsonStr);
  }

  Future<void> addOrUpdateCategory(MoodCartCategory category) async {
    if (!category.isCustom) {
      return;
    }

    final index = _categories.indexWhere((cat) => cat.id == category.id);
    if (index >= 0) {
      _categories[index] = category;
    } else {
      _categories.add(category);
    }
    await _saveCategories();
    notifyListeners();
  }

  Future<void> deleteCategory(int categoryId) async {
    final category = _categories.firstWhere((cat) => cat.id == categoryId);
    if (!category.isCustom) {
      return;
    }

    _categories.removeWhere((cat) => cat.id == categoryId);
    await _saveCategories();
    notifyListeners();
  }

  int generateNewCategoryId() {
    if (_categories.isEmpty) return _defaultCategories.length + 1;
    return _categories
            .map((cat) => cat.id)
            .reduce((max, id) => id > max ? id : max) +
        1;
  }
}
