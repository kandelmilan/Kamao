import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamao/core/core.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Pages ──────────────────────────────────────────────
          PageView.builder(
            controller: controller.pageController,
            itemCount: _pages.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (_, i) => _OnboardingPage(data: _pages[i], index: i),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Obx(() {
              final page = controller.currentPage.value;
              return _BottomBar(
                waveColor: _pages[page].waveColor,
                waveStyle: _pages[page].waveStyle,
                onSkip: controller.skip,
                onNext: controller.next,
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Bottom bar — wave + Skip / Next, positioned to match Figma exactly
// ─────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.waveColor,
    required this.waveStyle,
    required this.onSkip,
    required this.onNext,
  });

  final Color waveColor;
  final _WaveStyle waveStyle;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  // @override
  // Widget build(BuildContext context) {
  //   return Stack(
  //     clipBehavior:
  //         Clip.none, // let the wave bleed past its own box, matching Figma
  //     children: [
  //       // ── Wave ──────────────────────────────────────────
  //       // Figma: width 460, height 173, top 787, left -16
  //       Positioned(
  //         left: -16,
  //         // top: waveStyle == _WaveStyle.diagonal ? null : 787,
  //         top: 756,
  //         bottom: waveStyle == _WaveStyle.diagonal ? 0 : null,
  //         // width: 460,
  //         // height: waveStyle == _WaveStyle.diagonal ? 420 : 173,s
  //         child: IgnorePointer(
  //           // Touches pass straight through to the PageView underneath,
  //           // so swiping anywhere over the wave still changes pages.
  //           child: CustomPaint(
  //             painter: _WaveCurvePainter(color: waveColor, style: waveStyle),
  //             size: Size(460, waveStyle == _WaveStyle.diagonal ? 420 : 173),
  //           ),
  //         ),
  //       ),

  //       // ── Skip + Next ───────────────────────────────────
  //       // Figma: width 372, height 42, justify-content: space-between,
  //       // top 771, left 20
  //       Positioned(
  //         left: 20,
  //         top: 771,
  //         width: 372,
  //         height: 42,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             GestureDetector(
  //               onTap: onSkip,
  //               behavior: HitTestBehavior.opaque,
  //               child: Text(
  //                 'Skip',
  //                 style: GoogleFonts.roboto(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w500,
  //                   color: const Color(0xFF4B0070),
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: onNext,
  //               child: Container(
  //                 width: 42,
  //                 height: 42,
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFF4B0070),
  //                   shape: BoxShape.circle,
  //                   boxShadow: const [
  //                     BoxShadow(
  //                       color: Color(0x334B0070),
  //                       blurRadius: 10,
  //                       offset: Offset(0, 4),
  //                     ),
  //                   ],
  //                 ),
  //                 child: const Icon(
  //                   RemixIcons.arrow_right_line,
  //                   color: Colors.white,
  //                   size: 20,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const figmaSize = Size(412, 917);
    final sx = size.width / figmaSize.width;
    final sy = size.height / figmaSize.height;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Wave ──────────────────────────────────────────
        if (waveStyle == _WaveStyle.dome)
          Positioned(
            left: -16,
            top: 756,
            child: IgnorePointer(
              child: CustomPaint(
                painter: _WaveCurvePainter(color: waveColor, style: waveStyle),
                size: const Size(460, 173),
              ),
            ),
          )
        else
          // Page 2 — same circle-difference wave as the splash screen,
          // just recolored and reused here.
          Positioned(
            right: -100 * sx,
            bottom: -140 * sy,
            width: 480 * sx,
            height: 540 * sy,
            child: IgnorePointer(
              child: CustomPaint(
                size: Size(480 * sx, 540 * sy),
                painter: _DiagonalWavePainter(color: waveColor),
              ),
            ),
          ),

        // ── Skip + Next ─────────────────────────────────── (unchanged)
        Positioned(
          left: 20,
          top: 771,
          width: 372,
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onSkip,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Skip',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4B0070),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onNext,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B0070),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x334B0070),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    RemixIcons.arrow_right_line,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Diagonal wave — page 2. Same circle-difference technique as the
// splash screen's _WavePainter (splash_view.dart), reused here with
// a color parameter.
// ─────────────────────────────────────────────────────────────
class _DiagonalWavePainter extends CustomPainter {
  const _DiagonalWavePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final outer = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width * 0.90, size.height * 0.90), //0.70
          radius: size.width * 0.94,
        ),
      );

    final inner = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width * -0.08, size.height * -0.13),
          radius: size.width * 0.94,
        ),
      );

    canvas.drawPath(
      Path.combine(PathOperation.difference, outer, inner),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _DiagonalWavePainter old) => old.color != color;
}
// ─────────────────────────────────────────────────────────────
// Page data
// ─────────────────────────────────────────────────────────────

