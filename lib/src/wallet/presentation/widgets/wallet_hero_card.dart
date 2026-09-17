import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';

/// Green wallet hero used on Home and Wallet (Figma 660:2074).
class WalletHeroCard extends StatelessWidget {
  const WalletHeroCard({
    super.key,
    required this.balanceLabel,
    required this.weeklyGrowthLabel,
    required this.ctaLabel,
    required this.onCtaTap,
  });

  final String balanceLabel;
  final String weeklyGrowthLabel;
  final String ctaLabel;
  final VoidCallback onCtaTap;

  /// Design frame width used for proportional layout.
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
              // Large leaf blob (right side) — Figma 660:2109
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
              // Top-right rotated leaf — Figma 662:2140
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
              // Wallet + coins illustration (home overlay 663:2147)
              Positioned(
                left: 172 * s,
                top: 60 * s,
                width: 114 * s,
                height: 87 * s,
                child: Image.asset(
                  AppImages.walletCoins,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              // Balance block — Figma 660:2079
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
                    Text(
                      balanceLabel,
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
                    ),
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
              // Weekly growth badge — Figma 660:2089
              Positioned(
                left: 267 * s,
                top: 19 * s,
                child: _WeeklyGrowthBadge(
                  label: weeklyGrowthLabel,
                  scale: s,
                ),
              ),
              // CTA — Figma 660:2099
              Positioned(
                left: 19 * s,
                bottom: 34 * s,
                child: InkWell(
                  onTap: onCtaTap,
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
                          ctaLabel,
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
