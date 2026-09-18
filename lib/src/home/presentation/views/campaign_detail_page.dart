import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/brand/domain/entities/brand_profile_entity.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:kamao/src/home/presentation/controllers/campaign_detail_controller.dart';
import 'package:kamao/src/home/presentation/widgets/campaign_checklist_card.dart';
import 'package:kamao/src/home/presentation/widgets/campaign_detail_header.dart';
import 'package:kamao/src/home/presentation/widgets/select_social_accounts_sheet.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

/// Campaign details — Figma 725:2638.
class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({super.key});

  static const _pageBg = Color(0xFFF7FAF6);
  static const _cardShadow = BoxShadow(
    color: Color(0x0A1A153B),
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CampaignDetailController>();

    return Scaffold(
      backgroundColor: _pageBg,
      body: Obx(() {
        if (controller.isLoading.value && controller.campaign.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.onboardingGreen),
          );
        }
        if (controller.error.value != null &&
            controller.campaign.value == null) {
          return _ErrorState(
            message: controller.error.value!,
            onRetry: controller.loadDetail,
          );
        }
        final c = controller.campaign.value;
        if (c == null) return const SizedBox.shrink();

        final checklist = c.checklistItems
            .where((i) => i.label != 'MUST INCLUDE' && i.label != 'AVOID')
            .toList();
        final includeLines = _includeLines(c);
        final restrictions = _restrictionLines(c);
        final brand = controller.brand.value;
        final aboutLinks = _aboutLinks(brand);

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Obx(
                    () => CampaignDetailHeader(
                      campaign: controller.campaign.value ?? c,
                      isFavourite: (controller.campaign.value ?? c).isFavourite,
                      isTogglingFavourite: controller.isTogglingFavourite.value,
                      onBack: () => Get.back(),
                      onBookmark: controller.toggleFavourite,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Obx(
                        () => CampaignHeaderTitles(
                          campaign: controller.campaign.value ?? c,
                          isJoining: controller.isJoining.value,
                          alreadyJoined:
                              (controller.campaign.value ?? c).alreadyJoined,
                          onJoin: () =>
                              _onJoinOrSubmitPressed(context, controller),
                        ),
                      ),
                      const SizedBox(height: 22),
                      _RewardAndPlatformsRow(campaign: c),
                      const SizedBox(height: 16),
                      _CampaignGoalCard(
                        goal: c.campaignGoal.isNotEmpty
                            ? c.campaignGoal
                            : c.objective,
                      ),
                      if (checklist.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        CampaignChecklistCard(items: checklist),
                      ],
                      if (includeLines.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _IncludeCard(lines: includeLines),
                      ],
                      if (restrictions.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _RestrictionsCard(lines: restrictions),
                      ],
                      const SizedBox(height: 16),
                      _PostLimitsCard(
                        postsPer7Days: brand?.postsPer7Days,
                        postsPer12Months: brand?.postsPer12Months,
                      ),
                      const SizedBox(height: 16),
                      _OtherInfoCard(campaign: c),
                      if (aboutLinks.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _AboutCard(links: aboutLinks),
                      ],
                    ]),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  List<String> _includeLines(CampaignDetailEntity c) {
    final raw = c.brief.includeSummary?.trim();
    if (raw == null || raw.isEmpty) return const [];
    return raw
        .split(RegExp(r'[\n•]+'))
        .expand((line) => line.split(RegExp(r'\s+[–—-]\s+')))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  List<String> _restrictionLines(CampaignDetailEntity c) {
    final raw = c.brief.excludeSummary?.trim();
    if (raw == null || raw.isEmpty) return const [];
    return raw
        .split(RegExp(r'[\n•\-]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => e.toUpperCase())
        .toList();
  }

  List<_AboutLink> _aboutLinks(BrandProfileEntity? brand) {
    if (brand == null) return const [];
    return [
      if (brand.websiteUrl != null && brand.websiteUrl!.trim().isNotEmpty)
        _AboutLink.website(brand.websiteUrl!.trim()),
      if (brand.instagramHandle != null &&
          brand.instagramHandle!.trim().isNotEmpty)
        _AboutLink.instagram(brand.instagramHandle!.trim()),
      if (brand.tikTokHandle != null && brand.tikTokHandle!.trim().isNotEmpty)
        _AboutLink.tiktok(brand.tikTokHandle!.trim()),
      if (brand.youTubeHandle != null && brand.youTubeHandle!.trim().isNotEmpty)
        _AboutLink.youtube(brand.youTubeHandle!.trim()),
      if (brand.facebookHandle != null &&
          brand.facebookHandle!.trim().isNotEmpty)
        _AboutLink.facebook(brand.facebookHandle!.trim()),
    ];
  }

  Future<void> _onJoinOrSubmitPressed(
    BuildContext context,
    CampaignDetailController controller,
  ) async {
    // Always let the user pick a connected account again, then open submit.
    final selected = await showSelectSocialAccountsSheet(context);
    if (selected == null) return;

    final alreadyJoined = controller.campaign.value?.alreadyJoined ?? false;

    if (!alreadyJoined) {
      final joined = await controller.join(platformId: selected.platformId);
      if (!joined) return;
    }

    Get.toNamed(
      AppRoutes.submitPost,
      arguments: {
        'campaignId': controller.campaignId,
        'platformId': selected.platformId,
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.subtext),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: AppColors.onboardingGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardAndPlatformsRow extends StatelessWidget {
  const _RewardAndPlatformsRow({required this.campaign});

  final CampaignDetailEntity campaign;

  static const _rewardBg = Color(0xFFF4FAE8);
  static const _rewardBorder = Color(0xFFBED9BA);
  static const _upToColor = Color(0xFF495747);
  static const _amountColor = Color(0xFF426340);
  static const _receiptColor = Color(0xFF433D46);
  static const _divider = Color(0xFFDAE9D7);
  static const _postBorder = Color(0xFFEDECED);

  String get _amountText {
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
      return label.trim();
    }
    if (campaign.creatorMaxReward > 0) {
      final currency = campaign.currency.isNotEmpty ? campaign.currency : 'NPR';
      return '$currency ${NumberFormat('#,##0').format(campaign.creatorMaxReward)}';
    }
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildRewardCard()),
          const SizedBox(width: 10),
          Expanded(child: _buildPlatformsCard()),
        ],
      ),
    );
  }

  Widget _buildRewardCard() {
    return CustomPaint(
      foregroundPainter: const _DashedRRectPainter(
        color: _rewardBorder,
        radius: 16,
        dash: 2,
        gap: 2,
      ),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: _rewardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDAE9D7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      RemixIcons.gift_2_line,
                      size: 14,
                      color: Color(0xFF426340),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'UP TO',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 15 / 10,
                            letterSpacing: 0.5,
                            color: _upToColor,
                          ),
                        ),
                        Text(
                          _amountText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 24 / 16,
                            letterSpacing: -0.4,
                            color: _amountColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, thickness: 0.5, color: _divider),
                const SizedBox(height: 6.5),
                Row(
                  children: [
                    Icon(
                      RemixIcons.receipt_line,
                      size: 12,
                      color: campaign.purchaseProofRequired
                          ? _receiptColor
                          : AppColors.bodyGrey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        campaign.purchaseProofRequired
                            ? 'Receipt required'
                            : 'Receipt not required',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          height: 16.5 / 11,
                          color: campaign.purchaseProofRequired
                              ? _receiptColor
                              : AppColors.bodyGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformsCard() {
    final platforms = campaign.displayPlatforms.take(3).toList();

    return Container(
      // Figma: 12 top / 13 sides+bottom — keep height ≤ 96 after border.
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _postBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Post on',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 16.5 / 11,
              letterSpacing: -0.275,
              color: Color(0xFF4A434D),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (platforms.isEmpty)
                const Text('—', style: TextStyle(color: AppColors.bodyGrey))
              else
                for (final platform in platforms)
                  _PlatformBadge(platform: platform),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  const _PlatformBadge({required this.platform});

  final String platform;

  static String _labelFor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return 'Instagram';
      case 'tiktok':
        return 'TikTok';
      case 'facebook':
        return 'Facebook';
      case 'youtube':
        return 'YouTube';
      default:
        if (platform.isEmpty) return '';
        return platform[0].toUpperCase() + platform.substring(1).toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final spec = _specFor(platform);
    final displayLabel = _labelFor(platform);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: spec.background,
            gradient: spec.gradient,
          ),
          alignment: Alignment.center,
          child: Icon(spec.icon, size: spec.iconWidth, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          displayLabel,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 9,
            fontWeight: FontWeight.w500,
            height: 13.5 / 9,
            color: Color(0xFF4A434D),
          ),
        ),
      ],
    );
  }

  _PlatformIconSpec _specFor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const _PlatformIconSpec(
          icon: RemixIcons.instagram_fill,
          iconWidth: 12,
          iconHeight: 12,
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(0xFFF59E0B), Color(0xFFF43F5E), Color(0xFF9333EA)],
          ),
        );
      case 'tiktok':
        return const _PlatformIconSpec(
          icon: RemixIcons.tiktok_fill,
          iconWidth: 12,
          iconHeight: 12,
          background: Colors.black,
        );
      case 'youtube':
        return const _PlatformIconSpec(
          icon: RemixIcons.youtube_fill,
          iconWidth: 13,
          iconHeight: 13,
          background: Color(0xFFFF0000),
        );
      case 'facebook':
        return const _PlatformIconSpec(
          icon: RemixIcons.facebook_fill,
          iconWidth: 12,
          iconHeight: 12,
          background: Color(0xFF1877F2),
        );
      default:
        return const _PlatformIconSpec(
          icon: RemixIcons.global_line,
          iconWidth: 12,
          iconHeight: 12,
          background: Color(0xFF426340),
        );
    }
  }
}