// Only two wave shapes: "dome" is shared by page 1 & page 3 (identical
// curve, different color), "diagonal" is unique to page 2.
enum _WaveStyle { dome, diagonal }

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.illustration,
    required this.waveColor,
    required this.waveStyle,
    this.bgColor,
    this.bgGradient,
  }) : assert(
         bgColor != null || bgGradient != null,
         'Provide either bgColor or bgGradient',
       );

  final String badge;
  final InlineSpan title;
  final String subtitle;
  final Widget illustration;
  final Color waveColor;
  final _WaveStyle waveStyle;
  final Color? bgColor;
  final Gradient? bgGradient;
}

final List<_OnboardingPageData> _pages = [
  // ── Page 1: Post ──────────────────────────────────────────
  _OnboardingPageData(
    badge: 'Post.',
    title: TextSpan(
      style: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: const Color(0xFF1A1A1A),
      ),
      children: [
        const TextSpan(text: 'Create Content . Post\nand '),
        TextSpan(
          text: 'Get Paid',
          style: GoogleFonts.roboto(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: const Color(0xFF4B0070),
          ),
        ),
        TextSpan(
          text: '.',
          style: GoogleFonts.roboto(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: const Color(0xFF4B0070),
          ),
        ),
      ],
    ),
    subtitle:
        'Turn your everyday knowledge and creativity into content people love & Earn',
    illustration: Image.asset(
      AppImages.onboarding1,
      fit: BoxFit.contain,
      width: 320,
      height: 420,
    ),
    waveColor: const Color(0xFFAC8ABD),
    waveStyle: _WaveStyle.dome,
    bgColor: const Color(0xFFFEFFFE),
  ),
  // ── Page 2: Influence ─────────────────────────────────────
  _OnboardingPageData(
    badge: 'Influence.',
    title: TextSpan(
      style: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: const Color(0xFF1A1A1A),
      ),
      children: const [
        TextSpan(text: 'Share what you know.\nInspire someone.'),
      ],
    ),
    subtitle:
        'Share your ideas, skills, tips, and creativity with people who care.',
    illustration: SizedBox(
      width: 320,
      height: 300,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Align(
            alignment: const Alignment(-0.95, 0.1),
            child: SvgPicture.asset(
              AppImages.onboarding21,
              width: 235,
              height: 260,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: const Alignment(1.2, 0.6),
            child: SvgPicture.asset(
              AppImages.onboarding22,
              width: 196,
              height: 156,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    ),
    // illustration: SizedBox(
    //   width: 321,
    //   height: 233, // 76 + 156.92 (onboarding22's bottom edge)
    //   child: Stack(
    //     clipBehavior: Clip.none,
    //     children: [
    //       Positioned(
    //         left: 58,
    //         top: 76,
    //         child: SvgPicture.asset(
    //           AppImages.onboarding21,
    //           width: 235.9395,
    //           height: 117.6458,
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //       Positioned(
    //         left: 125,
    //         top: 76,
    //         child: SvgPicture.asset(
    //           AppImages.onboarding22,
    //           width: 196,
    //           height: 156.92,
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
    waveColor: const Color(0xFFFFD1D1),
    waveStyle: _WaveStyle.diagonal,
    bgGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF9EDFF), Color(0xFFFFFFFF)],
    ),
  ),

  // ── Page 3: Earn ──────────────────────────────────────────
  _OnboardingPageData(
    badge: 'Earn.',
    title: TextSpan(
      style: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: const Color(0xFF1A1A1A),
      ),
      children: [
        const TextSpan(text: 'Influence and earn\n'),
        TextSpan(
          text: 'Real money',
          style: GoogleFonts.roboto(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: const Color(0xFF4B0070),
          ),
        ),
      ],
    ),
    subtitle:
        'Share videos, ideas and helpful tips on anything you know. Your content can earn you real money.',
    // illustration: SizedBox(
    //   width: 400,
    //   height: 360,
    //   child: Stack(
    //     clipBehavior: Clip.hardEdge,
    //     children: [
    //       Positioned(
    //         left: 28,
    //         top: 10,
    //         child: SvgPicture.asset(
    //           AppImages.onboarding31,
    //           width: 197,
    //           height: 159,
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //       Positioned(
    //         left: 125,
    //         top: 125,
    //         child: SvgPicture.asset(
    //           AppImages.onboarding32,
    //           width: 187,
    //           height: 222,
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
    illustration: SizedBox(
      width: 440,
      height: 340,
      child: Stack(
        clipBehavior: Clip.none, // avoid clipping the person's legs/feet
        children: [
          // Earnings card — top-left
          Positioned(
            left: 40,
            top: 0,
            child: SvgPicture.asset(
              AppImages.onboarding31,
              width: 197,
              height: 159,
              fit: BoxFit.contain,
            ),
          ),
          // Person — right side, overlapping the card's bottom-right corner
          // slightly, roughly level with where the dashed arrow points
          Positioned(
            left: 135,
            top: 103,
            child: SvgPicture.asset(
              AppImages.onboarding32,
              width: 187,
              height: 222,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    ),
    // Same wave style AND same enum value as page 1 — guarantees the
    // exact same curve is drawn (only the color differs, matching Figma).
    waveColor: const Color(0xFFC9A9E0),
    waveStyle: _WaveStyle.dome,
    bgColor: const Color(0xFFFEFFFE),
  ),
];

// final List<_OnboardingPageData> _pages = [
//   // ── Page 1: Post ──────────────────────────────────────────
//   _OnboardingPageData(
//     badge: 'Post.',
//     title: TextSpan(
//       style: GoogleFonts.roboto(
//         fontSize: 28,
//         fontWeight: FontWeight.w500,
//         height: 1.2,
//         color: const Color(0xFF1A1A1A),
//       ),
//       children: [
//         const TextSpan(text: 'Create Content . Post\nand '),
//         TextSpan(
//           text: 'Get Paid',
//           style: GoogleFonts.roboto(
//             fontSize: 28,
//             fontWeight: FontWeight.w700,
//             height: 1.2,
//             color: const Color(0xFF4B0070),
//           ),
//         ),
//         TextSpan(
//           text: '.',
//           style: GoogleFonts.roboto(
//             fontSize: 28,
//             fontWeight: FontWeight.w700,
//             height: 1.2,
//             color: const Color(0xFF4B0070),
//           ),
//         ),
//       ],
//     ),
//     subtitle:
//         'Turn your everyday knowledge and creativity into content people love & Earn',
//     illustration: SvgPicture.asset(
//       AppImages.onboarding1,
//       fit: BoxFit.contain,
//       width: 280,
//       height: 280,
//     ),
//     waveColor: const Color(0xFFC9A9E0),
//     waveStyle: _WaveStyle.dome,
//   ),
//   // ── Page 2: Influence ─────────────────────────────────────
//   _OnboardingPageData(
//     badge: 'Influence.',
//     title: TextSpan(
//       style: GoogleFonts.roboto(
//         fontSize: 28,
//         fontWeight: FontWeight.w700,
//         height: 1.2,
//         color: const Color(0xFF1A1A1A),
//       ),
//       children: const [
//         TextSpan(text: 'Share what you know.\nInspire someone.'),
//       ],
//     ),
//     subtitle:
//         'Share your ideas, skills, tips, and creativity with people who care.',
//     illustration: SizedBox(
//       width: 320,
//       height: 300,
//       child: Stack(
//         clipBehavior: Clip.hardEdge,
//         children: [
//           Align(
//             alignment: const Alignment(-0.95, 0.05),
//             child: SvgPicture.asset(
//               AppImages.onboarding21,
//               width: 150,
//               height: 260,
//               fit: BoxFit.contain,
//             ),
//           ),
//           Align(
//             alignment: const Alignment(0.7, 0.2),
//             child: SvgPicture.asset(
//               AppImages.onboarding22,
//               width: 170,
//               height: 240,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ],
//       ),
//     ),
//     waveColor: const Color(0xFFFFD1D1),
//     waveStyle: _WaveStyle.diagonal,
//   ),

//   // ── Page 3: Earn ──────────────────────────────────────────
//   _OnboardingPageData(
//     badge: 'Earn.',
//     title: TextSpan(
//       style: GoogleFonts.roboto(
//         fontSize: 28,
//         fontWeight: FontWeight.w500,
//         height: 1.2,
//         color: const Color(0xFF1A1A1A),
//       ),
//       children: [
//         const TextSpan(text: 'Influence and earn\n'),
//         TextSpan(
//           text: 'Real money',
//           style: GoogleFonts.roboto(
//             fontSize: 28,
//             fontWeight: FontWeight.w700,
//             height: 1.2,
//             color: const Color(0xFF4B0070),
//           ),
//         ),
//       ],
//     ),
//     subtitle:
//         'Share videos, ideas and helpful tips on anything you know. Your content can earn you real money.',
//     illustration: SizedBox(
//       width: 300,
//       height: 320,
//       child: Stack(
//         clipBehavior: Clip.hardEdge,
//         children: [
//           Positioned(
//             left: 0,
//             top: 0,
//             child: SvgPicture.asset(
//               AppImages.onboarding31,
//               width: 260,
//               height: 160,
//               fit: BoxFit.contain,
//             ),
//           ),
//           Positioned(
//             right: 0,
//             bottom: 0,
//             child: SvgPicture.asset(
//               AppImages.onboarding32,
//               width: 170,
//               height: 240,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ],
//       ),
//     ),
//     // Same wave style AND same enum value as page 1 — guarantees the
//     // exact same curve is drawn (only the color differs, matching Figma).
//     waveColor: const Color(0xFFC9A9E0),
//     waveStyle: _WaveStyle.dome,
//   ),
// ];

// ─────────────────────────────────────────────────────────────
// Single page
// ─────────────────────────────────────────────────────────────
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data, required this.index});

  final _OnboardingPageData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: data.bgGradient == null ? data.bgColor : null,
        gradient: data.bgGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Text(
                data.badge,
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                  color: const Color(0xFF4B0070),
                ),
              ),
              const SizedBox(height: 14),

              // Title
              Text.rich(data.title),
              const SizedBox(height: 14),

              // Subtitle
              Text(
                data.subtitle,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: const Color(0xFF6B6B6B),
                ),
              ),

              // Illustration
              Expanded(child: Center(child: data.illustration)),

              // Space for bottom bar
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Wave painter — two shapes only:
//   • dome     → identical curve for page 1 & page 3
//   • diagonal → unique sweeping curve for page 2
// ─────────────────────────────────────────────────────────────
class _WaveCurvePainter extends CustomPainter {
  const _WaveCurvePainter({required this.color, required this.style});

