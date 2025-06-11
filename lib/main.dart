import 'package:apphud/apphud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/color_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/dok_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/g/onb_g.dart';
import 'package:spendpulse_mood_meets_money_208_t/providers/selected_month_provider.dart';

import 'providers/limit_provider.dart';
import 'providers/mood_cart_provider.dart';
import 'providers/mood_category_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoodCartProvider()),
        ChangeNotifierProvider(create: (_) => MoodCategoryProvider()),
        ChangeNotifierProvider(create: (_) => LimitProvider()),
      ],
      child: const MyApp(),
    ),
  );
  await Apphud.start(apiKey: DokG.aPpHdKF);
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MoodCategoryProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => MoodCartProvider(),
          ),
          ChangeNotifierProvider(create: (_) => SelectedMonthProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SpendPulse',
          theme: ThemeData(
            scaffoldBackgroundColor: ColorG.background,
            appBarTheme: const AppBarTheme(
              backgroundColor: ColorG.background,
            ), // fontFamily: '-_- ??',
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          home: const GOnBoDi(),
        ),
      ),
    );
  }
}
