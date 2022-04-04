import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'other_styles.dart';
import 'text_styles.dart';

final ThemeData appTheme = ThemeData(
  progressIndicatorTheme:
      const ProgressIndicatorThemeData(color: PersonalColors.blue),
  appBarTheme: const AppBarTheme(
      color: Colors.white,
      centerTitle: true,
      iconTheme: IconThemeData(color: PersonalColors.grey1),
      titleTextStyle: PersonalTStyles.w500s16B),
  inputDecorationTheme: InputDecorationTheme(
    border: outlineInputBorder,
    focusedBorder: focusedoutlineInputBorder,
    labelStyle: const TextStyle(color: PersonalColors.blue),
    hintStyle: const TextStyle(color: PersonalColors.grey2),
  ),
  fontFamily: GoogleFonts.inter().fontFamily,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(16),
      textStyle: PersonalTStyles.w600s16W,
      backgroundColor: PersonalColors.orange,
    ),
  ),
  textSelectionTheme:
      const TextSelectionThemeData(cursorColor: PersonalColors.blue),
);

final secondaryTextButtonTheme = TextButton.styleFrom(
  primary: PersonalColors.orange,
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: PersonalColors.orange, width: 2)),
  padding: const EdgeInsets.all(16),
  textStyle: PersonalTStyles.w600s14Or,
  backgroundColor: Colors.white,
);

final softRedTextButtonTheme = TextButton.styleFrom(
  primary: PersonalColors.softRed,
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: PersonalColors.softRed, width: 2)),
  padding: const EdgeInsets.all(16),
  textStyle: PersonalTStyles.w600s14SR,
  backgroundColor: Colors.white,
);

final orangeBGTextButtonTheme = TextButton.styleFrom(
  primary: Colors.orange,
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: PersonalColors.orange, width: 2)),
  padding: const EdgeInsets.all(16),
  textStyle: PersonalTStyles.w600s14Or,
  backgroundColor: const Color(0xFFFFF7F0),
);

final greyTextButtonTheme = TextButton.styleFrom(
  primary: PersonalColors.grey2,
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: PersonalColors.grey2, width: 2)),
  padding: const EdgeInsets.all(16),
  textStyle: PersonalTStyles.w600s14Or,
  backgroundColor: Colors.white,
);
