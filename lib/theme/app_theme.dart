import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF19C870);
const Color kBackground = Color(0xFFF9FBF9);
const Color kTextDark = Color(0xFF1F2A1F);
const Color kTextMuted = Color(0xFF7A847A);
const double kFontTitle = 26;
const double kFontSection = 24;
const double kFontBody = 18;
const double kFontSmall = 16;

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
    scaffoldBackgroundColor: kBackground,
    useMaterial3: true,
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: kFontTitle, fontWeight: FontWeight.w700),
      titleMedium:
          TextStyle(fontSize: kFontSection, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontSize: kFontBody, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: kFontBody),
      bodyMedium: TextStyle(fontSize: kFontBody),
      bodySmall: TextStyle(fontSize: kFontSmall),
    ),
  );
}
