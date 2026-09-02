import 'package:flutter/animation.dart';

// Brand palette — matches splash_view.dart / home_view.dart / login_view.dart
// (Figma Campaign App reference). This used to be an unrelated indigo
// palette (#20205C family) that only forgot_password_view.dart and
// app_theme.dart still read from; every other screen had drifted onto
// its own local purple/coral palette instead. Updated here so the
// shared theme is the single source of truth again — any screen still
// pulling from AppColors (currently just forgot_password_view.dart and
// app_theme.dart) now automatically matches the rest of the app.
class AppColors {
  AppColors._();

  // Main Colors
  static const Color primaryDark = Color(0xFF3E0163);
  static const Color primary = Color(0xFF4B0070);
  static const Color primaryLight = Color(0xFF6F338D);

  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentLight = Color(0xFFFF8F8F);

  // Gradient — same wallet-card purple used on Splash and Home.
  static const Color gradientTop = Color(0xFF6F338D);
  static const Color gradientMiddle = Color(0xFF571A78);
  static const Color gradientBottom = Color(0xFF3E0163);

  // Decorations — plain white opacity circles, matching Splash's
  // decorative background rather than a tinted color.
  static const Color circleLarge = Color(0xFFFFFFFF);
  static const Color circleBorder = Color(0xFFFFFFFF);

  // Glass
  static const Color glass = Color(0x144B0070);
  static const Color glassBorder = Color(0x386F338D);

  static const Color white = Color(0xFFFFFFFF);
  static const Color shadow = Color(0x264B0070);
  static const Color background = Color(0xFFF6F4F7);
}
