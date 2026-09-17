import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:remixicon/remixicon.dart';
import '../../domain/entities/brand_profile_entity.dart';
import '../controllers/brand_detail_controller.dart';

/// Brand detail — Figma 725:2457 (Active Campaigns band).
class BrandDetailView extends StatelessWidget {
  const BrandDetailView({super.key, required this.brandId});

  final String brandId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BrandDetailController>(tag: brandId);

    return Scaffold(
      // Green shows through below Active Campaigns when content is short.
      backgroundColor: const Color(0xFFF4FAE8),
      body: Obx(() {
        final detail = controller.brandDetail.value;

        if (controller.isLoading.value && detail == null) {
          return const ColoredBox(
            color: Colors.white,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.error.value != null && detail == null) {
          return ColoredBox(
            color: Colors.white,
            child: SafeArea(
              child: Center(
                child: TextButton(
                  onPressed: controller.loadBrandDetail,
                  child: const Text("Couldn't load brand — tap to retry"),
                ),
              ),
            ),
          );
        }

        if (detail == null) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ColoredBox(
                  color: Colors.white,
                  child: _CoverHeader(
                    brand: detail.brand,
                    brandId: brandId,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 52, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail.brand.name,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            height: 32 / 26,
                            color: AppColors.brandName,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          detail.brand.about ??
                              detail.brand.bio ??
                              detail.brand.description ??
                              '',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.35,
                            color: AppColors.brandName,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Active Campaigns',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF353037),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
              // Campaigns sit on green; scaffold bg fills to bottom when
              // there are 0–1 cards (avoids SliverFillRemaining null crash).
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4FAE8),
                    border: Border(
                      top: BorderSide(color: Color(0xFFE6F0E4)),
                    ),
                  ),
                  child: detail.campaigns.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              'No active campaigns right now.',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                color: AppColors.bodyGrey,
                              ),
                            ),
                          ),
                        )
                      : _CampaignsGrid(
                          campaigns: detail.campaigns,
                          brand: detail.brand,
                          onTap: controller.openCampaign,
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _CoverHeader extends StatelessWidget {
  const _CoverHeader({required this.brand, required this.brandId});

  final BrandProfileEntity brand;
  final String brandId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BrandDetailController>(tag: brandId);
    final cover = resolveImageUrl(brand.coverImageUrl);
    final logo = resolveImageUrl(brand.logoUrl);
    final topPad = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 203 + topPad,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: cover == null
                ? Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFDDE8D6), Color(0xFFF4FAE8)],
                      ),
                    ),
                  )
                : Image.network(
                    cover,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFFF4FAE8)),
                  ),
          ),
          Positioned(
            top: topPad + 12,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Material(
                  color: const Color(0xFFF9FFFE),
                  elevation: 1,
                  shadowColor: const Color(0x0D000000),
                  shape: const CircleBorder(
                    side: BorderSide(color: Colors.white),
                  ),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Get.back(),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        RemixIcons.arrow_left_s_line,
                        size: 22,
                        color: Color(0xFF353037),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Obx(() {
                  final isFav =
                      controller.brandDetail.value?.brand.isFavourite ??
                      brand.isFavourite;
                  final busy = controller.isTogglingFavourite.value;
                  return Material(
                    color: const Color(0xFFF9FFFE),
                    elevation: 1,
                    shadowColor: const Color(0x0D000000),
                    shape: const CircleBorder(
                      side: BorderSide(color: Colors.white),
                    ),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: busy ? null : controller.toggleFavourite,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: busy
                            ? const Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                isFav
                                    ? RemixIcons.heart_fill
                                    : RemixIcons.heart_line,
                                size: 20,
                                color: isFav
                                    ? const Color(0xFFE11D48)
                                    : const Color(0xFF353037),
                              ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Positioned(
            left: 20,
            bottom: -39.5,
            child: Container(
              width: 79,
              height: 79,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 7.5,
                    offset: const Offset(0, -2.5),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 14.8,
                    offset: const Offset(0, 9.9),
                  ),
                ],
              ),
              child: ClipOval(
                child: logo == null
                    ? const ColoredBox(
                        color: Color(0xFFF3F4F6),
                        child: Icon(
                          RemixIcons.store_2_line,
                          size: 28,
                          color: AppColors.heading,
                        ),
                      )
                    : Image.network(
                        logo,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const ColoredBox(
                          color: Color(0xFFF3F4F6),
                          child: Icon(
                            RemixIcons.store_2_line,
                            size: 28,
                            color: AppColors.heading,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignsGrid extends StatelessWidget {
  const _CampaignsGrid({
    required this.campaigns,
    required this.brand,
    required this.onTap,
  });

  final List<CampaignEntity> campaigns;
  final BrandProfileEntity brand;
  final void Function(CampaignEntity) onTap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < campaigns.length; i += 2) {
      final left = campaigns[i];
      final hasRight = i + 1 < campaigns.length;
      final right = hasRight ? campaigns[i + 1] : null;

      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i + 2 < campaigns.length ? 16 : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ActiveCampaignCard(
                  campaign: left,
                  brand: brand,
                  badge: i.isEven ? 'Popular' : 'Trending',
                  onTap: () => onTap(left),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : _ActiveCampaignCard(
                        campaign: right,
                        brand: brand,
                        badge: (i + 1).isEven ? 'Popular' : 'Trending',
                        onTap: () => onTap(right),
                      ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

/// Active campaign card — Figma 725:2501 + dashed reward box.
class _ActiveCampaignCard extends StatelessWidget {
  const _ActiveCampaignCard({
    required this.campaign,
    required this.brand,
    required this.badge,
    required this.onTap,
  });

  final CampaignEntity campaign;
  final BrandProfileEntity brand;
  final String badge;
  final VoidCallback onTap;

  static final _amountFormat = NumberFormat('#,##0');

  String get _rewardAmount {
    if (campaign.earnRangeLabel.isNotEmpty) {
      var label = campaign.earnRangeLabel.trim();
      label = label.replaceFirst(
        RegExp(r'^(up\s*to\s*)', caseSensitive: false),
        '',
      );
      label = label.replaceFirst(
        RegExp(r'\s*per\s+creator.*$', caseSensitive: false),
        '',
      );
      label = label.replaceFirst(RegExp(r'^NPR\s*', caseSensitive: false), 'रू ');
      return label.trim();
    }
    if (campaign.creatorMaxReward > 0) {
      return 'रू ${_amountFormat.format(campaign.creatorMaxReward)}';
    }
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final cover = resolveImageUrl(
      campaign.brandCoverUrl ?? brand.coverImageUrl,
    );
    final logo = resolveImageUrl(campaign.brandLogoUrl ?? brand.logoUrl);
    final title =
        campaign.brandName.isNotEmpty ? campaign.brandName : brand.name;
    final category = (campaign.brandCategory ?? brand.categoryName)?.trim();
    final tagline = campaign.name.trim().isNotEmpty
        ? campaign.name.trim()
        : campaign.objective.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 108,
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 90,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: ColoredBox(
                          color: const Color(0xFFFFF7ED),
                          child: cover == null
                              ? const SizedBox.shrink()
                              : Image.network(
                                  cover,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 90,
                                  errorBuilder: (_, __, ___) =>
                                      const SizedBox.shrink(),
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2.25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFF7FAF6),
                            width: 0.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40000000),
                              blurRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            height: 11.25 / 9,
                            color: Color(0xFF426340),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 6,
                      bottom: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 3.813,
                              offset: const Offset(0, -1.25),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: logo == null
                              ? const ColoredBox(
                                  color: Color(0xFFF3F4F6),
                                  child: Icon(
                                    RemixIcons.store_2_line,
                                    size: 16,
                                  ),
                                )
                              : Image.network(
                                  logo,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const ColoredBox(
                                        color: Color(0xFFF3F4F6),
                                        child: Icon(
                                          RemixIcons.store_2_line,
                                          size: 16,
                                        ),
                                      ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 16 / 14,
                        color: Color(0xFF433D46),
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (category != null && category.isNotEmpty)
                      Text(
                        category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 15 / 10,
                          color: Color(0xFF6E6971),
                        ),
                      ),
                    if (tagline.isNotEmpty)
                      Text(
                        tagline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 15 / 10,
                          color: Color(0xFF6E6971),
                        ),
                      ),
                    const SizedBox(height: 10),
                    _CampaignRewardBox(amount: _rewardAmount),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _SocialBubbles(
                            platforms: brand.connectedPlatforms,
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFEDECED),
                              width: 0.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x08000000),
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppImages.iconChevronRight,
                            width: 12.5,
                            height: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mint dashed reward callout — "Up to रू X,XXX / max reward".
class _CampaignRewardBox extends StatelessWidget {
  const _CampaignRewardBox({required this.amount});

  final String amount;

  static const _bg = Color(0xFFF4FAE8);
  static const _border = Color(0xFFBED9BA);
  static const _label = Color(0xFF557F52);
  static const _amount = Color(0xFF353037);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: const _DashedRRectPainter(
        color: _border,
        radius: 10,
        dash: 2.5,
        gap: 2,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Up to ',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 14 / 11,
                      color: _label,
                    ),
                  ),
                  TextSpan(
                    text: amount,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 16 / 13,
                      color: _amount,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Text(
              'max reward',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 13 / 10,
                color: _label,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.radius,
    this.dash = 2,
    this.gap = 2,
  });

  final Color color;
  final double radius;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.dash != dash ||
      oldDelegate.gap != gap;
}

class _SocialBubbles extends StatelessWidget {
  const _SocialBubbles({required this.platforms});

  final List<String> platforms;

  @override
  Widget build(BuildContext context) {
    final shown = platforms.take(3).toList();
    if (shown.isEmpty) {
      return Row(
        children: const [
          _Bubble(
            color: Color(0x14FF007F),
            icon: RemixIcons.instagram_fill,
            iconColor: Color(0xFFE1306C),
          ),
          SizedBox(width: 5),
          _Bubble(
            color: Color(0x14000000),
            icon: RemixIcons.tiktok_fill,
            iconColor: Colors.black,
          ),
          SizedBox(width: 5),
          _Bubble(
            color: Color(0xFFE9EFFD),
            icon: RemixIcons.facebook_fill,
            iconColor: Color(0xFF1877F2),
          ),
        ],
      );
    }
    return Row(
      children: [
        for (var i = 0; i < shown.length; i++) ...[
          if (i > 0) const SizedBox(width: 5),
          _bubbleFor(shown[i]),
        ],
      ],
    );
  }

  Widget _bubbleFor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const _Bubble(
          color: Color(0x14FF007F),
          icon: RemixIcons.instagram_fill,
          iconColor: Color(0xFFE1306C),
        );
      case 'tiktok':
        return const _Bubble(
          color: Color(0x14000000),
          icon: RemixIcons.tiktok_fill,
          iconColor: Colors.black,
        );
      case 'youtube':
        return const _Bubble(
          color: Color(0x14E02020),
          icon: RemixIcons.youtube_fill,
          iconColor: Color(0xFFE02020),
        );
      case 'facebook':
        return const _Bubble(
          color: Color(0xFFE9EFFD),
          icon: RemixIcons.facebook_fill,
          iconColor: Color(0xFF1877F2),
        );
      default:
        return const _Bubble(
          color: Color(0xFFF3F4F6),
          icon: RemixIcons.links_line,
          iconColor: Color(0xFF6E6971),
        );
    }
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  final Color color;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Icon(icon, size: 11, color: iconColor),
    );
  }
}
