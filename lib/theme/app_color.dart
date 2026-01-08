import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // -------------------------------------------------------------
  // NEW BRAND COLORS (FROM IMAGE)
  // -------------------------------------------------------------

  static const Color primaryNew = Color(0xFF2D6289);
  static const Color primaryNewHeader = Color(0xFF124568);
  static const Color primaryNewDark = Color(0xFF0A3248);
  static const Color bgColor = Color(0xFFF8F8F8);
  static const Color greyF8 = Color(0xFFF8F7F3);

  // -------------------------------------------------------------
  // BRAND COLORS (FROM IMAGE)
  // -------------------------------------------------------------

  static const Color primary = Color(0xFF2D4C73); // Navy Blue (was 32D688F)
  static const Color secondary = Color(0xFF7EB5D6); // Blue
  static const Color tertiary = Color(0xFFA8BFFE); // Light Blue (was A88FFE2)

  // -------------------------------------------------------------
  // BACKGROUNDS
  // -------------------------------------------------------------

  static const Color screenBackgroundColor = Color(0xFFF7F9FA); // Off White
  static const Color cardBackground = Color(0xFFFFFFFF); // Pure White

  // -------------------------------------------------------------
  // TEXT COLORS
  // -------------------------------------------------------------

  static const Color textPrimary = Color(0xFF324D88); // Navy Blue
  static const Color textSecondary = Color(0xFF7C7782); // Grey
  static const Color textLight = Color(0xFF9FA4AA);

  // -------------------------------------------------------------
  // BORDERS
  // -------------------------------------------------------------

  static const Color borderGrey = Color(0xFFE4E6E7);
  static const Color greyLight = Color(0xFFF1F2F3);

  // -------------------------------------------------------------
  // STATUS COLORS
  // -------------------------------------------------------------

  static const Color error = Color(0xFFD10C1C);
  static const Color errorLight = Color(0xFFF9D2D2);

  static const Color success = Color(0xFF28C76F);
  static const Color successLight = Color(0xFFEBF9F1);

  static const Color warning = Color(0xFFFDCC0D);
  static const Color warningLight = Color(0xFFFFF4D6);

  // -------------------------------------------------------------
  // MISC
  // -------------------------------------------------------------

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Shadows
  static const Color shadowLight = Color(0x11000000);
  static const Color shadowMedium = Color(0x22000000);

  // Component-specific colors
  static const Color toggleSelected = Color(0xFF7EB5D6);
  static const Color toggleSelectedBg = Color(0x307EB5D6);

  // Input fields
  static const Color inputFill = Color(0xFFFFFFFF);
  static const Color inputHint = Color(0xFF7C7782);

  // // New Brand Colors (2025 Rebranding)
  // static const primary = Color(0xFF224567); // Primary Dark Blue
  // static const secondary = Color(0xFF9FC5C6); // Primary Medium Blue
  // static const Color tertiary = Color(0xFFA88FFE2); // Primary Light Blue
  // static const Color cardBackground = Color(0xFFF7F9FA); // Off White for cards
  // static const Color screenBackgroundColor = Color(0xFFF7F9FA); // Off White for screens

  static const Color accent = Color(0xFF7EB5D6); // Medium Blue for accents
  static const primaryLight = Color(0xFFA88FFE2); // Light Blue

  // Neutral Colors
  // static const black = Colors.black;
  // static const white = Color(0xFFFFFFFF);
  static const Color whiteColor = Color(0xFFFFFFFF);

  static const grey = Color(0xFF7C7782); // Medium Grey (from palette)
  static const Color greyNormalColor = Color(0xFF7C7782); // Medium Grey
  // static const borderGrey = Color(0xFFE4E6E7); // Light Grey (from palette)
  static const Color greylightColor = Color(0xFFE4E6E7); // Light Grey
  static const lightgrey = Color(0xFFF7F9FA); // Off White
  static const Color greyColor = Color(0xFFE4E6E7); // Light Grey

  static const Color blackColor = Color(0xFF000000);
  static const Color blackNormalColor = Color(0xFF37474F);
  static const lightBlackColor = Color(0xFF666666);

  // Kept for backwards compatibility but mapped to new colors
  static const lightBrown = Color(0xFFF7F9FA); // Mapped to Off White
  static const primaryBrown = Color(0xFF32D688F); // Mapped to Primary
  static const secondaryBrownLight = Color(0xFFA88FFE2); // Mapped to Light Blue
  static const secondaryBrown = Color(0xFF32D688F); // Mapped to Primary

  static const Color primaryColor = Color(0xFF32D688F); // Primary Dark Blue

  // Status Colors (adjusted to work with new palette)
  static const Color pinkNormalColor = Color(0xFFD10C1C); // Keep for errors/alerts
  static const Color pinklightNormalColor = Color(0xFFF9D2D2); // Keep for light alerts

  static const Color lightBlueColor = Color(0xFF7EB5D6); // Medium Blue

  static const Color lightorangeColor = Color(0xFFFDCC0D); // Keep for warnings

  static const Color bgColorlightgreen = Color(0xFFf0f2ec); // Keep for success backgrounds
  static const Color lightGreenColor = Color(0xFF64B699); // Keep for success states
  static const Color greenColor = Color(0xFF28C76F); // Keep for success states
}
