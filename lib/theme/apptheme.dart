import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: AppColors.screenBackgroundColor,
    useMaterial3: false,
    primaryColor: AppColors.primary,
    appBarTheme: appBarTheme,
    unselectedWidgetColor: AppColors.borderGrey,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primaryLight.withOpacity(0.3),
      selectionHandleColor: AppColors.primary,
    ),
  );

  static AppBarTheme appBarTheme = AppBarTheme(
    color: AppColors.primary,
    centerTitle: true,
    titleTextStyle: appBarTitleTheme,
    iconTheme: appBarIconTheme,
    shadowColor: AppColors.borderGrey.withOpacity(0.3),
    elevation: 0,
    scrolledUnderElevation: 0,
  );

  static IconThemeData appBarIconTheme = const IconThemeData(
    color: AppColors.white,
  );

  static TextStyle appBarTitleTheme = const TextStyle();
}

class ThemeObserver extends WidgetsBindingObserver {
  @override
  void didChangePlatformBrightness() {
    final Brightness brightness =
        // ignore: deprecated_member_use
        WidgetsBinding.instance.window.platformBrightness;
    final isDarkTheme = brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColors.borderGrey.withOpacity(0.01)));
  }
}
