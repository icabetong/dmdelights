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
  const font = 'Poppins';
  const branding600 = Color(0xffdb2777);
  const branding400 = Color(0xfff472b6);
  const text800 = Color(0xff334155);
  final base = ThemeData(primaryColor: branding600, fontFamily: font);

  return base.copyWith(
    toggleableActiveColor: branding600,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: base.colorScheme.copyWith(
      primary: branding600,
      secondary: branding600,
    ),
    appBarTheme: base.appBarTheme.copyWith(
      color: Colors.white,
      foregroundColor: text800,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        fontFamily: font,
        color: text800,
      ),
    ),
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: branding600,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
    ),
    drawerTheme: base.drawerTheme.copyWith(backgroundColor: branding400),
  );
}
