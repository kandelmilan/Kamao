import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:remixicon/remixicon.dart';
import '../../domain/entities/brand_profile_entity.dart';
import '../controllers/brand_detail_controller.dart';

/// Brand detail — Figma node 678:3707.
class BrandDetailView extends StatelessWidget {
  const BrandDetailView({super.key, required this.brandId});

  final String brandId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BrandDetailController>(tag: brandId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final detail = controller.brandDetail.value;

        if (controller.isLoading.value && detail == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null && detail == null) {
          return SafeArea(
            child: Center(
              child: TextButton(
                onPressed: controller.loadBrandDetail,
                child: const Text("Couldn't load brand — tap to retry"),
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
                child: _CoverHeader(
                  brand: detail.brand,
                  brandId: brandId,
                ),
              ),
              SliverToBoxAdapter(
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
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4FAE8),
                    border: Border.all(color: const Color(0xFFE6F0E4)),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = 16.0;
        final cardWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: campaigns
              .map(
                (c) => SizedBox(
                  width: cardWidth,
                  child: _ActiveCampaignCard(
                    campaign: c,
                    brand: brand,
                    onTap: () => onTap(c),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _ActiveCampaignCard extends StatelessWidget {
  const _ActiveCampaignCard({
    required this.campaign,
    required this.brand,
    required this.onTap,
  });

  final CampaignEntity campaign;
  final BrandProfileEntity brand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cover = resolveImageUrl(campaign.brandCoverUrl ?? brand.coverImageUrl);
    final logo = resolveImageUrl(campaign.brandLogoUrl ?? brand.logoUrl);
    final category = campaign.brandCategory ?? brand.categoryName;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: cover == null
                        ? Container(color: const Color(0xFFFFF7ED))
                        : Image.network(
                            cover,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: const Color(0xFFFFF7ED)),
                          ),
                  ),
                  if (campaign.isFavourite)
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
                        child: const Text(
                          'Popular',
                          style: TextStyle(
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
                    bottom: -18,
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
                            blurRadius: 3.8,
                            offset: const Offset(0, -1.25),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: logo == null
                            ? const Icon(RemixIcons.store_2_line, size: 16)
                            : Image.network(logo, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.brandName.isNotEmpty
                        ? campaign.brandName
                        : campaign.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 16 / 14,
                      color: AppColors.brandName,
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
                        height: 1.5,
                        color: Color(0xFF6E6971),
                      ),
                    ),
                  Text(
                    campaign.objective.isNotEmpty
                        ? campaign.objective
                        : campaign.earnRangeLabel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color(0xFF6E6971),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _SocialBubbles(platforms: brand.connectedPlatforms),
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
                        child: const Icon(
                          RemixIcons.arrow_right_s_line,
                          size: 12,
                          color: Color(0xFF6E6971),
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
    );
  }
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
