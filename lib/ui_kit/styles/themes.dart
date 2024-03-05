import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';

class AppThemes {
  static final ThemeData defaultTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.blue1,
    scaffoldBackgroundColor: AppColors.white1,
    cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
      primaryColor: AppColors.blue1,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue1,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.blue1,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.white1,
      surfaceTintColor: AppColors.white1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            24,
          ),
        ),
      ),
      titleTextStyle: TextStyle(
        color: AppColors.black2,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: TextStyle(
        color: AppColors.black2,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      color: AppColors.blue1,
      surfaceTintColor: AppColors.blue1,
      titleTextStyle: TextStyle(
        fontSize: 20,
        color: AppColors.white1,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(
        color: AppColors.white1,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(
          AppColors.blue1.withOpacity(.08),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(AppColors.blue1),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white2,
      suffixIconColor: AppColors.gray2,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 16,
      ),
      counterStyle: const TextStyle(
        color: AppColors.gray2,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: const TextStyle(
        color: AppColors.red1,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: const TextStyle(
        color: AppColors.gray2,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.black2,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: AppColors.black2,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: AppColors.black2,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
