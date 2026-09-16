import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/constants/app_images.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import 'package:kamao/src/brand/presentation/controllers/brands_controller.dart';
import 'package:kamao/src/brand/presentation/widgets/brand_square_item.dart';
import 'package:remixicon/remixicon.dart';

class _Palette {
  const _Palette._();

  static const pageBg = Color(0xFFFAFAF9);
  static const gradientMint = Color(0xFFF4FAE8);
  static const titleText = Color(0xFF353037);
  static const searchBorder = Color(0xFFEDECED);
  static const searchHint = Color(0xFF6E6971);
  static const mintStrip = Color(0xFFF4FAE8);
  static const mintBorder = Color(0xFFE6F0E4);
  static const brandName = Color(0xFF433D46);
  static const metaText = Color(0xFF6E6971);
  static const badgeText = Color(0xFF426340);
  static const seeAll = Color(0xFF426340);
  static const iconBg = Color(0xFFF9F6FB);
  static const onSurface = Color(0xFF1D1B20);
  static const settingsBorder = Color(0xFFEAECF0);
  static const shimmerBase = Color(0xFFE7E2EC);
}

class BrandsPage extends GetView<BrandsController> {
  const BrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Palette.pageBg,
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_Palette.gradientMint, _Palette.pageBg],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: controller.loadAll,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(bottom: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Header(),
                    _SearchSection(
                      onChanged: (v) => controller.searchQuery.value = v,
                      onFilter: controller.seeAllBrands,
                    ),
                    const _FeaturedSection(),
                    const SizedBox(height: 28),
                    _SectionHeader(
                      title: 'New Brands',
                      actionLabel: 'See All',
                      onSeeAll: controller.onSeeAllNew,
                    ),
                    const SizedBox(height: 12),
                    const _NewBrandsRail(),
                    const SizedBox(height: 32),
                    _SectionHeader(
                      title: 'Categories',
                      actionLabel: 'See All Brands',
                      onSeeAll: controller.seeAllBrands,
                    ),
                    const SizedBox(height: 12),
                    const _CategoriesSection(),
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
              'Brands',
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

class _SearchSection extends StatelessWidget {
  const _SearchSection({required this.onChanged, required this.onFilter});

  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: _Palette.searchBorder),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppImages.iconSearch,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                _Palette.searchHint,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _Palette.titleText,
                ),
                decoration: const InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search brands, categories...',
                  hintStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: _Palette.searchHint,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: onFilter,
              child: SvgPicture.asset(
                AppImages.iconFilter,
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  _Palette.searchHint,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 24 / 18,
                color: _Palette.titleText,
              ),
            ),
          ),
          InkWell(
            onTap: onSeeAll,
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 18 / 13,
                color: _Palette.seeAll,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedSection extends GetView<BrandsController> {
  const _FeaturedSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Featured Campaigns',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 24 / 18,
                    color: _Palette.titleText,
                  ),
                ),
              ),
              InkWell(
                onTap: controller.onSeeAllFeatured,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 18 / 13,
                      color: _Palette.seeAll,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
          decoration: BoxDecoration(
            color: _Palette.mintStrip,
            border: Border.all(color: _Palette.mintBorder),
          ),
          child: Obx(() {
            final status = controller.featuredStatus.value;
            final query = controller.searchQuery.value;
            if (status.isLoading) {
              return const SizedBox(
                height: 220,
                child: _HorizontalShimmer(itemWidth: 148, height: 220),
              );
            }
            if (status.isError) {
              return SizedBox(
                height: 220,
                child: _ErrorInline(
                  message:
                      status.errorMessage ?? 'Failed to load featured brands',
                  onRetry: controller.loadFeaturedBrands,
                ),
              );
            }
            final items = _filterBrands(controller.featuredBrands, query);
            if (items.isEmpty) {
              return const SizedBox(
                height: 220,
                child: _EmptyInline(label: 'No featured brands yet'),
              );
            }
            return SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _FeaturedBrandCard(
                  brand: items[i],
                  badge: i.isEven ? 'Popular' : 'Trending',
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _FeaturedBrandCard extends StatelessWidget {
  const _FeaturedBrandCard({required this.brand, required this.badge});

  final BrandEntity brand;
  final String badge;

  @override
  Widget build(BuildContext context) {
    final cover = resolveImageUrl(brand.coverImageUrl);
    final logo = resolveImageUrl(brand.logoUrl);
    final category = brand.categoryName ??
        (brand.liveCampaignCount > 0
            ? '${brand.liveCampaignCount} live campaigns'
            : 'Brand');
    final tagline = (brand.bio != null && brand.bio!.trim().isNotEmpty)
        ? brand.bio!.trim()
        : 'Earn up to ${brand.currency} ${brand.maxRewardAmount.toStringAsFixed(0)}';

    return InkWell(
      onTap: () => openBrandDetail(brand.id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 148,
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
                          color: _Palette.badgeText,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 16 / 14,
                        color: _Palette.brandName,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: _Palette.metaText,
                      ),
                    ),
                    Text(
                      tagline,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: _Palette.metaText,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Expanded(child: _SocialBubbles()),
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
                            color: _Palette.metaText,
                          ),
                        ),
                      ],
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

class _SocialBubbles extends StatelessWidget {
  const _SocialBubbles();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
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
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 11, color: iconColor),
    );
  }
}

class _NewBrandsRail extends GetView<BrandsController> {
  const _NewBrandsRail();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Obx(() {
        final status = controller.newStatus.value;
        final query = controller.searchQuery.value;
        if (status.isLoading) {
          return const SizedBox(
            height: 102,
            child: _HorizontalShimmer(
              itemWidth: 72,
              height: 102,
              circular: true,
            ),
          );
        }
        if (status.isError) {
          return SizedBox(
            height: 102,
            child: _ErrorInline(
              message: status.errorMessage ?? 'Failed to load new brands',
              onRetry: controller.loadNewBrands,
            ),
          );
        }
        final items = _filterBrands(controller.newBrands, query);
        if (items.isEmpty) {
          return const SizedBox(
            height: 102,
            child: _EmptyInline(label: 'No new brands yet'),
          );
        }
        return SizedBox(
          height: 102,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) => BrandCircleItem(brand: items[i]),
          ),
        );
      }),
    );
  }
}

