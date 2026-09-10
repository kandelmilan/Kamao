import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:remixicon/remixicon.dart';
import '../../domain/entities/brand_detail_entity.dart';
import '../../domain/entities/brand_profile_entity.dart';
import '../controllers/brand_detail_controller.dart';

class BrandDetailView extends StatelessWidget {
  const BrandDetailView({super.key, required this.brandId});

  final String brandId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BrandDetailController>(tag: brandId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final detail = controller.brandDetail.value;

          if (controller.isLoading.value && detail == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error.value != null && detail == null) {
            return Center(
              child: TextButton(
                onPressed: controller.loadBrandDetail,
                child: const Text("Couldn't load brand — tap to retry"),
              ),
            );
          }

          if (detail == null) return const SizedBox.shrink();

          return Column(
            children: [
              _BrandHeader(brand: detail.brand),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      children: [
                        if ((detail.brand.about ?? detail.brand.bio) != null)
                          _AboutCard(brand: detail.brand),
                        const SizedBox(height: 14),
                        _StatsRow(brand: detail.brand),
                        if (detail.brand.postTips.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          _PostTipsCard(tips: detail.brand.postTips),
                        ],
                        if (detail.brand.postsPer7Days > 0 ||
                            detail.brand.postsPer12Months > 0) ...[
                          const SizedBox(height: 14),
                          _PostLimitsCard(brand: detail.brand),
                        ],
                        if (_hasLinks(detail.brand)) ...[
                          const SizedBox(height: 14),
                          _LinksCard(brand: detail.brand),
                        ],
                        const SizedBox(height: 20),
                        Text(
                          'Live Campaigns',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cardTitle,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...detail.campaigns.map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _CampaignRow(
                              campaign: c,
                              onTap: () => controller.openCampaign(c),
                            ),
                          ),
                        ),
                        if (detail.campaigns.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                'No live campaigns right now.',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 13,
                                  color: AppColors.bodyGrey,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  bool _hasLinks(BrandProfileEntity brand) {
    return (brand.websiteUrl != null && brand.websiteUrl!.isNotEmpty) ||
        brand.connectedPlatforms.isNotEmpty;
  }
}

/// Gradient header — back/share/bookmark row, brand identity, the
/// green "Earn upto / Receipt required" line, and "Post on" chips
/// for whichever platforms the brand has handles for.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.brand});

  final BrandProfileEntity brand;

  @override
  Widget build(BuildContext context) {
    final logoUrl = resolveImageUrl(brand.logoUrl);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4B0070), Color(0xFF2E0046)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleIconButton(
                icon: RemixIcons.arrow_left_line,
                onTap: () => Get.back(),
              ),
              Row(
                children: [
                  _CircleIconButton(icon: RemixIcons.share_line, onTap: () {}),
                  const SizedBox(width: 8),
                  _CircleIconButton(
                    icon: RemixIcons.bookmark_line,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: logoUrl == null
                    ? const Icon(
                        RemixIcons.store_2_line,
                        size: 22,
                        color: Color(0xFF4B0070),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          logoUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                RemixIcons.store_2_line,
                                size: 22,
                                color: Color(0xFF4B0070),
                              ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand.name,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    if (brand.categoryName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        brand.categoryName!,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                RemixIcons.money_dollar_circle_line,
                size: 15,
                color: Color(0xFF4ADE80),
              ),
              const SizedBox(width: 4),
              Text(
                'Earn upto ${brand.currency} ${brand.maxRewardAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4ADE80),
                ),
              ),
              if (brand.receiptRequired) ...[
                const SizedBox(width: 8),
                const Text(
                  '•',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Receipt required',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4ADE80),
                  ),
                ),
              ],
            ],
          ),
          if (brand.connectedPlatforms.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Post on : ',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                Wrap(
                  spacing: 6,
                  children: brand.connectedPlatforms
                      .map((p) => _PlatformChip(platform: p))
                      .toList(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.16),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 17, color: Colors.white),
      ),
    );
  }
}

