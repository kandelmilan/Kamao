part of 'home_view.dart';

// ═════════════════════════════════════════════════════════════
// Lower home sections
// ═════════════════════════════════════════════════════════════

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.onChanged, required this.onClear});

  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  var _hasText = false;
  var _focused = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus != _focused) {
        setState(() => _focused = _focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onClear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _focused
        ? AppColors.seeAllGreen.withValues(alpha: 0.55)
        : AppColors.searchBorder;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor, width: _focused ? 1.5 : 1),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AppColors.seeAllGreen.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Icon(
            RemixIcons.search_line,
            size: 16,
            color: _focused ? AppColors.seeAllGreen : const Color(0xFF6E6971),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _focusNode.unfocus(),
              cursorColor: AppColors.seeAllGreen,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.heading,
              ),
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Search brands, categories...',
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6E6971),
                ),
              ),
            ),
          ),
          if (_hasText)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: GestureDetector(
                onTap: _clear,
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: Color(0xFF6E6971),
                ),
              ),
            ),
          const Icon(
            RemixIcons.filter_3_line,
            size: 16,
            color: Color(0xFF6E6971),
          ),
        ],
      ),
    );
  }
}

class _CategoryChipsRow extends StatelessWidget {
  const _CategoryChipsRow({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Obx(() {
        final selectedName = controller.selectedCategory.value;
        final names = controller.allCategoryNames;
        final allSelected = selectedName == null || selectedName.trim().isEmpty;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: names.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _CategoryChip(
                label: 'All',
                selected: allSelected,
                onTap: () => controller.selectCategory(null),
              );
            }
            final name = names[index - 1];
            final selected =
                !allSelected &&
                selectedName.trim().toLowerCase() == name.toLowerCase();
            return _CategoryChip(
              label: name,
              selected: selected,
              onTap: () => controller.selectCategory(name),
            );
          },
        );
      }),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: EdgeInsets.symmetric(
            horizontal: selected ? 16 : 15,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.chipSelected : AppColors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.chipSelected : AppColors.searchBorder,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
              color: selected ? AppColors.white : AppColors.subtext,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitleIcon extends StatelessWidget {
  const _SectionTitleIcon({
    required this.icon,
    this.iconSize = 20,
    this.color,
  });

  final IconData icon;
  final double iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: iconSize,
      color: color ?? AppColors.cardTitle,
    );
  }
}

class _BrandsSection extends StatelessWidget {
  const _BrandsSection({
    required this.title,
    required this.icon,
    required this.brands,
    required this.isLoading,
    this.iconSize = 20,
    this.iconColor,
    this.seeAll,
    this.hideWhenEmpty = false,
  });

  final String title;
  final IconData icon;
  final double iconSize;
  final Color? iconColor;
  final List<BrandEntity> Function() brands;
  final bool Function() isLoading;
  final VoidCallback? seeAll;

  /// When true, the whole section (title included) is hidden if there
  /// is no data after loading finishes.
  final bool hideWhenEmpty;

  HomeController get controller => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = isLoading();
      // Read length so GetX tracks the RxList mutation.
      final list = brands();
      final count = list.length;

      if (hideWhenEmpty && !loading && count == 0) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _SectionTitleIcon(
                  icon: icon,
                  iconSize: iconSize,
                  color: iconColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cardTitle,
                    ),
                  ),
                ),
                if (seeAll != null)
                  GestureDetector(
                    onTap: seeAll,
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.seeAllGreen,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            // Circle (≤72) + gap (6) + 2-line name (~32)
            height: 114,
            child: loading && count == 0
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : count == 0
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'No brands yet',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.bodyGrey,
                        ),
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      // Exactly 4 brands visible; extra items scroll horizontally.
                      const visibleCount = 4;
                      const horizontalPadding = 20.0;
                      const gap = 8.0;
                      final available =
                          constraints.maxWidth - (horizontalPadding * 2);
                      final itemWidth =
                          (available - gap * (visibleCount - 1)) /
                          visibleCount;

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: count,
                        separatorBuilder: (_, _) =>
                            const SizedBox(width: gap),
                        itemBuilder: (context, index) => BrandCircleItem(
                          brand: list[index],
                          width: itemWidth,
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}