class _PlatformIconSpec {
  const _PlatformIconSpec({
    required this.icon,
    required this.iconWidth,
    required this.iconHeight,
    this.background,
    this.gradient,
  });

  final IconData icon;
  final double iconWidth;
  final double iconHeight;
  final Color? background;
  final Gradient? gradient;
}

class _CampaignGoalCard extends StatelessWidget {
  const _CampaignGoalCard({required this.goal});

  final String goal;

  @override
  Widget build(BuildContext context) {
    if (goal.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [CampaignDetailPage._cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Campaign Goal',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.0,
              color: Color(0xFF353037),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            goal,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              height: 21 / 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A434D),
            ),
          ),
        ],
      ),
    );
  }
}

class _IncludeCard extends StatelessWidget {
  const _IncludeCard({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F0E4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [CampaignDetailPage._cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What to include',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.0,
              color: Color(0xFF353037),
            ),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < lines.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == lines.length - 1 ? 0 : 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDAE9D7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      RemixIcons.check_line,
                      size: 14,
                      color: Color(0xFF426340),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      lines[i],
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        height: 22 / 15,
                        color: Color(0xFF4A434D),
                      ),
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

class _RestrictionsCard extends StatelessWidget {
  const _RestrictionsCard({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [CampaignDetailPage._cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Restrictions Apply',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.0,
              color: Color(0xFF353037),
            ),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < lines.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == lines.length - 1 ? 0 : 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: const Center(
                      child: Icon(
                        RemixIcons.close_line,
                        size: 18,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      lines[i],
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14,
                        color: Color(0xFF4A434D),
                      ),
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

class _PostLimitsCard extends StatelessWidget {
  const _PostLimitsCard({this.postsPer7Days, this.postsPer12Months});

  final int? postsPer7Days;
  final int? postsPer12Months;

  @override
  Widget build(BuildContext context) {
    final weekly = (postsPer7Days != null && postsPer7Days! > 0)
        ? postsPer7Days!
        : 2;
    final yearly = (postsPer12Months != null && postsPer12Months! > 0)
        ? postsPer12Months!
        : 18;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [CampaignDetailPage._cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Post Limits',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              height: 1.0,
              color: Color(0xFF353037),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoBox(
                  label: '7 - DAY PERIOD',
                  value: 'Upto $weekly posts',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoBox(
                  label: '12 - MONTH PERIOD',
                  value: 'Upto $yearly posts',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OtherInfoCard extends StatelessWidget {
  const _OtherInfoCard({required this.campaign});

  final CampaignDetailEntity campaign;

  String _format(DateTime? date) {
    if (date == null) return '—';
    final month = DateFormat('MMM').format(date).toLowerCase();
    return '${_ordinal(date.day)} $month, ${date.year}';
  }

  String _ordinal(int day) {
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [CampaignDetailPage._cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Other Info',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              height: 1.0,
              color: Color(0xFF353037),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoBox(
                  label: 'START DATE',
                  value: _format(campaign.startDateLocal),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoBox(
                  label: 'RECEIPT',
                  value: campaign.purchaseProofRequired
                      ? 'Required'
                      : 'Not required',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutLink {
  const _AboutLink({
    required this.label,
    required this.url,
    required this.icon,
  });

  factory _AboutLink.website(String raw) {
    final url = raw.startsWith('http') ? raw : 'https://$raw';
    return _AboutLink(
      label: raw.replaceFirst(RegExp(r'^https?://'), ''),
      url: url,
      icon: RemixIcons.global_line,
    );
  }

  factory _AboutLink.instagram(String raw) {
    final handle = raw.replaceFirst('@', '');
    return _AboutLink(
      label: raw.startsWith('@') ? raw : '@$raw',
      url: 'https://instagram.com/$handle',
      icon: RemixIcons.instagram_line,
    );
  }

  factory _AboutLink.tiktok(String raw) {
    final handle = raw.replaceFirst('@', '');
    return _AboutLink(
      label: raw.startsWith('@') ? raw : '@$raw',
      url: 'https://www.tiktok.com/@$handle',
      icon: RemixIcons.tiktok_fill,
    );
  }

  factory _AboutLink.youtube(String raw) {
    return _AboutLink(
      label: raw.startsWith('@') ? raw : '@$raw',
      url: raw.startsWith('http')
          ? raw
          : 'https://youtube.com/@${raw.replaceFirst('@', '')}',
      icon: RemixIcons.youtube_line,
    );
  }

  factory _AboutLink.facebook(String raw) {
    final handle = raw.replaceFirst('@', '');
    return _AboutLink(
      label: raw.startsWith('@') ? raw : '@$raw',
      url: raw.startsWith('http') ? raw : 'https://facebook.com/$handle',
      icon: RemixIcons.facebook_line,
    );
  }

  final String label;
  final String url;
  final IconData icon;
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.links});

  final List<_AboutLink> links;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [CampaignDetailPage._cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              height: 1.0,
              color: Color(0xFF353037),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < links.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _AboutPill(link: links[i]),
          ],
        ],
      ),
    );
  }
}

class _AboutPill extends StatelessWidget {
  const _AboutPill({required this.link});

  final _AboutLink link;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => launchUrl(
          Uri.parse(link.url),
          mode: LaunchMode.externalApplication,
        ),
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: const Color(0xFFEDECED)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(link.icon, size: 10, color: const Color(0xFF4A434D)),
              const SizedBox(width: 4),
              Text(
                link.label,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  letterSpacing: 0.5,
                  color: Color(0xFF4A434D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEDECED)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Roboto',
              color: Color(0xFF6E6971),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              height: 1.0,
              color: Color(0xFF4A434D),
            ),
          ),
        ],
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
