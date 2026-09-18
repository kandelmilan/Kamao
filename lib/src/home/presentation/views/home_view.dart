import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/auth/presentation/widgets/creator_level_badge.dart';
import 'package:kamao/src/auth/presentation/widgets/user_avatar.dart';
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import 'package:kamao/src/brand/presentation/widgets/brand_square_item.dart';
import 'package:kamao/src/home/domain/entities/campaign/favourite_campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/rewarded_post_entity.dart';
import 'package:kamao/src/social_connections/domain/entities/social_connection_status.dart';
import 'package:kamao/src/social_connections/presentation/controllers/social_connections_controller.dart';
import 'package:kamao/src/social_connections/widgets/social_connections_sheet.dart';
import 'package:kamao/src/wallet/presentation/widgets/wallet_hero_card.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/home_controller.dart';
part 'home_lower_sections.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.homeBg,
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: controller.refreshHome,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  _HeaderSection(controller: controller),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _WalletCard(controller: controller),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const _ConnectSocialAccountsCard(),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _SearchBar(
                      onChanged: controller.onSearchChanged,
                      onClear: controller.clearSearch,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _BrandsSection(
                    title: 'Popular Brands',
                    icon: RemixIcons.fire_fill,
                    iconSize: 20,
                    iconColor: const Color(0xFFF59E0B),
                    brands: () => controller.filteredPopularBrands,
                    isLoading: () => controller.isPopularBrandsLoading.value,
                    seeAll: controller.seeAllPopularBrands,
                    hideWhenEmpty: true,
                  ),
                  const SizedBox(height: 20),
                   _CategoryChipsRow(controller: controller),
                  Obx(() {
                    if (controller.hasActiveHomeFilter &&
                        !controller.hasFilteredHomeResults &&
                        !controller.isPopularBrandsLoading.value &&
                        !controller.isRecentBrandsLoading.value &&
                        !controller.isFeaturedBrandsLoading.value &&
                        !controller.isFavouriteCampaignsLoading.value &&
                        !controller.isRecentlyRewardedLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
                        child: Text(
                          'No results found',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.bodyGrey,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  Obx(() {
                    final list = controller.filteredFavouriteCampaigns;
                    final show =
                        controller.isFavouriteCampaignsLoading.value ||
                        list.isNotEmpty;
                    if (!show) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 30),
                        _FavouriteCampaignsSection(controller: controller),
                      ],
                    );
                  }),
                  Obx(() {
                    final list = controller.filteredRecentBrands;
                    final show =
                        controller.isRecentBrandsLoading.value ||
                        list.isNotEmpty;
                    if (!show) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 30),
                        _BrandsSection(
                          title: 'Recent Brands',
                          icon: RemixIcons.time_line,
                          iconSize: 20,
                          brands: () => controller.filteredRecentBrands,
                          isLoading: () =>
                              controller.isRecentBrandsLoading.value,
                          seeAll: controller.seeAllRecentBrands,
                          hideWhenEmpty: true,
                        ),
                      ],
                    );
                  }),
                  Obx(() {
                    final list = controller.filteredFeaturedBrands;
                    final show =
                        controller.isFeaturedBrandsLoading.value ||
                        list.isNotEmpty;
                    if (!show) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        _BrandsSection(
                          title: 'Featured Brands',
                          icon: RemixIcons.star_line,
                          iconSize: 20,
                          iconColor: const Color(0xFF353037),
                          brands: () => controller.filteredFeaturedBrands,
                          isLoading: () =>
                              controller.isFeaturedBrandsLoading.value,
                          seeAll: controller.seeAllFeaturedBrands,
                          hideWhenEmpty: true,
                        ),
                      ],
                    );
                  }),
                  Obx(() {
                    final list = controller.filteredRecentlyRewarded;
                    final show =
                        controller.isRecentlyRewardedLoading.value ||
                        list.isNotEmpty ||
                        !controller.hasActiveHomeFilter;
                    if (!show) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        _RecentlyRewardedSection(controller: controller),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
  }
}

