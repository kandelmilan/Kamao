import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/splash_controller.dart';

/// Splash — Figma Campaign App node 722:1055
/// Green brand system (matches onboarding 711:*).
class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SplashBody();
  }
}

class _SplashBody extends StatefulWidget {
  const _SplashBody();

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const figmaW = 412.0;
    const figmaH = 917.0;
    final sx = size.width / figmaW;
    final sy = size.height / figmaH;

    return Scaffold(
      backgroundColor: AppColors.onboardingBgBottom,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // Soft green → white gradient (same family as onboarding)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.onboardingBgTop,
                  AppColors.onboardingBgBottom,
                ],
                stops: [0.0, 0.43],
              ),
            ),
          ),

          // Bottom-right soft green wave
          Positioned(
            right: -100 * sx,
            bottom: -140 * sy,
            width: 480 * sx,
            height: 540 * sy,
            child: CustomPaint(
              size: Size(520 * sx, 520 * sy),
              painter: const _WavePainter(),
            ),
          ),

          // Center brand content
          Positioned(
            left: 0,
            right: 0,
            top: 220 * sy,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo.splash(),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    style: GoogleFonts.roboto(
                      color: AppColors.onboardingSubtitle,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: 1.0,
                      letterSpacing: 15 * 0.005,
                    ),
                    children: const [
                      TextSpan(text: 'Tip'),
                      TextSpan(
                        text: '.',
                        style: TextStyle(color: AppColors.accent),
                      ),
                      TextSpan(text: ' Support'),
                      TextSpan(
                        text: '.',
                        style: TextStyle(color: AppColors.accent),
                      ),
                      TextSpan(text: ' Grow Together'),
                      TextSpan(
                        text: '.',
                        style: TextStyle(color: AppColors.accent),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                // Feature chips + dashed connector
                SizedBox(
                  width: 291,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 251,
                        height: 1,
                        child: CustomPaint(
                          painter: const _DashedLinePainter(
                            color: AppColors.onboardingWaveDome,
                          ),
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _FeatureChip(icon: RemixIcons.heart_line),
                          _FeatureChip(icon: RemixIcons.video_on_fill),
                          _FeatureChip(icon: RemixIcons.wallet_line),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.onboardingWaveDiagonal
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final outer = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width * 0.70, size.height * 0.70),
          radius: size.width * 0.85,
        ),
      );

    final inner = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width * -0.05, size.height * -0.10),
          radius: size.width * 0.95,
        ),
      );

    canvas.drawPath(
      Path.combine(PathOperation.difference, outer, inner),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.onboardingWaveDome,
        shape: BoxShape.circle,
      ),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.onboardingGreen,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const dashLength = 5.0;
    const spaceLength = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    double x = 0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, y),
        Offset(math.min(x + dashLength, size.width), y),
        paint,
      );
      x += dashLength + spaceLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
