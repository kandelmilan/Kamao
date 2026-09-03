import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Text styles seen across Home/Splash/Login (Roboto, weight-heavy
/// headings). Extend this instead of inlining TextStyle() in screens.
class AppTextStyles {
  AppTextStyles._();

  static const heading = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.heading,
  );

  static const subheading = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.cardTitle,
  );

  static const body = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.subtext,
  );

  static const caption = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.bodyGrey,
  );

  static const label = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );
}
