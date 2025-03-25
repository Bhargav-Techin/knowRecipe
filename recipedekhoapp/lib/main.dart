import 'package:flutter/material.dart';
import 'package:recipedekhoapp/pages/auth_page.dart';
import 'package:recipedekhoapp/pages/home_page.dart';
import 'package:recipedekhoapp/pages/my_recipe_page.dart';
import 'package:recipedekhoapp/widgets/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecipeDekho',
      theme: ThemeData(
        primaryColor: const Color(0xFF810081),
        scaffoldBackgroundColor: const Color(0xFF252525),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF810081),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFF810081),
          foregroundColor: const Color(0xFFFFD7F5),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFABF3),
            foregroundColor: const Color(0xFF5B005B),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFFFFABF3),
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/auth': (context) => AuthPage(),
        '/home': (context) => HomePage(),
        '/my-recipes': (context) => MyRecipesPage(),
      },
    );
  }
}
