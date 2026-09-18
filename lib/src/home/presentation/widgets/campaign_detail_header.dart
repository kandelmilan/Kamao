import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:remixicon/remixicon.dart';

/// Campaign header — Figma 725:2638 (412×193 cover + overlapping logo).
class CampaignDetailHeader extends StatelessWidget {
  const CampaignDetailHeader({
    super.key,
    required this.campaign,
    required this.isFavourite,
    required this.isTogglingFavourite,
    required this.onBack,
    required this.onBookmark,
  });

  final CampaignDetailEntity campaign;
  final bool isFavourite;
  final bool isTogglingFavourite;
  final VoidCallback onBack;
  final VoidCallback onBookmark;

  /// Design frame height (excludes status bar).
  static const double headerHeight = 193;
  static const double logoSize = 79;
  static const double logoInnerSize = 55.3;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final coverUrl = resolveImageUrl(campaign.brandCoverUrl);
    final logoUrl = resolveImageUrl(campaign.brandLogoUrl);

    // Logo sits at y=145 in the 193 design frame → hangs ~31px below header.
    const logoTopInHeader = 145.0;
    final logoOverlap = (logoTopInHeader + logoSize) - headerHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: headerHeight + topPadding,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                  child: coverUrl != null
                      ? Image.network(
                          coverUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          errorBuilder: (_, __, ___) => const _HeaderFallback(),
                        )
                      : const _HeaderFallback(),
                ),
              ),
              Positioned(
                top: topPadding + 8,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    _NavCircle(
                      onTap: onBack,
                      background: const Color(0xFFF9FFFE),
                      border: Colors.white,
                      child: const Icon(
                        RemixIcons.arrow_left_s_line,
                        size: 20,
                        color: Color(0xFF353037),
                      ),
                    ),
                    const Spacer(),
                    _NavCircle(
                      onTap: isTogglingFavourite ? null : onBookmark,
                      background: const Color(0xE6FFFFFF),
                      border: const Color(0x80E2E8F0),
                      child: Icon(
                        isFavourite
                            ? RemixIcons.heart_fill
                            : RemixIcons.heart_line,
                        size: 20,
                        color: isFavourite
                            ? const Color(0xFFE11D48)
                            : const Color(0xFF353037),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                top: topPadding + logoTopInHeader,
                child: Container(
                  width: logoSize,
                  height: logoSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x40000000),
                        blurRadius: 7.53,
                        offset: const Offset(0, -2.47),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: logoInnerSize,
                    height: logoInnerSize,
                    child: ClipOval(
                      child: logoUrl != null
                          ? Image.network(logoUrl, fit: BoxFit.cover)
                          : ColoredBox(
                              color: AppColors.onboardingGreen,
                              child: Center(
                                child: Text(
                                  campaign.brandName.isNotEmpty
                                      ? campaign.brandName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: logoOverlap + 12),
      ],
    );
  }
}

/// Brand name, Join Campaign / Submit Post, tagline — Figma 725:2657.
class CampaignHeaderTitles extends StatelessWidget {
  const CampaignHeaderTitles({
    super.key,
    required this.campaign,
    required this.isJoining,
    required this.alreadyJoined,
    required this.onJoin,
  });

  final CampaignDetailEntity campaign;
  final bool isJoining;
  final bool alreadyJoined;
  final VoidCallback onJoin;

  static const _brandText = Color(0xFF433D46);

  String get _subtitle {
    if (campaign.name.trim().isNotEmpty &&
        campaign.name.trim() != campaign.brandName.trim()) {
      return campaign.name;
    }
    if (campaign.objective.trim().isNotEmpty) return campaign.objective;
    if (campaign.brandCategory != null &&
        campaign.brandCategory!.trim().isNotEmpty) {
      return campaign.brandCategory!;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                campaign.brandName.isNotEmpty ? campaign.brandName : 'Campaign',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  height: 32 / 26,
                  color: _brandText,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _JoinCampaignButton(
              isJoining: isJoining,
              alreadyJoined: alreadyJoined,
              onTap: onJoin,
            ),
          ],
        ),
        if (_subtitle.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            _subtitle,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.0,
              color: _brandText,
            ),
          ),
        ],
      ],
    );
  }
}

class _HeaderFallback extends StatelessWidget {
  const _HeaderFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.98, -0.17),
          end: Alignment(0.98, 0.17),
          colors: [Color(0xFFFFFFFF), Color(0xFFF5FAEB)],
          stops: [0.4977, 1.0],
        ),
      ),
    );
  }
}

class _JoinCampaignButton extends StatelessWidget {
  const _JoinCampaignButton({
    required this.isJoining,
    required this.alreadyJoined,
    required this.onTap,
  });

  final bool isJoining;
  final bool alreadyJoined;
  final VoidCallback onTap;

  /// Figma: ~103×29, radius 8, padding 8×14,
  /// linear-gradient(275.24deg, #25DA1F -42.13%, #334D32 70.04%).
  static const double _height = 29;

  @override
  Widget build(BuildContext context) {
    final label = alreadyJoined ? 'Submit Post' : 'Join Campaign';

    return SizedBox(
      height: _height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: const [Color(0xFF25DA1F), Color(0xFF334D32)],
              // CSS stop -42.13% → clamp to 0; 70.04% → 0.7004
              stops: const [0.0, 0.7004],
              // CSS 275.24deg → Flutter GradientRotation (deg − 90)
              transform: GradientRotation((275.24 - 90) * math.pi / 180),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isJoining ? null : onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Center(
                  child: isJoining
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.6,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavCircle extends StatelessWidget {
  const _NavCircle({
    required this.onTap,
    required this.background,
    required this.border,
    required this.child,
  });

  final VoidCallback? onTap;
  final Color background;
  final Color border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                  border: Border.all(color: border),
                ),
                child: Center(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
