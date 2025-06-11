import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_cart.dart';

class MoodCartProvider with ChangeNotifier {
  List<MoodCart> _moodCarts = [];
  static const String _storageKey = 'mood_carts_data';

  MoodCartProvider() {
    _llodMoodCarts();
  }

  List<MoodCart> get moodCarts => _moodCarts;

  Future<void> _llodMoodCarts() async {
    final ghggkk = await SharedPreferences.getInstance();
    final String? jsonStr = ghggkk.getString(_storageKey);
    if (jsonStr != null) {
      final List<dynamic> jsonList = json.decode(jsonStr);
      _moodCarts = jsonList.map((json) => MoodCart.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _ssveMoodCarts() async {
    final ghggkk = await SharedPreferences.getInstance();
    final String jsonStr =
        json.encode(_moodCarts.map((cart) => cart.toJson()).toList());
    await ghggkk.setString(_storageKey, jsonStr);
  }

  Future<void> addOrUpdateMoodCart(MoodCart moodCart) async {
    final index =
        _moodCarts.indexWhere((cart) => cart.moodCartId == moodCart.moodCartId);
    if (index >= 0) {
      _moodCarts[index] = moodCart;
    } else {
      _moodCarts.add(moodCart);
    }
    await _ssveMoodCarts();
    notifyListeners();
  }

  Future<void> deleteMoodCart(int moodCartId) async {
    _moodCarts.removeWhere((cart) => cart.moodCartId == moodCartId);
    await _ssveMoodCarts();
    notifyListeners();
  }

  Future<void> addMoodToCart(int moodCartId, Mood mood) async {
    final cartIndex =
        _moodCarts.indexWhere((cart) => cart.moodCartId == moodCartId);
    if (cartIndex >= 0) {
      final cart = _moodCarts[cartIndex];
      final updatedMoods = List<Mood>.from(cart.allMood)..add(mood);
      _moodCarts[cartIndex] = cart.copyWith(allMood: updatedMoods);
      await _ssveMoodCarts();
      notifyListeners();
    }
  }

  Future<void> updateMoodInCart(int moodCartId, Mood updatedMood) async {
    final cartIndex =
        _moodCarts.indexWhere((cart) => cart.moodCartId == moodCartId);
    if (cartIndex >= 0) {
      final cart = _moodCarts[cartIndex];
      final moodIndex =
          cart.allMood.indexWhere((m) => m.moodId == updatedMood.moodId);
      if (moodIndex >= 0) {
        final updatedMoods = List<Mood>.from(cart.allMood);
        updatedMoods[moodIndex] = updatedMood;
        _moodCarts[cartIndex] = cart.copyWith(allMood: updatedMoods);
        await _ssveMoodCarts();
        notifyListeners();
      }
    }
  }

  Future<void> deleteMoodFromCart(int moodCartId, int moodId) async {
    final cartIndex =
        _moodCarts.indexWhere((cart) => cart.moodCartId == moodCartId);
    if (cartIndex >= 0) {
      final cart = _moodCarts[cartIndex];
      final updatedMoods =
          cart.allMood.where((mood) => mood.moodId != moodId).toList();
      _moodCarts[cartIndex] = cart.copyWith(allMood: updatedMoods);
      await _ssveMoodCarts();
      notifyListeners();
    }
  }
}