class _FavouriteCampaignsSection extends StatelessWidget {
  const _FavouriteCampaignsSection({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.filteredFavouriteCampaigns;
      final loading = controller.isFavouriteCampaignsLoading.value;

      // Hide title + content when there are no favourites.
      if (!loading && list.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const _SectionTitleIcon(
                  icon: RemixIcons.heart_line,
                  iconSize: 20,
                  color: Color(0xFF29252A),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Favourite Campaigns',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 24 / 18,
                      color: AppColors.cardTitle,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: controller.seeAllFavouriteCampaigns,
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.seeAllGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 230,
            child: loading && list.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final isPopular = controller.popularCampaigns.any(
                        (c) => c.id == item.campaign.id,
                      );
                      return _FavouriteCampaignCard(
                        item: item,
                        showPopularBadge: isPopular,
                        onTap: () => controller.openCampaign(item.campaign),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}

class _FavouriteCampaignCard extends StatelessWidget {
  const _FavouriteCampaignCard({
    required this.item,
    required this.onTap,
    this.showPopularBadge = false,
  });

  final FavouriteCampaignEntity item;
  final VoidCallback onTap;
  final bool showPopularBadge;

  @override
  Widget build(BuildContext context) {
    final campaign = item.campaign;
    final coverUrl = resolveImageUrl(campaign.brandCoverUrl);
    final logoUrl = resolveImageUrl(campaign.brandLogoUrl);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 148,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 108,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: SizedBox(
                      height: 90,
                      width: double.infinity,
                      child: ColoredBox(
                        color: const Color(0xFFFFF7ED),
                        child: coverUrl == null
                            ? const SizedBox.shrink()
                            : Image.network(
                                coverUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const SizedBox.shrink(),
                              ),
                      ),
                    ),
                  ),
                  if (showPopularBadge)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2.25),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFF7FAF6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE86161),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Popular',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                height: 11.25 / 9,
                                color: AppColors.seeAllGreen,
                              ),
                            ),
                          ],
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
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, -1),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: logoUrl == null
                            ? const ColoredBox(
                                color: Color(0xFFF3F4F6),
                                child: Icon(
                                  RemixIcons.store_2_line,
                                  size: 16,
                                ),
                              )
                            : Image.network(
                                logoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const ColoredBox(
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
                    campaign.brandName,
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
                  Text(
                    campaign.contentTypeLabel.isNotEmpty
                        ? campaign.contentTypeLabel
                        : (campaign.brandCategory ?? 'Campaign'),
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
                  Text(
                    campaign.name,
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
                  Row(
                    children: [
                      for (var i = 0;
                          i < campaign.displayPlatforms.length;
                          i++) ...[
                        if (i > 0) const SizedBox(width: 5),
                        _SocialBubble.forPlatform(
                          campaign.displayPlatforms[i],
                        ),
                      ],
                      const Spacer(),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.searchBorder,
                            width: 0.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          RemixIcons.arrow_right_s_line,
                          size: 14,
                          color: AppColors.cardTitle,
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

class _SocialBubble extends StatelessWidget {
  const _SocialBubble({
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  factory _SocialBubble.forPlatform(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const _SocialBubble(
          color: Color(0x14FF007F),
          icon: RemixIcons.instagram_line,
          iconColor: Color(0xFFE1306C),
        );
      case 'tiktok':
        return const _SocialBubble(
          color: Color(0x14000000),
          icon: RemixIcons.tiktok_line,
          iconColor: Colors.black,
        );
      case 'facebook':
        return const _SocialBubble(
          color: Color(0xFFE9EFFD),
          icon: RemixIcons.facebook_fill,
          iconColor: Color(0xFF1877F2),
        );
      case 'youtube':
        return const _SocialBubble(
          color: Color(0x14E02020),
          icon: RemixIcons.youtube_fill,
          iconColor: Color(0xFFE02020),
        );
      default:
        return const _SocialBubble(
          color: Color(0xFFF3F4F6),
          icon: RemixIcons.links_line,
          iconColor: Color(0xFF6E6971),
        );
    }
  }

  final Color color;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Icon(icon, size: 11, color: iconColor),
    );
  }
}

class _RecentlyRewardedSection extends StatelessWidget {
  const _RecentlyRewardedSection({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recently Rewarded',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.cardTitle,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Top posts from our member community',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6F6875),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: controller.viewAllRecentlyRewarded,
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.seeAllGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 177,
          child: Obx(() {
            final list = controller.filteredRecentlyRewarded;
            if (controller.isRecentlyRewardedLoading.value && list.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (list.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'No rewarded posts yet',
                    style: TextStyle(fontSize: 13, color: AppColors.bodyGrey),
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _RewardedPostCard(
                post: list[index],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _RewardedPostCard extends StatelessWidget {
  const _RewardedPostCard({required this.post});

  final RewardedPostEntity post;

  @override
  Widget build(BuildContext context) {
    final thumb = post.thumbnailImageUrl;
    final logo = post.brandLogoImageUrl;

    // Taps disabled until rewarded-post detail is wired correctly.
    return Container(
      width: 122,
      height: 177,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF3F4F6),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (thumb != null)
              Image.network(
                thumb,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const ColoredBox(color: Color(0xFFE7E2EC)),
              )
            else
              const ColoredBox(color: Color(0xFFE7E2EC)),
            Positioned(
              left: 5,
              right: 5,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 2.4,
                          offset: const Offset(0, -0.8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: logo == null
                          ? const Icon(RemixIcons.store_2_line, size: 12)
                          : Image.network(
                              logo,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                RemixIcons.store_2_line,
                                size: 12,
                              ),
                            ),
                    ),
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xD99EBD9A),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFAED0A9),
                        width: 0.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      RemixIcons.play_fill,
                      size: 11,
                      color: Colors.white,
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
