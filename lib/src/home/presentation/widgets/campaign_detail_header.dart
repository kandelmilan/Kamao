import 'package:flutter/material.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:remixicon/remixicon.dart';

/// Campaign header — Figma 725:2638 (412×193 soft gradient).
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
  static const Color _brandText = Color(0xFF433D46);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final coverUrl = resolveImageUrl(campaign.brandCoverUrl);
    final logoUrl = resolveImageUrl(campaign.brandLogoUrl);

    // Logo sits at y=145 in the 193 design frame → hangs ~31px below header.
    const logoTopInHeader = 145.0;
    final logoOverlap = (logoTopInHeader + logoSize) - headerHeight; // ~31

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
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Soft header gradient (Figma).
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-0.98, -0.17),
                            end: Alignment(0.98, 0.17),
                            colors: [
                              Color(0xFFFFFFFF),
                              Color(0xFFF5FAEB),
                            ],
                            stops: [0.4977, 1.0],
                          ),
                        ),
                      ),
                      if (coverUrl != null)
                        Opacity(
                          opacity: 0.92,
                          child: Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (_, __, ___) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      if (coverUrl != null)
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x00000000),
                                Color(0x66FFFFFF),
                                Color(0xFFF5FAEB),
                              ],
                              stops: [0.35, 0.72, 1.0],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: topPadding + 8,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    _GlassCircle(
                      icon: RemixIcons.arrow_left_s_line,
                      onTap: onBack,
                    ),
                    const Spacer(),
                    _GlassCircle(
                      icon: isFavourite
                          ? RemixIcons.heart_fill
                          : RemixIcons.heart_line,
                      onTap: isTogglingFavourite ? null : onBookmark,
                      iconColor: isFavourite
                          ? const Color(0xFFE86161)
                          : AppColors.heading,
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
                  padding: const EdgeInsets.all(4.94),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x40000000),
                        blurRadius: 15.06,
                        offset: const Offset(0, -2.47),
                      ),
                    ],
                  ),
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
            ],
          ),
        ),
        SizedBox(height: logoOverlap + 12),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                campaign.brandName.isNotEmpty
                    ? campaign.brandName
                    : 'Campaign',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  height: 32 / 26,
                  color: _brandText,
                ),
              ),
              if (_subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
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
          ),
        ),
      ],
    );
  }

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
}

class _GlassCircle extends StatelessWidget {
  const _GlassCircle({
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.heading,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 1.5,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 22, color: iconColor),
        ),
      ),
    );
  }
}
