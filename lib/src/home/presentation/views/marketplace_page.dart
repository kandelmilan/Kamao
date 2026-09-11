import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/home/domain/entities/marketplace_campaign_entity.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/marketplace_controller.dart';

// ═════════════════════════════════════════════════════════════
// Palette — matched to Figma node 371:2252
// ═════════════════════════════════════════════════════════════
class _Palette {
  const _Palette._();

  static const gradientLilac = Color(0xFFEFD4FF);
  static const pageBg = Color(0xFFF9F9F9);
  static const titleText = Color(0xFF353037);
  static const searchBorder = Color(0xFFEDECED);
  static const searchHint = Color(0xFF7B7B7B);
  static const cardBorder = Color(0xFFEAECF0);
  static const subtitleText = Color(0xFF7B7B7B);
  static const avatarLabelText = Color(0xFF433D46);
  static const arrowPurple = Color(0xFF4B0070);
  static const iconBg = Color(0xFFF9F6FB);
  static const onSurface = Color(0xFF1D1B20);
  static const shimmerBase = Color(0xFFE7E2EC);
}

// ═════════════════════════════════════════════════════════════
// Page
// ═════════════════════════════════════════════════════════════
class MarketplacePage extends GetView<MarketplaceController> {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Palette.pageBg,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_Palette.gradientLilac, _Palette.pageBg],
                  stops: [0.0, 0.85],
                ),
              ),
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.loadAll,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _Header(),
                    _SearchSection(
                      onChanged: (v) => controller.searchQuery.value = v,
                    ),

                    // ── Featured Campaigns ──────────────────────────
                    _SectionHeader(
                      title: 'Featured Campaigns',
                      onSeeAll: controller.onSeeAllFeatured,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Obx(() {
                        final status = controller.featuredStatus.value;
                        if (status.isLoading) {
                          return const _HorizontalShimmer(
                            itemWidth: 180,
                            height: 240,
                          );
                        }
                        if (status.isError) {
                          return SizedBox(
                            height: 240,
                            child: _ErrorInline(
                              message:
                                  status.errorMessage ??
                                  'Failed to load featured campaigns',
                              onRetry: controller.loadFeaturedCampaigns,
                            ),
                          );
                        }
                        final items = controller.featuredCampaigns;
                        if (items.isEmpty) {
                          return const SizedBox(
                            height: 240,
                            child: _EmptyInline(
                              label: 'No featured campaigns yet',
                            ),
                          );
                        }
                        return SizedBox(
                          height: 240,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 16),
                            itemBuilder: (_, i) =>
                                _FeaturedCampaignCard(campaign: items[i]),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 28),

                    // ── New Campaigns ────────────────────────────────
                    _SectionHeader(
                      title: 'New Campaigns',
                      onSeeAll: controller.onSeeAllNew,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Obx(() {
                        final status = controller.newStatus.value;
                        if (status.isLoading) {
                          return const _HorizontalShimmer(
                            itemWidth: 72,
                            height: 102,
                            circular: true,
                          );
                        }
                        if (status.isError) {
                          return SizedBox(
                            height: 102,
                            child: _ErrorInline(
                              message:
                                  status.errorMessage ??
                                  'Failed to load new campaigns',
                              onRetry: controller.loadNewCampaigns,
                            ),
                          );
                        }
                        final items = controller.newCampaigns;
                        if (items.isEmpty) {
                          return const SizedBox(
                            height: 102,
                            child: _EmptyInline(label: 'No new campaigns yet'),
                          );
                        }
                        return SizedBox(
                          height: 102,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 20),
                            itemBuilder: (_, i) =>
                                _NewCampaignAvatar(campaign: items[i]),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 32),

                    // ── Categories ────────────────────────────────────
                    _SectionHeader(
                      title: 'Categories',
                      actionLabel: 'See All Campaigns',
                      onSeeAll: controller.seeAllCampaigns,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Obx(() {
                        final status = controller.categoriesStatus.value;
                        if (status.isLoading) {
                          return const _VerticalShimmer(rows: 5);
                        }
                        if (status.isError) {
                          return _ErrorInline(
                            message:
                                status.errorMessage ??
                                'Failed to load categories',
                            onRetry: controller.loadCategories,
                          );
                        }
                        final items = controller.categories;
                        if (items.isEmpty) {
                          return const _EmptyInline(
                            label: 'No categories available',
                          );
                        }
                        return _CategoryCard(
                          items: items,
                          onCategoryTap: controller.onCategorySelected,
                        );
                      }),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Header — title (Roboto 700 28px/38px, #353037) + settings button
// (40x40, white, 1px #EAECF0 border, radius 20)
// ═════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Campaigns',
            style: GoogleFonts.roboto(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 38 / 28,
              color: _Palette.titleText,
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
                shape: BoxShape.circle,
                border: Border.all(color: _Palette.cardBorder, width: 1),
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

// ═════════════════════════════════════════════════════════════
// Search section — pt 10, pb 24, contains the search bar
// 372x46, radius 12, 1px #EDECED border
// hint: Roboto 400 12.98/19.47, letter-spacing 0.41, #7B7B7B
// ═════════════════════════════════════════════════════════════
class _SearchSection extends StatelessWidget {
  const _SearchSection({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Container(
        height: 46,
        constraints: const BoxConstraints(maxWidth: 584),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _Palette.searchBorder, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: GoogleFonts.roboto(
                  fontSize: 12.98,
                  fontWeight: FontWeight.w400,
                  height: 19.47 / 12.98,
                  letterSpacing: 0.41,
                  color: _Palette.titleText,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search campaigns or brands...',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 12.98,
                    fontWeight: FontWeight.w400,
                    height: 19.47 / 12.98,
                    letterSpacing: 0.41,
                    color: _Palette.searchHint,
                  ),
                ),
              ),
            ),
            const Icon(Icons.search, size: 20, color: _Palette.searchHint),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Section header — title (Roboto 700 18/24, #353037) + "See All"
// (Roboto 500 13px, #4B0070)
// ═════════════════════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.onSeeAll,
    this.actionLabel = 'See All',
  });

  final String title;
  final String actionLabel;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 24 / 18,
              color: _Palette.titleText,
            ),
          ),
          InkWell(
            onTap: onSeeAll,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                actionLabel,
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 18 / 13,
                  color: _Palette.arrowPurple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Featured campaign card — 180x240, radius 16, 1px #EAECF0 border
// image area 130h (12 padding), name 16/700, subtitle 13/400
// ═════════════════════════════════════════════════════════════
class _FeaturedCampaignCard extends StatelessWidget {
  const _FeaturedCampaignCard({required this.campaign});

  final MarketplaceCampaignEntity campaign;

  @override
  Widget build(BuildContext context) {
    final coverUrl = resolveImageUrl(campaign.brandCoverUrl);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () =>
          Get.toNamed(AppRoutes.campaignDetail, arguments: campaign.id),
      child: Container(
        width: 180,
        height: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _Palette.cardBorder, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: coverUrl != null
                    ? Image.network(
                        coverUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => const _ImageFallback(),
                      )
                    : const _ImageFallback(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      campaign.brandName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 20 / 16,
                        color: _Palette.titleText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      campaign.objective,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 18 / 13,
                        color: _Palette.subtitleText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// ═════════════════════════════════════════════════════════════
// New campaign avatar — 72px circle, 2px white border,
// label Roboto 500 14/normal, #433D46
// ═════════════════════════════════════════════════════════════
class _NewCampaignAvatar extends StatelessWidget {
  const _NewCampaignAvatar({required this.campaign});

  final MarketplaceCampaignEntity campaign;

  @override
  Widget build(BuildContext context) {
    final logoUrl = resolveImageUrl(campaign.brandLogoUrl);
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () =>
          Get.toNamed(AppRoutes.campaignDetail, arguments: campaign.id),
      child: SizedBox(
        width: 79,
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: logoUrl != null
                    ? Image.network(
                        logoUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) =>
                            _InitialAvatar(label: campaign.brandName),
                      )
                    : _InitialAvatar(label: campaign.brandName),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              campaign.brandName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _Palette.avatarLabelText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  const _InitialAvatar({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _Palette.iconBg,
      child: Center(
        child: Text(
          label.isNotEmpty ? label[0].toUpperCase() : '?',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _Palette.arrowPurple,
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Category card — bordered container holding category rows
// ═════════════════════════════════════════════════════════════
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.items, required this.onCategoryTap});

  final List<String> items;
  final void Function(String category) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _Palette.cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: _Palette.cardBorder),
        itemBuilder: (context, index) {
          final category = items[index];
          return _CategoryRow(
            label: category,
            onTap: () => onCategoryTap(category),
          );
        },
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Category row — icon 40x40 circle #F9F6FB, gap 16,
// label Roboto 700 16/20 #353037, chevron 20x20 #4B0070
// ═════════════════════════════════════════════════════════════
class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _Palette.iconBg,
              ),
              child: Icon(
                _categoryIcon(label),
                size: 20,
                color: _Palette.arrowPurple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 20 / 16,
                  color: _Palette.titleText,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: _Palette.arrowPurple,
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'beauty':
        return RemixIcons.brush_ai_line;
      case 'fashion':
        return RemixIcons.handbag_line;
      case 'food':
        return RemixIcons.restaurant_2_line;
      case 'drinks':
        return RemixIcons.goblet_line;
      case 'hospitality':
        return RemixIcons.flower_line;
      case 'shops':
        return RemixIcons.store_line;
      case 'kids':
        return RemixIcons.emotion_happy_line;
      case 'health & fitness':
      case 'health and fitness':
        return RemixIcons.heart_2_line;
      default:
        return RemixIcons.price_tag_3_line;
    }
  }
}

// ═════════════════════════════════════════════════════════════
// Shared loading / empty / error states
// ═════════════════════════════════════════════════════════════
class _HorizontalShimmer extends StatelessWidget {
  const _HorizontalShimmer({
    required this.itemWidth,
    required this.height,
    this.circular = false,
  });

  final double itemWidth;
  final double height;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) => Container(
          width: itemWidth,
          decoration: BoxDecoration(
            color: _Palette.shimmerBase,
            borderRadius: BorderRadius.circular(circular ? 40 : 16),
          ),
        ),
      ),
    );
  }
}

class _VerticalShimmer extends StatelessWidget {
  const _VerticalShimmer({required this.rows});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        rows,
        (_) => Container(
          height: 64,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: _Palette.shimmerBase,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _EmptyInline extends StatelessWidget {
  const _EmptyInline({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _Palette.subtitleText,
        ),
      ),
    );
  }
}

class _ErrorInline extends StatelessWidget {
  const _ErrorInline({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _Palette.subtitleText,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: GoogleFonts.roboto(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _Palette.arrowPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _Palette.shimmerBase,
      child: Center(
        child: Icon(
          RemixIcons.image_line,
          color: _Palette.subtitleText,
          size: 24,
        ),
      ),
    );
  }
}
