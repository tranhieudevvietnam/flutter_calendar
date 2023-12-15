import 'package:flutter/material.dart';
import 'package:flutter_calendar/gen/colors.gen.dart';
import 'package:flutter_calendar/module/wellcome/page_wellcome.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', "VN"), // Vietnam
        // Locale('en', "US"), // English
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorName.primary),
        useMaterial3: true,
      ),
      home: const PageWelCome(),
    );
  }
}
