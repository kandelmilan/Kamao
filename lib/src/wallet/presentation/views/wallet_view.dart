import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/wallet_controller.dart';
import '../widgets/wallet_activity_widgets.dart';

// ═════════════════════════════════════════════════════════════
// Palette — soft green backdrop (Campaign App / Figma 678:5496).
// ═════════════════════════════════════════════════════════════
class _Palette {
  const _Palette._();

  static const gradientTop = AppColors.onboardingBgTop;
}

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  static const int _previewCount = 5;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Solid base so this page renders correctly whether it's
          // embedded in MainNav's Scaffold or pushed as its own route
          // (e.g. from Profile) — the gradient below only paints the
          // top 260px, so without this the rest falls through to
          // whatever's behind WalletView, which is black on its own.
          const Positioned.fill(child: ColoredBox(color: Colors.white)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_Palette.gradientTop, Colors.white],
                  stops: [0.0, 0.85],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: controller.refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _WalletHeader(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _BalanceCard(controller: controller),
                    ),
                    Obx(() {
                      final hint = controller.walletHintMessage;
                      if (hint == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Obx(
                          () => _HintBanner(body: controller.hintBody),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: _ActivitySectionHeader(controller: controller),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                      child: WalletActivityTabs(controller: controller),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: WalletActivityList(
                        controller: controller,
                        maxItems: _previewCount,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletHeader extends StatelessWidget {
  const _WalletHeader();

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 12),
      child: Row(
        children: [
          if (canPop)
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                RemixIcons.arrow_left_s_line,
                size: 28,
                color: AppColors.heading,
              ),
            )
          else
            const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Wallet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
          ),
          // Keeps title optically centered with the back button.
          SizedBox(width: canPop ? 48 : 12),
        ],
      ),
    );
  }
}

