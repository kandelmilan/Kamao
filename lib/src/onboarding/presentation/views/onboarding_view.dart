import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/onboarding_controller.dart';

/// Figma Android Compact frame used for all onboarding screens.
const _figmaW = 412.0;
const _figmaH = 917.0;

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBgBottom,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: controller.pageController,
            itemCount: _pages.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (_, i) => _OnboardingPage(data: _pages[i]),
          ),
          Positioned.fill(
            child: Obx(() {
              final page = controller.currentPage.value;
              return _BottomBar(data: _pages[page]);
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Bottom bar — wave + Skip / Next
// ─────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final sx = size.width / _figmaW;
    final sy = size.height / _figmaH;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (data.waveStyle == _WaveStyle.dome)
          Positioned(
            left: data.waveLeft * sx,
            top: data.waveTop * sy,
            width: 460 * sx,
            height: 173 * sy,
            child: IgnorePointer(
              child: SvgPicture.asset(
                data.waveAsset,
                fit: BoxFit.fill,
              ),
            ),
          )
        else
          // Figma 711:1123 — transform baked into wave_diagonal.svg
          Positioned(
            left: -28 * sx,
            top: 478.61 * sy,
            width: 677.557 * sx,
            height: 665.139 * sy,
            child: IgnorePointer(
              child: SvgPicture.asset(
                data.waveAsset,
                fit: BoxFit.fill,
                allowDrawingOutsideViewBox: true,
              ),
            ),
          ),
        Positioned(
          left: 20 * sx,
          top: data.actionsTop * sy,
          width: 372 * sx,
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: Get.find<OnboardingController>().skip,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Skip',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onboardingGreen,
                  ),
                ),
              ),
              GestureDetector(
                onTap: Get.find<OnboardingController>().next,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.onboardingGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33426340),
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

enum _WaveStyle { dome, diagonal }

enum _PageKind { post, influence, earn }

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.kind,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.waveAsset,
    required this.waveStyle,
    required this.actionsTop,
    required this.waveLeft,
    required this.waveTop,
  });

  final _PageKind kind;
  final String badge;
  final InlineSpan title;
  final String subtitle;
  final String waveAsset;
  final _WaveStyle waveStyle;
  final double actionsTop;
  final double waveLeft;
  final double waveTop;
}

TextStyle get _badgeStyle => GoogleFonts.roboto(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.0,
      color: AppColors.onboardingGreen,
    );

TextStyle get _titleBase => GoogleFonts.roboto(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      height: 1.2,
      color: AppColors.onboardingTitle,
    );

TextStyle get _titleEmphasis => GoogleFonts.roboto(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: AppColors.onboardingGreen,
    );

final List<_OnboardingPageData> _pages = [
  // ── Page 1: Post (Figma 711:1104) ──────────────────────────
  _OnboardingPageData(
    kind: _PageKind.post,
    badge: 'Post.',
    title: TextSpan(
      style: _titleBase,
      children: [
        const TextSpan(text: 'Create Content . Post\nand '),
        TextSpan(text: 'Get Paid', style: _titleEmphasis),
        TextSpan(
          text: '.',
          style: _titleBase.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    ),
    subtitle:
        'Turn your everyday knowledge and creativity into content people love & Earn',
    waveAsset: AppImages.onboardingWaveDome,
    waveStyle: _WaveStyle.dome,
    actionsTop: 771,
    waveLeft: -16,
    waveTop: 787,
  ),

  // ── Page 2: Influence (Figma 711:1117) ─────────────────────
  _OnboardingPageData(
    kind: _PageKind.influence,
    badge: 'Influence.',
    title: TextSpan(
      style: _titleBase,
      children: const [
        TextSpan(text: 'Share what you know.\nInspire someone.'),
      ],
    ),
    subtitle:
        'Share your ideas, skills, tips, and creativity with people who care.',
    waveAsset: AppImages.onboardingWaveDiagonal,
    waveStyle: _WaveStyle.diagonal,
    actionsTop: 761,
    waveLeft: -28,
    waveTop: 478.61,
  ),

  // ── Page 3: Earn (Figma 711:1222) ──────────────────────────
  _OnboardingPageData(
    kind: _PageKind.earn,
    badge: 'Earn.',
    title: TextSpan(
      style: _titleBase,
      children: const [
        TextSpan(text: 'Influence and earn\nReal money'),
      ],
    ),
    subtitle:
        'Share videos, ideas and helpful tips on anything you know. Your content can earn you real money.',
    waveAsset: AppImages.onboardingWaveEarn,
    waveStyle: _WaveStyle.dome,
    actionsTop: 760,
    waveLeft: -24,
    waveTop: 781,
  ),
];

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final sx = size.width / _figmaW;
    final sy = size.height / _figmaH;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.23],
          colors: [
            AppColors.onboardingBgTop,
            AppColors.onboardingBgBottom,
          ],
        ),
      ),
      child: switch (data.kind) {
        _PageKind.post => _PostPage(data: data, sx: sx, sy: sy),
        _PageKind.influence => _InfluencePage(data: data, sx: sx, sy: sy),
        _PageKind.earn => _EarnPage(data: data, sx: sx, sy: sy),
      },
    );
  }
}

