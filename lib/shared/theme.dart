import 'package:flutter/material.dart';

class ThemeComponents {
  ThemeComponents._();

  static EdgeInsets get defaultPadding => const EdgeInsets.all(16);
  static EdgeInsets get largePadding => const EdgeInsets.all(48);
  static double get smallSpacing => 4;
  static double get mediumSpacing => 8;
  static double get defaultSpacing => 16;
  static double get largeSpacing => 24;
}

ThemeData get light {
  const branding = Colors.pink;
  final base = ThemeData(primaryColor: branding);

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: branding,
      secondary: branding,
    ),
    appBarTheme: base.appBarTheme.copyWith(
      color: Colors.white,
      foregroundColor: branding,
    ),
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: branding,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
    ),
  );
}
