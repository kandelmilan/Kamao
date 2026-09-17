import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/auth/domain/entities/response/profile_entity.dart';
import 'package:kamao/src/auth/presentation/controllers/creator_levels_controller.dart';
import 'package:kamao/src/auth/presentation/widgets/creator_level_badge.dart';
import 'package:remixicon/remixicon.dart';

/// Creator Tiers — Figma nodes 919:4418 / 919:4358.
/// Data from GET `/creator/progress/guide`.
class CreatorLevelsView extends GetView<CreatorLevelsController> {
  const CreatorLevelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF9F9F9),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // CSS 359.15deg ≈ nearly bottom → top
            begin: Alignment(0.02, 1),
            end: Alignment(-0.02, -1),
            colors: [
              Color(0xFFF9F9F9),
              Color(0xFFF4F9E8),
            ],
            stops: [0.9009, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const _Header(),
              Expanded(
                child: Obx(() {
                  final guide = controller.guide.value;
                  final stats = controller.progress;

                  if (controller.isLoading.value && guide == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (guide == null || stats == null) {
                    return Center(
                      child: TextButton(
                        onPressed: controller.load,
                        child: Text(
                          controller.error.value ??
                              'Couldn’t load levels — tap to retry',
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                      children: [
                        _CurrentTierCard(stats: stats),
                        const SizedBox(height: 24),
                        const Text(
                          'All Creator Levels',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: CreatorLevelStyle.ink,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...controller.levels.map(
                          (level) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _LevelRow(
                              level: level,
                              currentCode: stats.levelCode,
                              currentRank: stats.effectiveLevelRank > 0
                                  ? stats.effectiveLevelRank
                                  : stats.computedLevelRank,
                            ),
                          ),
                        ),
                        if (controller.catalogBadges.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          const Text(
                            'Badges',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: CreatorLevelStyle.ink,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...controller.catalogBadges.map(
                            (badge) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _BadgeRow(badge: badge),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              RemixIcons.arrow_left_s_line,
              size: 28,
              color: CreatorLevelStyle.ink,
            ),
          ),
          const Expanded(
            child: Text(
              'Creator Tiers',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: CreatorLevelStyle.ink,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              RemixIcons.information_line,
              size: 22,
              color: AppColors.subtext,
            ),
          ),
        ],
      ),
    );
  }
}

/// Current Tier Card — soft gradient + progress (Figma Seed 910:3967).
class _CurrentTierCard extends StatelessWidget {
  const _CurrentTierCard({required this.stats});

  final ProfileProgressStatsEntity stats;

  static final _npr = NumberFormat('#,##0');

  @override
  Widget build(BuildContext context) {
    final style = CreatorLevelStyle.forCode(stats.levelCode);
    final hasNext = (stats.nextLevelName ?? '').isNotEmpty;
    final isElite = stats.levelCode.toLowerCase() == 'elite';
    final showProgress = hasNext && !isElite;
    final nextStyle = hasNext
        ? CreatorLevelStyle.forCode(stats.nextLevelCode ?? '')
        : style;

    final postsDone = stats.rewardedPosts;
    final postsGoal = stats.nextMinRewardedPosts ??
        (stats.postsToNext != null
            ? postsDone + stats.postsToNext!
            : postsDone);
    final postsProgress =
        postsGoal <= 0 ? 1.0 : (postsDone / postsGoal).clamp(0.0, 1.0);

    final moneyGoal = stats.nextMinTotalRewarded;
    final moneyDone = moneyGoal != null && stats.nprToNext != null
        ? (moneyGoal - stats.nprToNext!).clamp(0.0, moneyGoal)
        : stats.totalRewarded;
    final moneyProgress = moneyGoal == null || moneyGoal <= 0
        ? 0.0
        : (moneyDone / moneyGoal).clamp(0.0, 1.0);
    final showMoneyBar =
        moneyGoal != null && moneyGoal > 0 && stats.nprToNext != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: CreatorLevelStyle.border),
        boxShadow: [style.cardShadow],
        gradient: LinearGradient(
          // CSS ~352–356deg ≈ bottom → top soft wash
          begin: const Alignment(0.05, 1),
          end: const Alignment(-0.05, -1),
          colors: [
            AppColors.white,
            style.currentCardEnd,
          ],
          stops: [style.currentCardStop, 0.97],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'YOUR LEVEL',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  letterSpacing: 1.2,
                  color: CreatorLevelStyle.ink,
                ),
              ),
              const SizedBox(width: 10),
              CreatorLevelBadge(
                label: stats.levelName,
                code: stats.levelCode,
                compact: false,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${stats.levelName} Creator',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1,
              color: style.headlineColor,
            ),
          ),
          if (stats.hasManualFloor) ...[
            const SizedBox(height: 12),
            _FloorNote(stats: stats, color: style.headlineColor),
          ],
          if (showProgress) ...[
            const SizedBox(height: 16),
            // Posts tracker
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        color: CreatorLevelStyle.ink,
                      ),
                      children: [
                        const TextSpan(text: 'Next Tier: '),
                        TextSpan(
                          text: stats.nextLevelName!.toUpperCase(),
                          style: TextStyle(color: nextStyle.titleColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '$postsDone/$postsGoal Posts Done',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1,
                    color: Color(0xFF426340),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _ProgressBar(
              value: postsProgress,
              track: CreatorLevelStyle.progressTrackColor,
              fill: CreatorLevelStyle.postsProgressFill,
            ),
            if (showMoneyBar) ...[
              const SizedBox(height: 14),
              // Earnings tracker
              Row(
                children: [
                  _EarnedChip(amount: moneyDone),
                  const Spacer(),
                  Text(
                    'Rs. ${_npr.format(stats.nprToNext)} left',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      color: CreatorLevelStyle.nprChipText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _ProgressBar(
                value: moneyProgress,
                track: CreatorLevelStyle.progressTrackColor,
                fill: CreatorLevelStyle.nprProgressFill,
              ),
            ],
            if ((stats.nextLevelBlurb ?? '').isNotEmpty ||
                stats.postsToNext != null ||
                stats.nprToNext != null) ...[
              const SizedBox(height: 12),
              Text(
                _progressHint(stats),
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                  color: CreatorLevelStyle.ink,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  String _progressHint(ProfileProgressStatsEntity stats) {
    final posts = stats.postsToNext;
    final npr = stats.nprToNext;
    if (posts != null && npr != null) {
      return 'Complete $posts more high-quality posts or earn ${_npr.format(npr)} more to level up and unlock better platform rewarding multipliers.';
    }
    if (posts != null) {
      return 'Complete $posts more high-quality posts to level up and unlock better platform rewarding multipliers.';
    }
    if (npr != null) {
      return 'Earn ${_npr.format(npr)} more to level up and unlock better platform rewarding multipliers.';
    }
    return stats.nextLevelBlurb ?? '';
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.value,
    required this.track,
    required this.fill,
  });

  final double value;
  final Color track;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 8,
        backgroundColor: track,
        valueColor: AlwaysStoppedAnimation(fill),
      ),
    );
  }
}

/// Earned-toward-next chip: card icon + रू amount + chevron.
class _EarnedChip extends StatelessWidget {
  const _EarnedChip({required this.amount});

  final double amount;

  static final _npr = NumberFormat('#,##0');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 6, 5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: CreatorLevelStyle.nprChipBorder, width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4.6,
            offset: Offset(0, 1.5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            RemixIcons.bank_card_line,
            size: 14,
            color: Color(0xFF426340),
          ),
          const SizedBox(width: 5),
          Text(
            'रू ${_npr.format(amount)}',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1,
              color: CreatorLevelStyle.ink,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            RemixIcons.arrow_right_s_line,
            size: 14,
            color: CreatorLevelStyle.ink,
          ),
        ],
      ),
    );
  }
}

class _FloorNote extends StatelessWidget {
  const _FloorNote({required this.stats, required this.color});

  final ProfileProgressStatsEntity stats;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if ((stats.floorLevelName ?? '').isNotEmpty) '${stats.floorLevelName} floor',
      if ((stats.floorReason ?? '').isNotEmpty) stats.floorReason!,
    ];
    if (parts.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CreatorLevelStyle.border),
      ),
      child: Text(
        parts.join(' · '),
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _LevelRow extends StatelessWidget {
  const _LevelRow({
    required this.level,
    required this.currentCode,
    required this.currentRank,
  });

  final ProfileLevelEntity level;
  final String currentCode;
  final int currentRank;

  @override
  Widget build(BuildContext context) {
    final style = CreatorLevelStyle.forCode(level.code);
    final isCurrent =
        level.isCurrent || level.code.toLowerCase() == currentCode.toLowerCase();
    // Anything at or below the user's rank is unlocked (no Locked chip).
    final isLocked = level.rank > currentRank && !isCurrent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: isCurrent
            ? Border.all(color: style.titleColor.withValues(alpha: 0.25))
            : null,
        boxShadow: isCurrent ? [style.cardShadow] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: style.iconBoxBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(style.icon, size: 18, color: style.iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${level.rank}. ${level.name} Level',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        color: CreatorLevelStyle.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      style.tierLabel,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        letterSpacing: 1.1,
                        color: style.titleColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrent)
                _YourTierChip(style: style)
              else if (isLocked)
                const _LockedChip(),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            level.blurb,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 18 / 13,
              color: CreatorLevelStyle.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _YourTierChip extends StatelessWidget {
  const _YourTierChip({required this.style});

  final CreatorLevelStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
      decoration: BoxDecoration(
        color: style.solidColor,
        gradient: style.gradient,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 12, color: AppColors.white),
          const SizedBox(width: 4),
          const Text(
            'Your Tier',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _LockedChip extends StatelessWidget {
  const _LockedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(RemixIcons.lock_line, size: 12, color: Color(0xFF9CA3AF)),
          SizedBox(width: 4),
          Text(
            'Locked',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeRow extends StatelessWidget {
  const _BadgeRow({required this.badge});

  final ProfileBadgeEntity badge;

  @override
  Widget build(BuildContext context) {
    final earned = badge.earned == true;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CreatorLevelStyle.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: earned
                  ? const Color(0xFFF7FAF6)
                  : const Color(0xFFF3F4F6),
            ),
            alignment: Alignment.center,
            child: Icon(
              earned ? RemixIcons.medal_fill : RemixIcons.medal_line,
              size: 20,
              color: earned
                  ? const Color(0xFF16A34A)
                  : const Color(0xFF6E6971),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.name,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: CreatorLevelStyle.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  badge.description,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    height: 1.35,
                    color: AppColors.bodyGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            earned ? 'Earned' : 'Locked',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: earned
                  ? const Color(0xFF16A34A)
                  : const Color(0xFF6E6971),
            ),
          ),
        ],
      ),
    );
  }
}
