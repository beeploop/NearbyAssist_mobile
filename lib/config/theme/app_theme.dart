import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nearby_assist/config/theme/app_colors.dart';

class AppTheme {
  static final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.seed,
    onSurface: AppColors.black,
  );

  static final defaultTheme = ThemeData.light().copyWith(
    colorScheme: colorScheme,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      },
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 56.sp, color: colorScheme.onSurface),
      headlineMedium: TextStyle(fontSize: 40.sp, color: colorScheme.onSurface),
      headlineSmall: TextStyle(fontSize: 32.sp, color: colorScheme.onSurface),
      titleLarge: TextStyle(fontSize: 20.sp, color: colorScheme.onSurface),
      titleMedium: TextStyle(fontSize: 18.sp, color: colorScheme.onSurface),
      titleSmall: TextStyle(fontSize: 16.sp, color: colorScheme.onSurface),
      bodyLarge: TextStyle(fontSize: 16.sp, color: colorScheme.onSurface),
      bodyMedium: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface),
      bodySmall: TextStyle(fontSize: 12.sp, color: colorScheme.onSurface),
      labelLarge: TextStyle(fontSize: 16.sp, color: colorScheme.onSurface),
      labelMedium: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface),
      labelSmall: TextStyle(fontSize: 12.sp, color: colorScheme.onSurface),
    ),
    datePickerTheme: DatePickerThemeData(
      headerHeadlineStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      headerHelpStyle: TextStyle(
        fontSize: 12.sp,
        color: AppColors.grey,
      ),
    ),
  );
}
