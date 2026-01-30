import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF19C870);
const Color kBackground = Color(0xFFF9FBF9);
const Color kTextDark = Color(0xFF1F2A1F);
const Color kTextMuted = Color(0xFF7A847A);

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
    scaffoldBackgroundColor: kBackground,
    useMaterial3: true,
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 15),
      bodySmall: TextStyle(fontSize: 13),
    ),
  );
}
