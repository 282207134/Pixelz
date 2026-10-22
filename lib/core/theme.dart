import 'package:flutter/material.dart';

abstract final class Palette {
  static const background = Color(0xFF1D1D1D);
  static const surface = Color(0xFF252525);
  static const border = Color(0xFF393939);
  static const text = Color(0xFFF2F2F2);
  static const muted = Color(0xFF929292);
  static const accent = Color(0xFF8D85F7);
  static const light = Color(0xFFD0D7D7);
  static const green = Color(0xFF3BB54A);
  static const red = Color(0xFFFF4D50);
  static const gold = Color(0xFFE7A516);
}

ThemeData pixelzTheme() => ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Inter',
  scaffoldBackgroundColor: Palette.background,
  colorScheme: const ColorScheme.dark(
    primary: Palette.accent,
    surface: Palette.surface,
    onSurface: Palette.text,
    error: Palette.red,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 14, height: 1.4),
    bodySmall: TextStyle(fontSize: 12, height: 1.45, color: Palette.muted),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Palette.background,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
    toolbarHeight: 64,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
  dividerTheme: const DividerThemeData(color: Palette.border, space: 1),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    hintStyle: const TextStyle(color: Palette.muted, fontSize: 13),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Palette.muted),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Palette.accent),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: Palette.accent,
      foregroundColor: Palette.text,
      minimumSize: const Size(double.infinity, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Palette.accent),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Palette.light,
    contentTextStyle: TextStyle(color: Palette.background),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Palette.surface,
    shape: RoundedRectangleBorder(),
  ),
);
