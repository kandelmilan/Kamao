import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:kamao/src/home/presentation/controllers/campaign_detail_controller.dart';
import 'package:kamao/src/home/presentation/widgets/campaign_checklist_card.dart';
import 'package:kamao/src/home/presentation/widgets/campaign_detail_header.dart';
import 'package:kamao/src/home/presentation/widgets/select_social_accounts_sheet.dart';
import 'package:remixicon/remixicon.dart';

/// Campaign details — matches provided Campaign Details figures.
class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CampaignDetailController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF6),
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
        final restrictions = _restrictionLines(c);

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Obx(
                    () => CampaignDetailHeader(
                      campaign: controller.campaign.value ?? c,
                      isFavourite:
                          (controller.campaign.value ?? c).isFavourite,
                      isTogglingFavourite:
                          controller.isTogglingFavourite.value,
                      onBack: () => Get.back(),
                      onBookmark: controller.toggleFavourite,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
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
                      if (restrictions.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _RestrictionsCard(lines: restrictions),
                      ],
                      const SizedBox(height: 16),
                      const _PostLimitsCard(),
                      const SizedBox(height: 16),
                      _OtherInfoCard(campaign: c),
                      if (c.platforms.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _AboutCard(platforms: c.platforms),
                      ],
                    ]),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 20,
              bottom: 28 + MediaQuery.paddingOf(context).bottom,
              child: Obx(() {
                final joining = controller.isJoining.value;
                return _JoinFab(
                  isJoining: joining,
                  onPressed: joining
                      ? null
                      : () => _onJoinOrSubmitPressed(context, controller),
                );
              }),
            ),
          ],
        );
      }),
    );
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

  Future<void> _onJoinOrSubmitPressed(
    BuildContext context,
    CampaignDetailController controller,
  ) async {
    // Always let the user pick a connected account again, then open submit.
    final selected = await showSelectSocialAccountsSheet(context);
    if (selected == null) return;

    final alreadyJoined =
        controller.campaign.value?.alreadyJoined ?? false;

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
      final currency =
          campaign.currency.isNotEmpty ? campaign.currency : 'NPR';
      return '$currency ${NumberFormat('#,##0').format(campaign.creatorMaxReward)}';
    }
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Row(
        children: [
          Expanded(
            child: CustomPaint(
              painter: const _DashedRRectPainter(
                color: _rewardBorder,
                radius: 16,
                dash: 2,
                gap: 2,
              ),
              child: Container(
                height: 96,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _rewardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDAE9D7),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            RemixIcons.gift_2_fill,
                            size: 14,
                            color: _amountColor,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          height: 1,
                          thickness: 0.5,
                          color: _divider,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              RemixIcons.file_text_line,
                              size: 13,
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
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 96,
              padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bodyGrey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (final platform in campaign.platforms.take(3))
                        _PlatformBadge(platform: platform),
                      if (campaign.platforms.isEmpty)
                        const Text(
                          '—',
                          style: TextStyle(color: AppColors.bodyGrey),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  const _PlatformBadge({required this.platform});

  final String platform;

  IconData get _icon {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return RemixIcons.instagram_line;
      case 'tiktok':
        return RemixIcons.tiktok_fill;
      case 'facebook':
        return RemixIcons.facebook_fill;
      case 'youtube':
        return RemixIcons.youtube_line;
      default:
        return RemixIcons.global_line;
    }
  }

  Color get _color {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const Color(0xFFE1306C);
      case 'tiktok':
        return const Color(0xFF111111);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'youtube':
        return const Color(0xFFFF0000);
      default:
        return AppColors.onboardingGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = platform.isEmpty
        ? ''
        : platform[0].toUpperCase() + platform.substring(1).toLowerCase();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(_icon, size: 16, color: _color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.subtext,
          ),
        ),
      ],
    );
  }
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
        // boxShadow: const [
        //   BoxShadow(
        //     color: Color(0x0A1A153B),
        //     blurRadius: 16,
        //     offset: Offset(0, 4),
        //   ),
        // ],
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
              color: AppColors.subtext,
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1A153B),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    RemixIcons.close_circle_line,
                    size: 20,
                    color: Color(0xFFE86161),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      lines[i],
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.5,
                        color: Color(0xFF6E6971),
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
  const _PostLimitsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1A153B),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Post Limits',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              height: 1.0,
              color: Color(0xFF353037),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoBox(
                  label: '7 - DAY PERIOD',
                  value: 'Upto 2 posts',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _InfoBox(
                  label: '12 - MONTH PERIOD',
                  value: 'Upto 18 posts',
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
    return DateFormat('d MMM, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1A153B),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
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

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.platforms});

  final List<String> platforms;

  IconData _iconFor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return RemixIcons.instagram_line;
      case 'tiktok':
        return RemixIcons.tiktok_fill;
      case 'facebook':
        return RemixIcons.facebook_line;
      case 'youtube':
        return RemixIcons.youtube_line;
      default:
        return RemixIcons.global_line;
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1A153B),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
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
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final platform in platforms)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: const Color(0xFFEDECED)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _iconFor(platform),
                        size: 12,
                        color: const Color(0xFF4A434D),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        platform,
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
            ],
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
          const SizedBox(height: 8),
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

class _JoinFab extends StatelessWidget {
  const _JoinFab({
    required this.isJoining,
    required this.onPressed,
  });

  final bool isJoining;
  final VoidCallback? onPressed;

  static const _fabGreen = Color(0xFF334D32);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _fabGreen,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: _fabGreen.withValues(alpha: 0.35),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: isJoining
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    RemixIcons.add_fill,
                    color: Colors.white,
                    size: 22,
                  ),
          ),
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