class _CategoriesSection extends GetView<BrandsController> {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final status = controller.categoriesStatus.value;
        if (status.isLoading) {
          return const _VerticalShimmer(rows: 6);
        }
        if (status.isError) {
          return _ErrorInline(
            message: status.errorMessage ?? 'Failed to load categories',
            onRetry: controller.loadCategories,
          );
        }
        final items = controller.categories;
        if (items.isEmpty) {
          return const _EmptyInline(label: 'No categories available');
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _Palette.settingsBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0)
                  const Divider(height: 1, color: _Palette.settingsBorder),
                _CategoryRow(
                  label: items[i],
                  onTap: () => controller.onCategorySelected(items[i]),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
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
                alignment: Alignment.center,
                child: Icon(
                  _categoryIcon(label),
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 20 / 16,
                    color: _Palette.titleText,
                  ),
                ),
              ),
              SvgPicture.asset(
                AppImages.iconChevronRight,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF9CA3AF),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _categoryIcon(String label) {
  final key = label.toLowerCase();
  if (key.contains('beauty') || key.contains('cosmetic')) {
    return RemixIcons.brush_ai_line;
  }
  if (key.contains('fashion') || key.contains('apparel')) {
    return RemixIcons.handbag_line;
  }
  if (key.contains('food') || key.contains('restaurant')) {
    return RemixIcons.restaurant_2_line;
  }
  if (key.contains('drink') || key.contains('beverage')) {
    return RemixIcons.goblet_line;
  }
  if (key.contains('hospital') || key.contains('hotel') || key.contains('travel')) {
    return RemixIcons.flower_line;
  }
  if (key.contains('shop') || key.contains('retail') || key.contains('store')) {
    return RemixIcons.store_2_line;
  }
  if (key.contains('kid') || key.contains('child')) {
    return RemixIcons.emotion_happy_line;
  }
  if (key.contains('health') || key.contains('fitness')) {
    return RemixIcons.heart_2_line;
  }
  if (key.contains('tech') || key.contains('electronic')) {
    return RemixIcons.smartphone_line;
  }
  return RemixIcons.price_tag_3_line;
}

List<BrandEntity> _filterBrands(List<BrandEntity> source, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return source;
  return source
      .where(
        (b) =>
            b.name.toLowerCase().contains(q) ||
            (b.categoryName ?? '').toLowerCase().contains(q) ||
            (b.bio ?? '').toLowerCase().contains(q),
      )
      .toList();
}

class _ErrorInline extends StatelessWidget {
  const _ErrorInline({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(onPressed: onRetry, child: Text(message)),
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
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 13,
          color: _Palette.metaText,
        ),
      ),
    );
  }
}

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
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => Container(
        width: itemWidth,
        height: circular ? itemWidth : height,
        decoration: BoxDecoration(
          color: _Palette.shimmerBase,
          borderRadius: BorderRadius.circular(circular ? 999 : 16),
        ),
      ),
    );
  }
}

class _VerticalShimmer extends StatelessWidget {
  const _VerticalShimmer({this.rows = 5});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        rows,
        (_) => Container(
          height: 64,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: _Palette.shimmerBase,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
