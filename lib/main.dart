import 'package:easy_pro/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const EasyProApp());
}

class EasyProApp extends StatelessWidget {
  const EasyProApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      primaryColor: const Color(0xFF006B9F),
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF006B9F), width: 2),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        textTheme: GoogleFonts.promptTextTheme(baseTheme.textTheme).copyWith(
          displayLarge: GoogleFonts.prompt(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.prompt(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.prompt(
            fontSize: 16,
          ),
        ),
      ),
      // home: const LoginScreen(),
      home: MainScreen(),
    );
  }
}
