import 'package:campsite/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Utils.prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campsite App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        chipTheme: ChipThemeData(backgroundColor: Colors.white),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.amber,
        primaryColor: Colors.white,
        primaryColorLight: Colors.white,
        shadowColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
      ),
      localizationsDelegates: [
        LocaleNamesLocalizationsDelegate(),
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
        Locale('fr'),
      ],
      home: HomeView(),
    );
  }
}
