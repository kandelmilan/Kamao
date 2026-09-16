import 'package:flutter/material.dart';
import 'package:kamao/core/constants/app_images.dart';

/// Full brand mark (icon + "kamao" wordmark baked into [AppImages.appLogo]).
/// Use this on every pre-auth screen so sizing stays consistent.
class AppLogo extends StatelessWidget {
  /// Auth screens (login / register / reset) — compact header mark.
  const AppLogo({super.key, this.height = 88});

  /// Splash hero mark.
  const AppLogo.splash({super.key}) : height = 168;

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.appLogo,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