Widget _textBlock(_OnboardingPageData data, double sx, double sy) {
  return Positioned(
    left: 20 * sx,
    top: 88 * sy,
    width: 350 * sx,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: _badgeStyle,
            children: [
              TextSpan(text: data.badge.replaceAll('.', '')),
              TextSpan(
                text: '.',
                style: _badgeStyle.copyWith(
                  color: AppColors.onboardingBadgeDot,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20 * sy),
        Text.rich(data.title),
        SizedBox(height: 20 * sy),
        Text(
          data.subtitle,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.35,
            color: AppColors.onboardingSubtitle,
          ),
        ),
      ],
    ),
  );
}

/// Page 1 — illustration centered below text (Figma 711:1115 left:43 top:303)
class _PostPage extends StatelessWidget {
  const _PostPage({
    required this.data,
    required this.sx,
    required this.sy,
  });

  final _OnboardingPageData data;
  final double sx;
  final double sy;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _textBlock(data, sx, sy),
        Positioned(
          left: 43 * sx,
          top: 303 * sy,
          width: 320 * sx,
          height: 420 * sy,
          child: Image.asset(
            AppImages.onboarding1,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

/// Page 2 — Figma 711:1117 absolute phone + social illustration
class _InfluencePage extends StatelessWidget {
  const _InfluencePage({
    required this.data,
    required this.sx,
    required this.sy,
  });

  final _OnboardingPageData data;
  final double sx;
  final double sy;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _textBlock(data, sx, sy),
        // Phone — inset 32.5% / 50.95% / 37.6% / 15.78%
        Positioned(
          left: 0.1578 * size.width,
          top: 0.325 * size.height,
          width: (1 - 0.1578 - 0.5095) * size.width,
          height: (1 - 0.325 - 0.376) * size.height,
          child: SvgPicture.asset(
            AppImages.onboarding21,
            fit: BoxFit.contain,
          ),
        ),
        // Social person — left:140 top:570 w:196 h:156.923
        Positioned(
          left: 200 * sx,
          top: 413 * sy,
          width: 196 * sx,
          height: 156.923 * sy,
          child: SvgPicture.asset(
            AppImages.onboarding22,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

/// Page 3 — Figma 711:1222 earnings card + person
class _EarnPage extends StatelessWidget {
  const _EarnPage({
    required this.data,
    required this.sx,
    required this.sy,
  });

  final _OnboardingPageData data;
  final double sx;
  final double sy;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _textBlock(data, sx, sy),
        // Chart card — Figma 711:1233 left:58 top:350 w:197.72 h:159
        Positioned(
          left: 58 * sx,
          top: 350 * sy,
          width: 197.72 * sx,
          height: 159 * sy,
          child: const _EarningsCard(),
        ),
        // Person — inset 52.02% / 11.99% / 23.67% / 42.48%, flipped on X
        Positioned(
          left: 0.4248 * size.width,
          top: 0.5202 * size.height,
          width: (1 - 0.4248 - 0.1199) * size.width,
          height: (1 - 0.5202 - 0.2367) * size.height,
          child: Transform.flip(
            flipX: true,
            child: SvgPicture.asset(
              AppImages.onboarding32,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

/// Earnings chart card — Figma 711:1233
class _EarningsCard extends StatelessWidget {
  const _EarningsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.5),
        border: Border.all(color: AppColors.onboardingCardBorder, width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x214C4DDC),
            blurRadius: 20,
            offset: Offset(0, 7),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Earnings',
                      style: GoogleFonts.roboto(
                        fontSize: 7.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onboardingCardLabel,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'रू 12,450',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onboardingGreen,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: AppColors.onboardingGrowthBg,
                  borderRadius: BorderRadius.circular(6.5),
                ),
                child: Text(
                  '+32%',
                  style: GoogleFonts.roboto(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onboardingGrowthText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'This Month',
            style: GoogleFonts.roboto(
              fontSize: 7.5,
              fontWeight: FontWeight.w400,
              color: AppColors.onboardingCardLabel,
            ),
          ),
          const SizedBox(height: 6),
          const Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _Bar(flexHeight: 0.36),
                SizedBox(width: 7),
                _Bar(flexHeight: 0.56),
                SizedBox(width: 7),
                _Bar(flexHeight: 0.76),
                SizedBox(width: 7),
                _Bar(flexHeight: 1.0),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Followers',
                      style: GoogleFonts.roboto(
                        fontSize: 6.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onboardingCardLabel,
                      ),
                    ),
                    Text(
                      '8.6K',
                      style: GoogleFonts.roboto(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onboardingCardValue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: AppColors.onboardingWeekBg,
                  borderRadius: BorderRadius.circular(6.5),
                ),
                child: Text(
                  '+1.2K this week',
                  style: GoogleFonts.roboto(
                    fontSize: 6.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onboardingGrowthText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.flexHeight});

  final double flexHeight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FractionallySizedBox(
        heightFactor: flexHeight,
        alignment: Alignment.bottomCenter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.onboardingBarTop,
                AppColors.onboardingBarBottom,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
