// ignore_for_file: use_build_context_synchronously

import 'package:apphud/apphud.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/botbar_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/dok_g.dart';

Future<void> setSpenpulseMood() async {
  final spenpulseMoodset = await SharedPreferences.getInstance();
  spenpulseMoodset.setBool('SpenpulseMoodSpenpulseMood', true);
}

Future<bool> getSpenpulseMood() async {
  final spenpulseMoodset = await SharedPreferences.getInstance();
  return spenpulseMoodset.getBool('SpenpulseMoodSpenpulseMood') ?? false;
}

Future<void> spenpulseMoodRes(BuildContext context) async {
  final spenpulseMoodResAccess = await Apphud.hasPremiumAccess();
  final spenpulseMoodResActiveSubs = await Apphud.hasActiveSubscription();
  if (spenpulseMoodResAccess || spenpulseMoodResActiveSubs) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("SpenpulseMoodSpenpulseMood", true);
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Success!'),
        content: const Text('Your purchase has been restored!'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const GBotomBar(
                    indexScr: 0,
                  ),
                ),
                (route) => false,
              );
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Restore purchase'),
        content: const Text(
            'Your purchase is not found. Write to support: ${DokG.aPpHdKF}'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => {Navigator.of(context).pop()},
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