  final Color color;
  final _WaveStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    if (style == _WaveStyle.diagonal) {
      // Same technique as the splash screen's _WavePainter: a big outer
      // circle sitting toward the bottom-right, with a second circle
      // biting away the top-left, leaving a soft diagonal crescent —
      // low on the left, sweeping up to a high peak on the right.
      final outer = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(size.width * 0.62, size.height * 0.78),
            radius: size.width * 0.8,
          ),
        );

      final inner = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(size.width * -0.12, size.height * -0.20),
            radius: size.width * 1.15,
          ),
        );

      canvas.drawPath(
        Path.combine(PathOperation.difference, outer, inner),
        paint,
      );
      return;
    }

    // Page 1 & Page 3 — one symmetric "valley" wave: high (more color)
    // at both edges, dipping in the middle. Same shape every time this
    // style is used — only `color` changes between pages.
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.18)
      ..cubicTo(
        size.width * 0.15, //0.23
        size.height * 0.65, //0.72
        size.width * 0.35, //0.48
        size.height * 0.9, //0.90
        size.width * 0.7, //0.76
        size.height * 0.8, //0.8
      )
      ..cubicTo(
        size.width * 0.98, //0.9
        size.height * 0.64, //0.74
        size.width * 0.99, //1.3
        size.height * 0.55, //0.55
        size.width,
        size.height * 0.35, //0.35
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaveCurvePainter old) =>
      old.color != color || old.style != style;
}