/// Balance hero — same green card system as home `_WalletCard`
/// (Figma 660:2074), adapted for the wallet page (Figma 678:5496).
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.controller});

  final WalletController controller;

  static const _designW = 372.0;
  static const _designH = 179.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final s = w / _designW;
        final h = _designH * s;

        return Container(
          height: h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20 * s),
            border: Border.all(color: AppColors.walletBorder),
            gradient: const LinearGradient(
              begin: Alignment(-0.85, -0.4),
              end: Alignment(0.9, 0.6),
              colors: [
                AppColors.walletGradientStart,
                AppColors.walletGradientEnd,
              ],
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Positioned(
                left: 199 * s,
                top: -16 * s,
                width: 162.045 * s,
                height: 212.077 * s,
                child: SvgPicture.asset(
                  AppImages.walletCardLeafLarge,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 321 * s,
                top: 117 * s,
                width: 60 * s,
                height: 73 * s,
                child: SvgPicture.asset(
                  AppImages.walletCardLeafBr,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 358.04 * s,
                top: 10.75 * s,
                width: 66.924 * s,
                height: 61.779 * s,
                child: Transform.rotate(
                  angle: -70.48 * 3.1415926535 / 180,
                  child: SvgPicture.asset(
                    AppImages.walletCardLeafTr,
                    width: 46.18 * s,
                    height: 54.635 * s,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Positioned(
              //   left: 188 * s,
              //   top: 68 * s,
              //   width: 114 * s,
              //   height: 87 * s,
              //   child: Image.asset(
              //     AppImages.walletCoins,
              //     fit: BoxFit.contain,
              //     alignment: Alignment.bottomCenter,
              //   ),
              // ),
               Positioned(
                left: 172 * s,//188 * s,
                top: 60 * s,//68 * s,
                width: 114 * s,
                height: 87 * s,
                child: Image.asset(
                  AppImages.walletCoins,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Positioned(
                left: 18 * s,
                top: 18 * s,
                right: 120 * s,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR WALLET',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10 * s,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        height: 15 / 10,
                        color: AppColors.walletLabel,
                      ),
                    ),
                    SizedBox(height: 2 * s),
                    Obx(() {
                      if (controller.isLoading.value &&
                          controller.summary.value == null) {
                        return SizedBox(
                          height: 28 * s,
                          width: 28 * s,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.walletBalance,
                          ),
                        );
                      }
                      return Text(
                        controller.formattedAvailableBalance,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 28 * s,
                          fontWeight: FontWeight.w600,
                          height: 42 / 28,
                          letterSpacing: -0.7,
                          color: AppColors.walletBalance,
                        ),
                      );
                    }),
                    Text(
                      'Available balance',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11 * s,
                        fontWeight: FontWeight.w500,
                        height: 16.5 / 11,
                        color: AppColors.walletLabel,
                      ),
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   left: 267 * s,
              //   top: 19 * s,
              //   child: Obx(
              //     () => _WeeklyGrowthBadge(
              //       label: controller.weeklyGrowthAmountLabel,
              //       scale: s,
              //     ),
              //   ),
              // ),
              Positioned(
                left: 19 * s,
                bottom: 34 * s,
                child: InkWell(
                  onTap: controller.onWithdrawTap,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16 * s,
                      vertical: 8 * s,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.walletButton,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6 * s,
                          offset: Offset(0, 4 * s),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Withdraw',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12 * s,
                            fontWeight: FontWeight.w500,
                            height: 16 / 12,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: 6 * s),
                        SvgPicture.asset(
                          AppImages.walletViewArrow,
                          width: 12 * s,
                          height: 12 * s,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WeeklyGrowthBadge extends StatelessWidget {
  const _WeeklyGrowthBadge({required this.label, this.scale = 1});

  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11 * s, vertical: 7 * s),
      decoration: BoxDecoration(
        color: const Color(0xD9FFFFFF),
        borderRadius: BorderRadius.circular(12 * s),
        border: Border.all(color: const Color(0xE6FFFFFF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2 * s,
            offset: Offset(0, 1 * s),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16 * s,
            height: 16 * s,
            decoration: const BoxDecoration(
              color: Color(0xFFDAE9D7),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppImages.walletGrowthArrow,
              width: 10 * s,
              height: 10 * s,
            ),
          ),
          SizedBox(width: 6 * s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10 * s,
                  fontWeight: FontWeight.w500,
                  height: 12.5 / 10,
                  color: AppColors.heading,
                ),
              ),
              Text(
                'this week',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 9 * s,
                  fontWeight: FontWeight.w500,
                  height: 11.25 / 9,
                  color: const Color(0xFF6E6971),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Green "hint" banner — uses the backend-provided
/// [WalletSummaryEntity.withdrawalHint] when available, and falls back
/// to a generic encouragement message when the API doesn't send one.
class _HintBanner extends StatelessWidget {
  const _HintBanner({this.body});

  final String? body;

  static const String _defaultTitle = 'EARNINGS LOOK GOOD!';
  static const String _defaultBody =
      "You've earned 15% more this week compared to last month. "
      'Keep creating!';

  @override
  Widget build(BuildContext context) {
    final resolvedBody = (body != null && body!.trim().isNotEmpty)
        ? body!
        : _defaultBody;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6ED),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFF94D5AC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.onboardingGreen,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onboardingGreen.withValues(alpha: 0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              RemixIcons.sparkling_line,
              size: 17,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  _defaultTitle,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    letterSpacing: 0.3,
                    color: AppColors.onboardingGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  resolvedBody,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 16.5 / 10,
                    color: AppColors.onboardingGreen.withValues(alpha: 0.9),
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

class _ActivitySectionHeader extends StatelessWidget {
  const _ActivitySectionHeader({required this.controller});

  final WalletController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 24 / 18,
            color: AppColors.heading,
          ),
        ),
        InkWell(
          onTap: controller.onSeeAllActivity,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'See All',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onboardingGreen,
                ),
              ),
              Icon(
                RemixIcons.arrow_right_s_line,
                size: 16,
                color: AppColors.onboardingGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
