import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamao/core/core.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/splash_controller.dart';

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
    const figmaSize = Size(412, 917);
    final sx = size.width / figmaSize.width;
    final sy = size.height / figmaSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // ── Gradient (lilac → white) ──────────────────────────────
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_SplashPalette.gradientLilac, Colors.white],
                stops: [0.0, 0.43],
              ),
            ),
          ),

          // ── Bottom-right wave ─────────────────────────────────────
          Positioned(
            right: -100 * sx,
            bottom: -140 * sy,
            width: 480 * sx,
            height: 540 * sy,
            child: CustomPaint(
              size: Size(520 * sx, 520 * sy),
              painter: _WavePainter(),
            ),
          ),

          // ── Center content ────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            top: 220 * sy,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: _SplashPalette.purple500.withOpacity(0.1),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(AppImages.appLogo, fit: BoxFit.contain),
                  ),
                ),

                // "kamao"
                Text(
                  'Kamao',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: _SplashPalette.purple500,
                    fontWeight: FontWeight.w600,
                    fontSize: 54,
                    height: 1.0,
                    letterSpacing: 54 * -0.015,
                  ),
                ),

                const SizedBox(height: 8),

                // "Tip. Support. Grow Together."
                Text.rich(
                  TextSpan(
                    style: GoogleFonts.roboto(
                      color: _SplashPalette.violet600,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: 1.0,
                      letterSpacing: 15 * 0.005,
                    ),
                    children: [
                      const TextSpan(text: 'Tip'),
                      TextSpan(
                        text: '.',
                        style: TextStyle(color: _SplashPalette.iconCoral),
                      ),
                      const TextSpan(text: ' Support'),
                      TextSpan(
                        text: '.',
                        style: TextStyle(color: _SplashPalette.iconCoral),
                      ),
                      const TextSpan(text: ' Grow Together'),
                      TextSpan(
                        text: '.',
                        style: TextStyle(color: _SplashPalette.iconCoral),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),

                // Feature chips + dashed line
                // Figma: width 291, height 48, left 75, top 486, dashed #C7B0D3
                SizedBox(
                  width: 291,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // dashed connector
                      SizedBox(
                        width:
                            251, // leaves room for the 48px chips on each side
                        height: 1,
                        child: CustomPaint(
                          painter: _DashedLinePainter(
                            color: const Color(
                              0xFFC7B0D3,
                            ), // exact Figma stroke
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

// ─────────────────────────────────────────────────────────────
// Wave
// ─────────────────────────────────────────────────────────────
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD1D1)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Big outer circle sitting in the bottom-right corner
    final outer = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width * 0.70, size.height * 0.70),
          radius: size.width * 0.85,
        ),
      );

    // Large inner circle that bites from the top-left
    // → creates the soft crescent edge
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

// ─────────────────────────────────────────────────────────────
// Feature chip — light outer + purple badge + coral icon
// ─────────────────────────────────────────────────────────────
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
        color: Color(0xFFE8DFED), // soft outer ring
        shape: BoxShape.circle,
      ),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: _SplashPalette.purple500,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: _SplashPalette.iconCoral),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({
    required this.color,
    this.dashLength = 5,
    this.spaceLength = 4,
  });

  final Color color;
  final double dashLength;
  final double spaceLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth =
          1.0 // border-width: 1px
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

// ─────────────────────────────────────────────────────────────
// Palette
// ─────────────────────────────────────────────────────────────
class _SplashPalette {
  const _SplashPalette._();

  static const purple500 = Color(0xFF4B0070);
  static const violet600 = Color(0xFF433D46);
  static const iconCoral = Color(0xFFFC7276);
  static const gradientLilac = Color(0xFFF1D9FF);
}