// ═════════════════════════════════════════════════════════════
// Header
// ═════════════════════════════════════════════════════════════

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          _Avatar(controller: controller),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() {
              final name = controller.greetingName;
              final level = controller.levelName;
              final levelCode = controller.levelCode;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.timeOfDayGreeting,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      color: AppColors.subtext,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name.isEmpty ? 'there' : name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            height: 25.5 / 17,
                            letterSpacing: -0.425,
                            color: AppColors.heading,
                          ),
                        ),
                      ),
                      if (level.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        CreatorLevelBadge(
                          label: level,
                          code: levelCode,
                          onTap: controller.openCreatorLevels,
                        ),
                      ],
                    ],
                  ),
                  const Text(
                    'Create. Post. Earn.',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 16.5 / 11,
                      letterSpacing: -0.275,
                      color: Color(0xFF6E6971),
                    ),
                  ),
                ],
              );
            }),
          ),
          _NotificationBell(controller: controller),
          const SizedBox(width: 8),
          _BalanceChip(controller: controller),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final name = controller.greetingName;
      return GestureDetector(
        onTap: controller.openProfile,
        behavior: HitTestBehavior.opaque,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: UserAvatar(
            size: 44,
            initial: name.isNotEmpty ? name : null,
            borderColor: const Color(0xCCFFFFFF),
            borderWidth: 1,
            backgroundColor: const Color(0xFFEDE6F1),
            fallbackIconSize: 22,
          ),
        ),
      );
    });
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.openNotifications,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              RemixIcons.notification_3_line,
              size: 18,
              color: AppColors.heading,
            ),
            Obx(() {
              if (controller.unreadNotifications.value <= 0) {
                return const SizedBox.shrink();
              }
              return Positioned(
                top: 7,
                right: 7,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.notificationDot,
                    border: Border.all(
                      color: AppColors.walletChipBg,
                      width: 2,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _BalanceChip extends StatelessWidget {
  const _BalanceChip({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.openWallet,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.fromLTRB(11, 7, 11, 7),
        decoration: BoxDecoration(
          color: AppColors.walletChipBg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.walletChipBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Icon(
                RemixIcons.wallet_3_line,
                size: 12,
                color: AppColors.walletBalance,
              ),
            ),
            const SizedBox(width: 6),
            Obx(
              () => Text(
                controller.balanceChipLabel,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.3,
                  color: AppColors.heading,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              RemixIcons.arrow_right_s_line,
              size: 14,
              color: AppColors.heading,
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Wallet card — Figma 660:2074
// ═════════════════════════════════════════════════════════════

class _WalletCard extends StatelessWidget {
  const _WalletCard({required this.controller});

  final HomeController controller;

  /// Design frame width used for proportional layout.
  static const _designW = 372.0;
  static const _designH = 179.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final s = w / _designW;
        final h = _designH * s;

        return Container(
          height: h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20 * s),
            border: Border.all(color: AppColors.walletBorder),
            gradient: const LinearGradient(
              begin: Alignment(-0.85, -0.4),
              end: Alignment(0.9, 0.6),
              colors: [
                AppColors.walletGradientStart,
                AppColors.walletGradientEnd,
              ],
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              // Large leaf blob (right side) — Figma 660:2109
              Positioned(
                left: 199 * s,
                top: -16 * s,
                width: 162.045 * s,
                height: 212.077 * s,
                child: SvgPicture.asset(
                  AppImages.walletCardLeafLarge,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 321 * s,
                top: 117 * s,
                width: 60 * s,
                height: 73 * s,
                child: SvgPicture.asset(
                  AppImages.walletCardLeafBr,
                  fit: BoxFit.fill,
                ),
              ),
              // Top-right rotated leaf — Figma 662:2140
              Positioned(
                left: 358.04 * s,
                top: 10.75 * s,
                width: 66.924 * s,
                height: 61.779 * s,
                child: Transform.rotate(
                  angle: -70.48 * 3.1415926535 / 180,
                  child: SvgPicture.asset(
                    AppImages.walletCardLeafTr,
                    width: 46.18 * s,
                    height: 54.635 * s,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Wallet + coins illustration (home overlay 663:2147)
              Positioned(
                left: 172 * s,//188 * s,
                top: 60 * s,//68 * s,
                width: 114 * s,
                height: 87 * s,
                child: Image.asset(
                  AppImages.walletCoins,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              // Balance block — Figma 660:2079
              Positioned(
                left: 18 * s,
                top: 18 * s,
                right: 120 * s,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR WALLET',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10 * s,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        height: 15 / 10,
                        color: AppColors.walletLabel,
                      ),
                    ),
                    SizedBox(height: 2 * s),
                    Obx(
                      () => Text(
                        controller.walletCardBalanceLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 28 * s,
                          fontWeight: FontWeight.w600,
                          height: 42 / 28,
                          letterSpacing: -0.7,
                          color: AppColors.walletBalance,
                        ),
                      ),
                    ),
                    Text(
                      'Available balance',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11 * s,
                        fontWeight: FontWeight.w500,
                        height: 16.5 / 11,
                        color: AppColors.walletLabel,
                      ),
                    ),
                  ],
                ),
              ),
              // Weekly growth badge — Figma 660:2089
              // Positioned(
              //   left: 267 * s,
              //   top: 19 * s,
              //   child: Obx(
              //     () => _WeeklyGrowthBadge(
              //       label: controller.weeklyGrowthAmountLabel,
              //       scale: s,
              //     ),
              //   ),
              // ),
              // View wallet CTA — Figma 660:2099
              Positioned(
                left: 19 * s,
                bottom: 34 * s,
                child: InkWell(
                  onTap: controller.openWallet,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16 * s,
                      vertical: 8 * s,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.walletButton,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6 * s,
                          offset: Offset(0, 4 * s),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View wallet',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12 * s,
                            fontWeight: FontWeight.w500,
                            height: 16 / 12,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: 6 * s),
                        SvgPicture.asset(
                          AppImages.walletViewArrow,
                          width: 12 * s,
                          height: 12 * s,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}





// ═════════════════════════════════════════════════════════════
// Connect Social Accounts card 
// ═════════════════════════════════════════════════════════════

class _ConnectSocialAccountsCard extends StatelessWidget {
  const _ConnectSocialAccountsCard();

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SocialConnectionsController>()) {
      return const SizedBox.shrink();
    }

    final social = Get.find<SocialConnectionsController>();

    return Obx(() {
      final platforms = social.socialPlatforms;
      final connections = social.socialConnections;

      void open() => social.openSheet(context);

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.searchBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connect Social Accounts',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
                color: AppColors.cardTitle,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Boost your reward tier by verifying channels.',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 16.5 / 11,
                color: AppColors.bodyGrey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 0; i < platforms.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  SocialBubble(
                    platform: platforms[i],
                    status:
                        connections[platforms[i].id] ??
                        SocialConnectionStatus.initial,
                    onTap: open,
                  ),
                ],
                const Spacer(),
                Material(
                  color: AppColors.walletButton,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: open,
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      child: Text(
                        'Connect Now',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _WeeklyGrowthBadge extends StatelessWidget {
  const _WeeklyGrowthBadge({required this.label, this.scale = 1});

  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11 * s, vertical: 7 * s),
      decoration: BoxDecoration(
        color: const Color(0xD9FFFFFF),
        borderRadius: BorderRadius.circular(12 * s),
        border: Border.all(color: const Color(0xE6FFFFFF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2 * s,
            offset: Offset(0, 1 * s),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16 * s,
            height: 16 * s,
            decoration: const BoxDecoration(
              color: Color(0xFFDAE9D7),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppImages.walletGrowthArrow,
              width: 10 * s,
              height: 10 * s,
            ),
          ),
          SizedBox(width: 6 * s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10 * s,
                  fontWeight: FontWeight.w500,
                  height: 12.5 / 10,
                  color: AppColors.heading,
                ),
              ),
              Text(
                'this week',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 9 * s,
                  fontWeight: FontWeight.w500,
                  height: 11.25 / 9,
                  color: const Color(0xFF6E6971),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