class _PlatformChip extends StatelessWidget {
  const _PlatformChip({required this.platform});

  final String platform;

  IconData get _icon {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return RemixIcons.instagram_fill;
      case 'tiktok':
        return RemixIcons.tiktok_fill;
      case 'youtube':
        return RemixIcons.youtube_fill;
      case 'facebook':
        return RemixIcons.facebook_fill;
      default:
        return RemixIcons.links_line;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            platform,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDECED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.cardTitle,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.brand});

  final BrandProfileEntity brand;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'About ${brand.name}',
      child: Text(
        brand.about ?? brand.bio ?? '',
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 13.5,
          height: 1.5,
          color: Color(0xFF3F3F46),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.brand});

  final BrandProfileEntity brand;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: RemixIcons.fire_fill,
            label: 'Live Campaigns',
            value: '${brand.liveCampaignCount}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            icon: RemixIcons.trophy_fill,
            label: 'Max Reward',
            value:
                '${brand.currency} ${brand.maxRewardAmount.toStringAsFixed(0)}',
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF4B0070)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11.5,
              color: AppColors.bodyGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostTipsCard extends StatelessWidget {
  const _PostTipsCard({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Post Tips',
      child: Column(
        children: tips
            .map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(top: 1),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE7F9EF),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        RemixIcons.check_line,
                        size: 12,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13.5,
                          color: Color(0xFF3F3F46),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PostLimitsCard extends StatelessWidget {
  const _PostLimitsCard({required this.brand});

  final BrandProfileEntity brand;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Post Limits',
      child: Row(
        children: [
          Expanded(
            child: _LimitBox(
              label: '7 - DAY PERIOD',
              value: 'Upto ${brand.postsPer7Days} posts',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _LimitBox(
              label: '12 - MONTH PERIOD',
              value: 'Upto ${brand.postsPer12Months} posts',
            ),
          ),
        ],
      ),
    );
  }
}

class _LimitBox extends StatelessWidget {
  const _LimitBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDECED)),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: AppColors.bodyGrey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinksCard extends StatelessWidget {
  const _LinksCard({required this.brand});

  final BrandProfileEntity brand;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'About',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (brand.websiteUrl != null && brand.websiteUrl!.isNotEmpty)
            _LinkChip(icon: RemixIcons.global_line, label: brand.websiteUrl!),
          if (brand.instagramHandle != null &&
              brand.instagramHandle!.isNotEmpty)
            _LinkChip(
              icon: RemixIcons.instagram_fill,
              label: '@${brand.instagramHandle}',
            ),
          if (brand.tikTokHandle != null && brand.tikTokHandle!.isNotEmpty)
            _LinkChip(
              icon: RemixIcons.tiktok_fill,
              label: '@${brand.tikTokHandle}',
            ),
          if (brand.youTubeHandle != null && brand.youTubeHandle!.isNotEmpty)
            _LinkChip(
              icon: RemixIcons.youtube_fill,
              label: brand.youTubeHandle!,
            ),
          if (brand.facebookHandle != null && brand.facebookHandle!.isNotEmpty)
            _LinkChip(
              icon: RemixIcons.facebook_fill,
              label: brand.facebookHandle!,
            ),
        ],
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  const _LinkChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDECED)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.heading),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              color: AppColors.heading,
            ),
          ),
        ],
      ),
    );
  }
}

/// Row for a single live campaign under the brand.
///
/// NOTE: `name`, `status`, and `earnRangeLabel` are assumed to exist
/// on your `CampaignEntity` (matching the JSON keys from this
/// endpoint) — adjust the property names below if your entity calls
/// them something else.
class _CampaignRow extends StatelessWidget {
  const _CampaignRow({required this.campaign, required this.onTap});

  final CampaignEntity campaign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEDECED)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cardTitle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    campaign.earnRangeLabel,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      color: AppColors.bodyGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0x42E8F6ED),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF16A34A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
