import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/limit.dart';
import '../models/mood_cart.dart';

class LimitProvider with ChangeNotifier {
  List<Limit> _limits = [];
  static const String _storageKey = 'limits_data';

  LimitProvider() {
    _loadLimits();
  }

  List<Limit> get limits => _limits;

  Future<void> _loadLimits() async {
    final htuik = await SharedPreferences.getInstance();
    final String? jjssvb = htuik.getString(_storageKey);
    if (jjssvb != null) {
      final List<dynamic> jsonList = json.decode(jjssvb);
      _limits = jsonList.map((json) => Limit.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveLimits() async {
    final htuik = await SharedPreferences.getInstance();
    final String jjssvb =
        json.encode(_limits.map((limit) => limit.toJson()).toList());
    await htuik.setString(_storageKey, jjssvb);
  }

  bool hasLimitForCategory(MoodCartCategory category) {
    return _limits
        .any((limit) => limit.category.id == category.id && !limit.isExpired);
  }

  Future<void> addLimit(Limit limit) async {
    if (hasLimitForCategory(limit.category)) {
      throw Exception('A limit for this category already exists');
    }
    _limits.add(limit);
    await _saveLimits();
    notifyListeners();
  }

  Future<void> updateLimit(Limit limit) async {
    final index = _limits.indexWhere((l) => l.limitId == limit.limitId);
    if (index >= 0) {
      _limits[index] = limit;
      await _saveLimits();
      notifyListeners();
    }
  }

  Future<void> deleteLimit(int limitId) async {
    _limits.removeWhere((limit) => limit.limitId == limitId);
    await _saveLimits();
    notifyListeners();
  }

  Future<void> updateSpentAmount(
      MoodCartCategory category, double amount) async {
    final limitIndex = _limits.indexWhere(
        (limit) => limit.category.id == category.id && !limit.isExpired);

    if (limitIndex >= 0) {
      final limit = _limits[limitIndex];
      _limits[limitIndex] = limit.copyWith(
        spentAmount: limit.spentAmount + amount,
      );
      await _saveLimits();
      notifyListeners();
    }
  }

  int generateNewLimitId() {
    if (_limits.isEmpty) return 1;
    return _limits
            .map((limit) => limit.limitId)
            .reduce((max, id) => id > max ? id : max) +
        1;
  }
}
