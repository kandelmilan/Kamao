import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamao/src/post/domain/entities/submission_entity.dart';
import 'package:kamao/src/post/presentation/controllers/posts_controller.dart';
import 'package:kamao/src/post/presentation/widgets/posts_page_background.dart';
import 'package:kamao/src/social_connections/domain/entities/social_platform_type.dart';
import 'package:remixicon/remixicon.dart';

class _Palette {
  const _Palette._();

  static const titleText = Color(0xFF353037);
  static const onSurface = Color(0xFF1D1B20);
  static const settingsBorder = Color(0xFFEAECF0);
  static const cardBorder = Color(0xFFF1F5F9);
  static const campaignTitle = Color(0xFF4A434D);
  static const brandName = Color(0xFF495747);
  static const metaText = Color(0xFF6E6971);
  static const detailValue = Color(0xFF433D46);
  static const detailDivider = Color(0xFFEDECED);
  static const linkBlue = Color(0xFF2563EB);
  static const pendingPillBg = Color(0xFFFEF5E7);
  static const pendingPillBorder = Color(0xFFFAD28F);
  static const pendingPillFg = Color(0xFFF59E0B);
  static const approvedPillBg = Color(0xFFE8F6ED);
  static const approvedPillBorder = Color(0xFF94D5AC);
  static const approvedPillFg = Color(0xFF16A34A);
  static const thumbBg = Color(0xFFE7E2EC);
}

