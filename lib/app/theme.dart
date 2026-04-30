import 'package:flutter/material.dart';

ThemeData buildOpenMusicTheme() {
  const seed = Color(0xFF1DB954);
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  ).copyWith(
    surface: const Color(0xFF111318),
    surfaceContainerHighest: const Color(0xFF1A1E25),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color(0xFF0B0D10),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: Color(0xFF0B0D10),
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF111318),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    chipTheme: ChipThemeData.fromDefaults(
      secondaryColor: seed,
      labelStyle: const TextStyle(color: Colors.white),
      brightness: Brightness.dark,
    ),
    textTheme: Typography.whiteMountainView,
  );
}
