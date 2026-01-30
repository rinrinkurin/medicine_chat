import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF18C76A);
const Color kBackground = Color(0xFFF7F9F7);
const Color kTextDark = Color(0xFF1A1E1A);
const Color kTextMuted = Color(0xFF7C857C);

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
    scaffoldBackgroundColor: kBackground,
    useMaterial3: true,
  );
}