class PostsPage extends GetView<PostsController> {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PostsPageBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              const _PostsTabs(),
              Expanded(
                child: Obx(() {
                  final tab = controller.selectedTab.value;
                  return RefreshIndicator(
                    onRefresh: controller.loadAll,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        if (tab == PostsTab.pending)
                          const SliverToBoxAdapter(child: _PendingBanner()),
                        const SliverToBoxAdapter(child: SizedBox(height: 12)),
                        _PostsListSliver(isPending: tab == PostsTab.pending),
                        const SliverToBoxAdapter(child: SizedBox(height: 28)),
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Posts',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 38 / 28,
                color: _Palette.titleText,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _Palette.settingsBorder),
              ),
              child: const Icon(
                RemixIcons.settings_3_line,
                size: 20,
                color: _Palette.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostsTabs extends GetView<PostsController> {
  const _PostsTabs();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedTab.value;
      final pendingCount = controller.pending.length;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
        child: Row(
          children: [
            Expanded(
              child: _TabButton(
                label: 'Pending Approvals',
                isSelected: selected == PostsTab.pending,
                trailing: _PendingCountBadge(count: pendingCount),
                onTap: () => controller.selectTab(PostsTab.pending),
              ),
            ),
            Expanded(
              child: _TabButton(
                label: 'Approved',
                isSelected: selected == PostsTab.approved,
                trailing: const _ApprovedTickBadge(),
                onTap: () => controller.selectTab(PostsTab.approved),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.trailing,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? _Palette.brandName : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  letterSpacing: 16 * 0.005,
                  color: isSelected
                      ? _Palette.brandName
                      : _Palette.brandName.withValues(alpha: 0.55),
                ),
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _PendingCountBadge extends StatelessWidget {
  const _PendingCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return Container(
      width: 16,
      height: 16,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFF59E0B),
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 13.09 / 10,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ApprovedTickBadge extends StatelessWidget {
  const _ApprovedTickBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF16A34A),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        RemixIcons.check_line,
        size: 10,
        color: Colors.white,
      ),
    );
  }
}

class _PendingBanner extends StatelessWidget {
  const _PendingBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF5E7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFAD28F), width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                RemixIcons.history_fill,
                size: 14,
                color: Color(0xFF4A434D),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                'Your posts are under review, you will be notified once they are approved',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 22 / 12,
                  color: Color(0xFF4A434D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostsListSliver extends GetView<PostsController> {
  const _PostsListSliver({required this.isPending});

  final bool isPending;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = isPending ? controller.pending : controller.approved;
      final status = isPending
          ? controller.pendingStatus.value
          : controller.approvedStatus.value;

      // Touch lengths so GetX tracks list mutations.
      final count = items.length;

      if (status.isLoading && count == 0) {
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        );
      }

      if (status.isError && count == 0) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyState(
            icon: RemixIcons.error_warning_line,
            title: 'Couldn’t load posts',
            subtitle: status.errorMessage ?? 'Please try again.',
            actionLabel: 'Retry',
            onAction: controller.loadAll,
          ),
        );
      }

      if (count == 0) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyState(
            icon: isPending
                ? RemixIcons.time_line
                : RemixIcons.checkbox_circle_line,
            title: isPending ? 'No pending posts' : 'No approved posts yet',
            subtitle: isPending
                ? 'Submitted posts awaiting review will show up here.'
                : 'Approved campaign posts will appear in this list.',
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList.separated(
          itemCount: count,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _SubmissionCard(
              item: items[index],
              isPendingTab: isPending,
            );
          },
        ),
      );
    });
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: _Palette.metaText.withValues(alpha: 0.7)),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _Palette.titleText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 18 / 13,
                color: _Palette.metaText,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _SubmissionCard extends GetView<PostsController> {
  const _SubmissionCard({required this.item, required this.isPendingTab});

  final SubmissionEntity item;
  final bool isPendingTab;

  @override
  Widget build(BuildContext context) {
    final thumb = item.thumbnailImageUrl;
    final platformType = SocialPlatformType.tryParse(item.platform);
    final dateLabel = controller.metaDateLabel(item);

    return Obx(() {
      final expanded = controller.isExpanded(item.id);

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.toggleExpanded(item.id),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _Palette.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 20, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // banner/logo — 48×52, r 6.5, border 1.44 #FFF
                      Container(
                        width: 48,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.44,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: thumb == null
                            ? const ColoredBox(
                                color: _Palette.thumbBg,
                                child: Icon(
                                  RemixIcons.image_line,
                                  size: 20,
                                  color: _Palette.metaText,
                                ),
                              )
                            : Image.network(
                                thumb,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const ColoredBox(
                                  color: _Palette.thumbBg,
                                  child: Icon(
                                    RemixIcons.image_line,
                                    size: 20,
                                    color: _Palette.metaText,
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
                              item.campaignName.isEmpty
                                  ? 'Campaign'
                                  : item.campaignName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 20 / 16,
                                color: _Palette.campaignTitle,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              controller.brandLabel(item),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                height: 1,
                                letterSpacing: 0.5,
                                color: _Palette.brandName,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (platformType != null) ...[
                                  Icon(
                                    platformType.icon,
                                    size: 11,
                                    color: _Palette.metaText,
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Flexible(
                                  child: Text.rich(
                                    TextSpan(
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                        letterSpacing: 0.5,
                                        color: _Palette.metaText,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: controller.contentTypeLabel(
                                            item,
                                          ),
                                        ),
                                        if (dateLabel.isNotEmpty) ...[
                                          const TextSpan(text: '  •  '),
                                          TextSpan(text: dateLabel),
                                        ],
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _StatusBadge(isPending: isPendingTab),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: expanded
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 4),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: _Palette.detailDivider,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _MetaBlock(
                                      label: 'PLATFORM',
                                      child: Row(
                                        children: [
                                          if (platformType != null) ...[
                                            Icon(
                                              platformType.icon,
                                              size: 14,
                                              color: _Palette.detailValue,
                                            ),
                                            const SizedBox(width: 6),
                                          ],
                                          Flexible(
                                            child: Text(
                                              controller.platformLabel(
                                                item.platform,
                                              ),
                                              style: _detailValueStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _MetaBlock(
                                      label: 'STATUS',
                                      child: Text(
                                        controller.statusLabel(item),
                                        style: _detailValueStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _MetaBlock(
                                      label: 'SUBMITTED',
                                      child: Text(
                                        controller.submittedLabel(item),
                                        style: _detailValueStyle,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _MetaBlock(
                                      label: 'REWARD ENDS',
                                      child: Text(
                                        controller.rewardEndsLabel(item),
                                        style: _detailValueStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _MetaBlock(
                                      label: 'POST',
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () =>
                                            controller.openContent(item),
                                        child: const Text(
                                          'Open link',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 19.25 / 12,
                                            color: _Palette.linkBlue,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                _Palette.linkBlue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _MetaBlock(
                                      label: 'REWARD',
                                      child: _RewardValue(
                                        label: controller.rewardLabel(item),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

const _detailValueStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 19.25 / 12,
  color: _Palette.detailValue,
);

class _RewardValue extends StatelessWidget {
  const _RewardValue({required this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        width: 28,
        height: 1.5,
        color: _Palette.metaText.withValues(alpha: 0.45),
      );
    }
    return Text(label!, style: _detailValueStyle);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isPending});

  final bool isPending;

  @override
  Widget build(BuildContext context) {
    final bg = isPending
        ? _Palette.pendingPillBg
        : _Palette.approvedPillBg;
    final border = isPending
        ? _Palette.pendingPillBorder
        : _Palette.approvedPillBorder;
    final fg = isPending
        ? _Palette.pendingPillFg
        : _Palette.approvedPillFg;
    final text = isPending ? 'Pending' : 'Approved';

    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          height: 15 / 10,
          color: fg,
        ),
      ),
    );
  }
}

class _MetaBlock extends StatelessWidget {
  const _MetaBlock({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 16.5 / 12,
            letterSpacing: 0.28,
            color: _Palette.metaText,
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
