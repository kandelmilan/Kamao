// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'dart:ui' as ui;
// import 'package:get/get.dart';
// import 'package:kamao/app/app.dart';
// import 'package:kamao/core/core.dart';
// import 'package:kamao/core/utils/image_url_resolver.dart';
// import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
// import 'package:kamao/src/home/domain/entities/rewarded_post_entity.dart';
// import 'package:kamao/src/social_connections/domain/entities/social_connection_status.dart';
// import 'package:kamao/src/social_connections/widgets/social_connections_sheet.dart';
// import 'package:remixicon/remixicon.dart';
// import '../controllers/home_controller.dart';

// class HomeView extends GetView<HomeController> {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       type: MaterialType.transparency,
//       child: Container(
//         color: AppColors.background,
//         child: SafeArea(
//           bottom: false,
//           child: RefreshIndicator(
//             onRefresh: controller.refreshHome,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: const EdgeInsets.only(bottom: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   _GreetingSection(controller: controller),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                     child: _WalletCard(),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 12,
//                     ),
//                     child: _SocialCard(controller: controller),
//                   ),
//                   PopularCampaignsSection(controller: controller),
//                   // const SizedBox(height: 8),
//                   _RecentlyViewedSection(controller: controller),
//                   // const SizedBox(height: 8),
//                   _FavouriteCampaignsSection(controller: controller),
//                   // const SizedBox(height: 8),
//                   _RecentlyRewardedSection(controller: controller),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _GreetingSection extends StatelessWidget {
//   const _GreetingSection({required this.controller});

//   final HomeController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
//       child: Row(
//         children: [
//           const _Avatar(),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Obx(() {
//               final name = controller.greetingName;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name.isEmpty ? 'Hey there 👋' : 'Hey $name 👋',
//                     style: const TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 28,
//                       fontWeight: FontWeight.w900,
//                       color: AppColors.heading,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   const Text(
//                     "Welcome back! Here's what's new.",
//                     style: TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.subtext,
//                     ),
//                   ),
//                 ],
//               );
//             }),
//           ),
//           _NotificationBell(controller: controller),
//         ],
//       ),
//     );
//   }
// }

// /// Avatar placeholder — plain icon on a tinted circle, no image/asset
// /// dependency. Swap the Icon for a real Image.network(user.avatarUrl)
// /// once UserEntity exposes an avatar field.
// class _Avatar extends StatelessWidget {
//   const _Avatar();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 53,
//       height: 53,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.white, width: 2.65),
//         color: const Color(0xFFEDE6F1),
//       ),
//       alignment: Alignment.center,
//       child: const Icon(
//         RemixIcons.user_3_fill,
//         size: 24,
//         color: AppColors.primary,
//       ),
//     );
//   }
// }

// class _NotificationBell extends StatelessWidget {
//   const _NotificationBell({required this.controller});

//   final HomeController controller;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: controller.openNotifications,
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x1A4B0070),
//               blurRadius: 8,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             const Icon(
//               RemixIcons.notification_3_line,
//               size: 20,
//               color: AppColors.heading,
//             ),
//             Obx(() {
//               if (controller.unreadNotifications.value <= 0) {
//                 return const SizedBox.shrink();
//               }
//               return const Positioned(top: 8, right: 9, child: _Dot());
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Dot extends StatelessWidget {
//   const _Dot();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 7,
//       height: 7,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: AppColors.accent,
//         border: Border.all(color: Colors.white, width: 1.5),
//       ),
//     );
//   }
// }

// class _WalletCard extends StatelessWidget {
//   const _WalletCard();

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<HomeController>();

//     return Container(
//       width: 363,
//       constraints: const BoxConstraints(minHeight: 177),
//       padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(19),
//         border: Border.all(color: AppColors.white, width: 1),
//         gradient: const LinearGradient(
//           begin: Alignment(-0.22, -2.2),
//           end: Alignment.bottomLeft,
//           colors: [
//             Colors.white, // pure white
//             Colors.white, // still pure white — locks the "no color" zone
//             Color(0xFFEFD4FF), // purple
//           ],
//           stops: [0.0, 0.4, 1.0],
//         ),
//         boxShadow: const [
//           BoxShadow(
//             color: AppColors.shadow,
//             blurRadius: 8,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Positioned(
//             top: 8,
//             left: 244,
//             child: Opacity(
//               opacity: 0.37,
//               child: SvgPicture.asset(
//                 AppImages.walletBackground,
//                 width: 119,
//                 height: 136,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           // Wallet + cash + coin graphic.
//           Positioned(
//             top: 48,
//             left: 273,
//             child: SvgPicture.asset(
//               AppImages.wallet,
//               width: 70,
//               height: 50,
//               fit: BoxFit.contain,
//             ),
//           ),
//           // Receding card outlines (Content.svg → wallet_bc.svg).
//           // Positioned(
//           //   top: 0,
//           //   right: -8,
//           //   child: SvgPicture.asset(
//           //     AppImages.walletBackground,
//           //     width: 119,
//           //     height: 136,
//           //     fit: BoxFit.contain,
//           //   ),
//           // ),
//           // Wallet + cash + coin graphic — exact Figma coordinates
//           // (wallet_earnings_graphic_1.svg → wallet1.svg).
//           // Positioned(
//           //   top: 43,
//           //   left: 255,
//           //   child: SvgPicture.asset(
//           //     AppImages.wallet,
//           //     width: 79.444,
//           //     height: 55,
//           //     fit: BoxFit.contain,
//           //   ),
//           // ),
//           Padding(
//             padding: const EdgeInsets.only(right: 90),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'AVAILABLE BALANCE',
//                       style: AppTextStyles.label.copyWith(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.6,
//                         color: const Color(0xFF3F3F46),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     GestureDetector(
//                       onTap: controller.toggleBalanceVisibility,
//                       child: Obx(
//                         () => Icon(
//                           controller.isBalanceVisible.value
//                               ? RemixIcons.eye_line
//                               : RemixIcons.eye_off_line,
//                           size: 18,
//                           color: const Color(0xFF3F3F46),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Obx(() {
//                   if (controller.isWalletLoading.value &&
//                       controller.wallet.value == null) {
//                     return const SizedBox(
//                       height: 32,
//                       width: 32,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2.5,
//                         color: AppColors.accentDark,
//                       ),
//                     );
//                   }
//                   final label = controller.isBalanceVisible.value
//                       ? controller.walletCardBalanceLabel
//                       : '••••••';
//                   return Text(
//                     label,
//                     style: const TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 24,
//                       fontWeight: FontWeight.w700,
//                       height: 1.0,
//                       letterSpacing: 0,
//                       color: Color(0xFF4B0070),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 10),
//                 // Withdrawable pill. Always visible — shows the real
//                 // figure once the backend supports it, "****" until
//                 // then. See HomeController.formattedWithdrawable.
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 4,
//                     vertical: 2,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0x42E8F6ED),
//                     borderRadius: BorderRadius.circular(2),
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.6),
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 16,
//                         height: 16,
//                         child: const Icon(
//                           RemixIcons.wallet_3_fill,
//                           size: 13,
//                           color: Color(0xFF16A34A),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Withdrawable : '
//                         '${controller.formattedWithdrawable ?? '****'}',
//                         style: const TextStyle(
//                           fontFamily: 'Roboto',
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           height: 1.0,
//                           letterSpacing: 0,
//                           color: Color(0xFF16A34A),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 // Withdraw button — fixed 110x31 per Figma spec.
//                 SizedBox(
//                   width: 110,
//                   height: 31,
//                   child: ElevatedButton(
//                     onPressed: controller.withdraw,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: const Color(0xFF4B0070),
//                       elevation: 0,
//                       shadowColor: Colors.transparent,
//                       padding: EdgeInsets.zero,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Withdraw',
//                           style: TextStyle(
//                             fontFamily: 'Roboto',
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                             height: 1.0,
//                             letterSpacing: 0.65,
//                             color: Color(0xFF4B0070),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         // Rotated 90° so the logout arrow points up,
//                         // standing in for an "export/withdraw" glyph.
//                         Transform.rotate(
//                           angle: 1.5708,
//                           child: const Icon(
//                             RemixIcons.logout_box_line,
//                             size: 16,
//                             color: Color(0xFF4B0070),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// "Connect Social Accounts" card — bubbles show live per-platform
// /// connection state (check badge once connected), and both the
// /// bubbles and "Connect Now" open the connect/manage sheet from
// /// social_connections_sheet.dart, which drives the actual OAuth flow
// /// via controller.connectPlatform(platform.id).
// class _SocialCard extends StatelessWidget {
//   const _SocialCard({required this.controller});

//   final HomeController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: AppColors.socialCardBg,
//         border: Border.all(color: AppColors.socialCardBorder),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Connect Social Accounts',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: AppColors.cardTitle,
//             ),
//           ),
//           const SizedBox(height: 4),
//           const Text(
//             'Boost your reward tier by verifying channels.',
//             style: TextStyle(
//               fontSize: 12,
//               color: AppColors.bodyGrey,
//               height: 1.3,
//             ),
//           ),
//           const SizedBox(height: 14),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   for (final platform in controller.socialPlatforms)
//                     Padding(
//                       padding: const EdgeInsets.only(right: 8),
//                       child: Obx(
//                         () => SocialBubble(
//                           platform: platform,
//                           status:
//                               controller.socialConnections[platform.id] ??
//                               SocialConnectionStatus.initial,
//                           onTap: () =>
//                               showSocialConnectionsSheet(context, controller),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               Obx(() {
//                 final allConnected = controller.socialPlatforms.every(
//                   (p) =>
//                       controller.socialConnections[p.id]?.state ==
//                       SocialConnectionState.connected,
//                 );
//                 return ElevatedButton(
//                   onPressed: allConnected
//                       ? null
//                       : () => showSocialConnectionsSheet(context, controller),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     disabledBackgroundColor: AppColors.chipUnselectedBorder,
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 8,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     allConnected ? 'All Connected' : 'Connect Now',
//                     style: const TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// "Popular Campaigns" — square tiles, backed by
// /// HomeController.popularCampaigns (GetPopularCampaignsUseCase).
// class PopularCampaignsSection extends StatelessWidget {
//   const PopularCampaignsSection({super.key, required this.controller});

//   final HomeController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 20, 0, 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(
//                       RemixIcons.fire_fill,
//                       size: 20,
//                       color: Color(0xFFFF5722),
//                     ),
//                     const SizedBox(width: 6),
//                     const Text(
//                       'Popular Campaigns',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.cardTitle,
//                       ),
//                     ),
//                   ],
//                 ),
//                 InkWell(
//                   onTap: controller.seeAllPopularCampaigns,
//                   child: const Text(
//                     'See All',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             height: 118,
//             child: Obx(() {
//               if (controller.isPopularCampaignsLoading.value &&
//                   controller.popularCampaigns.isEmpty) {
//                 return const Center(
//                   child: SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(strokeWidth: 2.4),
//                   ),
//                 );
//               }

//               if (controller.popularCampaignsError.value != null &&
//                   controller.popularCampaigns.isEmpty) {
//                 return Center(
//                   child: TextButton(
//                     onPressed: controller.loadPopularCampaigns,
//                     child: const Text("Couldn't load — tap to retry"),
//                   ),
//                 );
//               }

//               if (controller.popularCampaigns.isEmpty) {
//                 return const SizedBox.shrink();
//               }

//               return ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.only(right: 20),
//                 itemCount: controller.popularCampaigns.length,
//                 separatorBuilder: (_, __) => const SizedBox(width: 12),
//                 itemBuilder: (context, index) {
//                   final campaign = controller.popularCampaigns[index];
//                   return _CampaignSquareItem(
//                     campaign: campaign,
//                     onTap: () => controller.openCampaign(campaign),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CampaignSquareItem extends StatelessWidget {
//   const _CampaignSquareItem({required this.campaign, required this.onTap});

//   final CampaignEntity campaign;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final logoUrl = resolveImageUrl(campaign.brandLogoUrl);

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(18),
//       child: SizedBox(
//         width: 79,
//         child: Column(
//           children: [
//             Container(
//               width: 72,
//               height: 72,
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: const Color(0xFFF4F4F4),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Color(0x14000000),
//                     blurRadius: 6,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               alignment: Alignment.center,
//               child: logoUrl == null
//                   ? const Icon(
//                       RemixIcons.store_2_line,
//                       size: 28,
//                       color: AppColors.heading,
//                     )
//                   : ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(
//                         logoUrl,
//                         fit: BoxFit.contain,
//                         width: double.infinity,
//                         height: double.infinity,
//                         loadingBuilder: (context, child, progress) {
//                           if (progress == null) return child;
//                           return const Center(
//                             child: SizedBox(
//                               width: 18,
//                               height: 18,
//                               child: CircularProgressIndicator(strokeWidth: 2),
//                             ),
//                           );
//                         },
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Icon(
//                             RemixIcons.store_2_line,
//                             size: 28,
//                             color: AppColors.heading,
//                           );
//                         },
//                       ),
//                     ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               campaign.brandName,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.heading,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// "Recently Viewed" — circular avatar tiles, backed by
// /// HomeController.marketplaceRecentCampaigns (GetMarketplaceRecentUseCase).
// /// The whole section (icon + title included) is hidden once loading
// /// has finished and there's genuinely nothing to show — an empty
// /// "Recently Viewed" header with no items looks broken, not empty.
// class _RecentlyViewedSection extends StatelessWidget {
//   const _RecentlyViewedSection({required this.controller});

//   final HomeController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isLoading = controller.isMarketplaceRecentLoading.value;
//       final hasError = controller.marketplaceRecentError.value != null;
//       final items = controller.marketplaceRecentCampaigns;

//       // Nothing loading, no error to retry, and no items — don't
//       // render the section at all (no header, no empty strip).
//       if (!isLoading && !hasError && items.isEmpty) {
//         return const SizedBox.shrink();
//       }

//       return Padding(
//         padding: const EdgeInsets.fromLTRB(20, 20, 0, 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(right: 20),
//               child: Row(
//                 children: [
//                   Icon(
//                     RemixIcons.time_line,
//                     size: 20,
//                     color: AppColors.heading,
//                   ),
//                   SizedBox(width: 6),
//                   Text(
//                     'Recently Viewed',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.cardTitle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 92,
//               child: Builder(
//                 builder: (context) {
//                   if (isLoading && items.isEmpty) {
//                     return const Center(
//                       child: SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(strokeWidth: 2.4),
//                       ),
//                     );
//                   }

//                   if (hasError && items.isEmpty) {
//                     return Center(
//                       child: TextButton(
//                         onPressed: controller.loadMarketplaceRecent,
//                         child: const Text(
//                           "Couldn't load recent items — tap to retry",
//                         ),
//                       ),
//                     );
//                   }

//                   return ListView.separated(
//                     scrollDirection: Axis.horizontal,
//                     padding: const EdgeInsets.only(right: 20),
//                     itemCount: items.length,
//                     separatorBuilder: (_, __) => const SizedBox(width: 12),
//                     itemBuilder: (context, index) {
//                       final recent = items[index];
//                       return _CampaignCircleItem(
//                         campaign: recent.campaign,
//                         onTap: () => controller.openCampaign(recent.campaign),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// /// "Favourite Campaigns" — circular avatar tiles, backed by
// /// HomeController.favouriteCampaigns (GetFavouriteCampaignsUseCase).
// /// Same rule as Recently Viewed: hide the whole section, header
// /// included, once loading has finished and there's nothing to show.
// class _FavouriteCampaignsSection extends StatelessWidget {
//   const _FavouriteCampaignsSection({required this.controller});

//   final HomeController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isLoading = controller.isFavouriteCampaignsLoading.value;
//       final hasError = controller.favouriteCampaignsError.value != null;
//       final items = controller.favouriteCampaigns;

//       if (!isLoading && !hasError && items.isEmpty) {
//         return const SizedBox.shrink();
//       }

//       return Padding(
//         padding: const EdgeInsets.fromLTRB(20, 20, 0, 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(right: 20),
//               child: Row(
//                 children: [
//                   Icon(
//                     RemixIcons.heart_line,
//                     size: 20,
//                     color: AppColors.heading,
//                   ),
//                   SizedBox(width: 6),
//                   Text(
//                     'Favourite Campaigns',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.cardTitle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 92,
//               child: Builder(
//                 builder: (context) {
//                   // if (isLoading && items.isEmpty) {
//                   //   return const Center(
//                   //     child: SizedBox(
//                   //       width: 24,
//                   //       height: 24,
//                   //       child: CircularProgressIndicator(strokeWidth: 2.4),
//                   //     ),
//                   //   );
//                   // }
//                   if (!isLoading && !hasError && items.isEmpty) {
//                     return const SizedBox.shrink();
//                   }
//                   if (hasError && items.isEmpty) {
//                     return Center(
//                       child: TextButton(
//                         onPressed: controller.loadFavouriteCampaigns,
//                         child: const Text(
//                           "Couldn't load favourites — tap to retry",
//                         ),
//                       ),
//                     );
//                   }

//                   return ListView.separated(
//                     scrollDirection: Axis.horizontal,
//                     padding: const EdgeInsets.only(right: 20),
//                     itemCount: items.length,
//                     separatorBuilder: (_, __) => const SizedBox(width: 12),
//                     itemBuilder: (context, index) {
//                       final fav = items[index];
//                       return _CampaignCircleItem(
//                         campaign: fav.campaign,
//                         onTap: () => controller.openCampaign(fav.campaign),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// class _CampaignCircleItem extends StatelessWidget {
//   const _CampaignCircleItem({required this.campaign, required this.onTap});

//   final CampaignEntity campaign;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final logoUrl = resolveImageUrl(
//       campaign.brandLogoUrl,
//     ); // ← was: campaign.brandLogoUrl
//     final name = campaign.brandName;

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(40),
//       child: SizedBox(
//         width: 72,
//         child: Column(
//           children: [
//             Container(
//               width: 60,
//               height: 60,
//               clipBehavior: Clip.antiAlias,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.brandLogoBg,
//                 border: Border.all(color: AppColors.chipUnselectedBorder),
//               ),
//               alignment: Alignment.center,
//               child: logoUrl == null
//                   ? Text(
//                       name.isNotEmpty ? name[0].toUpperCase() : '?',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.primary,
//                       ),
//                     )
//                   : Image.network(
//                       logoUrl,
//                       fit: BoxFit.cover,
//                       width: 60,
//                       height: 60,
//                       loadingBuilder: (context, child, progress) {
//                         if (progress == null) return child;
//                         return const Center(
//                           child: SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) => Text(
//                         name.isNotEmpty ? name[0].toUpperCase() : '?',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.primary,
//                         ),
//                       ),
//                     ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               name,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.heading,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Horizontal rail of recent rewarded posts — thumbnail image, a
// /// brand-name pill top-left, and a payout badge bottom-right. There's
// /// no creator handle/avatar in the API response, so this shows a
// /// generic account icon + the post's platform rather than a
// /// fabricated "@handle". Backed by GET /creator/home/recently-rewarded.
// class _RecentlyRewardedSection extends StatelessWidget {
//   const _RecentlyRewardedSection({required this.controller});

//   final HomeController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 20, 0, 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Recently Rewarded',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.cardTitle,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         'Top posts from our member community',
//                         style: TextStyle(
//                           fontSize: 12.5,
//                           color: AppColors.bodyGrey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 InkWell(
//                   onTap: controller.viewAllRecentlyRewarded,
//                   child: const Padding(
//                     padding: EdgeInsets.only(top: 2),
//                     child: Text(
//                       'View All',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 14),
//           SizedBox(
//             height: 190,
//             child: Obx(() {
//               if (controller.isRecentlyRewardedLoading.value &&
//                   controller.recentlyRewarded.isEmpty) {
//                 return const Center(
//                   child: SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(strokeWidth: 2.4),
//                   ),
//                 );
//               }

//               if (controller.recentlyRewardedError.value != null &&
//                   controller.recentlyRewarded.isEmpty) {
//                 return Center(
//                   child: TextButton(
//                     onPressed: controller.loadRecentlyRewarded,
//                     child: const Text(
//                       'Couldn\'t load recent posts — tap to retry',
//                     ),
//                   ),
//                 );
//               }

//               final posts = controller.displayableRecentlyRewarded;

//               if (posts.isEmpty) {
//                 return const SizedBox.shrink();
//               }

//               return ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.only(right: 20),
//                 itemCount: posts.length,
//                 separatorBuilder: (_, __) => const SizedBox(width: 12),
//                 itemBuilder: (context, index) {
//                   final post = posts[index];
//                   return _RewardedPostCard(
//                     post: post,
//                     onTap: () => controller.openRewardedPost(post),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _RewardedPostCard extends StatelessWidget {
//   const _RewardedPostCard({required this.post, required this.onTap});

//   final RewardedPostEntity post;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final thumbnailUrl = resolveImageUrl(post.brandLogoUrl);

//     if (thumbnailUrl == null) {
//       return const SizedBox.shrink();
//     }

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         width: 148,
//         height: 190,
//         clipBehavior: Clip.antiAlias,
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Image.network(
//               thumbnailUrl,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, progress) {
//                 if (progress == null) return child;
//                 return Container(
//                   color: const Color(0xFFF4F4F4),
//                   alignment: Alignment.center,
//                   child: const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   ),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) => Container(
//                 color: const Color(0xFFF4F4F4),
//                 alignment: Alignment.center,
//                 child: const Icon(
//                   RemixIcons.image_2_line,
//                   size: 22,
//                   color: AppColors.bodyGrey,
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               height: 64,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [Colors.transparent, Color(0xCC000000)],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 12,
//               left: 12,
//               right: 12,
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ui.ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 7,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.11),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         post.brandName,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.cardTitle,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 12,
//               right: 12,
//               bottom: 12,
//               child: Row(
//                 children: [
//                   Container(
//                     width: 26,
//                     height: 26,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(.9),
//                       border: Border.all(color: Colors.white, width: 1.5),
//                     ),
//                     alignment: Alignment.center,
//                     child: const Icon(
//                       RemixIcons.user_3_fill,
//                       size: 13,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   const SizedBox(width: 7),
//                   Expanded(
//                     child: Text(
//                       post.platform,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';

import 'package:kamao/src/home/domain/entities/rewarded_post_entity.dart';
import 'package:kamao/src/social_connections/domain/entities/social_connection_status.dart';
import 'package:kamao/src/social_connections/widgets/social_connections_sheet.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: AppColors.background,
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: controller.refreshHome,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _GreetingSection(controller: controller),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: _WalletCard(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: _SocialCard(controller: controller),
                  ),
                  PopularCampaignsSection(controller: controller),
                  _RecentlyViewedSection(controller: controller),
                  _FavouriteCampaignsSection(controller: controller),
                  _RecentlyRewardedSection(controller: controller),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: _CategoryChipsRow(controller: controller),
                  ),
                  _CategoryFilteredCampaignsSection(controller: controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          const _Avatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() {
              final name = controller.greetingName;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isEmpty ? 'Hey there 👋' : 'Hey $name 👋',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.heading,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Welcome back! Here's what's new.",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.subtext,
                    ),
                  ),
                ],
              );
            }),
          ),
          _NotificationBell(controller: controller),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 53,
      height: 53,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.65),
        color: const Color(0xFFEDE6F1),
      ),
      alignment: Alignment.center,
      child: const Icon(
        RemixIcons.user_3_fill,
        size: 24,
        color: AppColors.primary,
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.openNotifications,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A4B0070),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              RemixIcons.notification_3_line,
              size: 20,
              color: AppColors.heading,
            ),
            Obx(() {
              if (controller.unreadNotifications.value <= 0) {
                return const SizedBox.shrink();
              }
              return const Positioned(top: 8, right: 9, child: _Dot());
            }),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      width: 363,
      constraints: const BoxConstraints(minHeight: 177),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.white, width: 1),
        gradient: const LinearGradient(
          begin: Alignment(-0.22, -2.2),
          end: Alignment.bottomLeft,
          colors: [Colors.white, Colors.white, Color(0xFFEFD4FF)],
          stops: [0.0, 0.4, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 8,
            left: 244,
            child: Opacity(
              opacity: 0.37,
              child: SvgPicture.asset(
                AppImages.walletBackground,
                width: 119,
                height: 136,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 48,
            left: 273,
            child: SvgPicture.asset(
              AppImages.wallet,
              width: 70,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'AVAILABLE BALANCE',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: const Color(0xFF3F3F46),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: controller.toggleBalanceVisibility,
                      child: Obx(
                        () => Icon(
                          controller.isBalanceVisible.value
                              ? RemixIcons.eye_line
                              : RemixIcons.eye_off_line,
                          size: 18,
                          color: const Color(0xFF3F3F46),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Obx(() {
                  if (controller.isWalletLoading.value &&
                      controller.wallet.value == null) {
                    return const SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.accentDark,
                      ),
                    );
                  }
                  final label = controller.isBalanceVisible.value
                      ? controller.walletCardBalanceLabel
                      : '••••••';
                  return Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Color(0xFF4B0070),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x42E8F6ED),
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.6),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        child: const Icon(
                          RemixIcons.wallet_3_fill,
                          size: 13,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Withdrawable : '
                        '${controller.formattedWithdrawable ?? '****'}',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                          letterSpacing: 0,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: 110,
                  height: 31,
                  child: ElevatedButton(
                    onPressed: controller.withdraw,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4B0070),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Withdraw',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            letterSpacing: 0.65,
                            color: Color(0xFF4B0070),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Transform.rotate(
                          angle: 1.5708,
                          child: const Icon(
                            RemixIcons.logout_box_line,
                            size: 16,
                            color: Color(0xFF4B0070),
                          ),
                        ),
                      ],
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

class _SocialCard extends StatelessWidget {
  const _SocialCard({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.socialCardBg,
        border: Border.all(color: AppColors.socialCardBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connect Social Accounts',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.cardTitle,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Boost your reward tier by verifying channels.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.bodyGrey,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  for (final platform in controller.socialPlatforms)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Obx(
                        () => SocialBubble(
                          platform: platform,
                          status:
                              controller.socialConnections[platform.id] ??
                              SocialConnectionStatus.initial,
                          onTap: () =>
                              showSocialConnectionsSheet(context, controller),
                        ),
                      ),
                    ),
                ],
              ),
              Obx(() {
                final allConnected = controller.socialPlatforms.every(
                  (p) =>
                      controller.socialConnections[p.id]?.state ==
                      SocialConnectionState.connected,
                );
                return ElevatedButton(
                  onPressed: allConnected
                      ? null
                      : () => showSocialConnectionsSheet(context, controller),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.chipUnselectedBorder,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    allConnected ? 'All Connected' : 'Connect Now',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ],
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
    return Obx(() {
      final names = controller.allCategoryNames;
      final stillLoading =
          (controller.isHomeCategoriesLoading.value ||
              controller.isAppConfigLoading.value) &&
          names.isEmpty;

      if (stillLoading) {
        return const SizedBox(
          height: 44,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            ),
          ),
        );
      }

      if (names.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          itemCount: names.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Obx(() {
                final isSelected = controller.selectedCategory.value == null;
                return _CategoryChip(
                  label: 'Featured',
                  isSelected: isSelected,
                  onTap: () => controller.selectCategory(null),
                );
              });
            }

            final name = names[index - 1];
            return Obx(() {
              final isSelected = controller.selectedCategory.value == name;
              return _CategoryChip(
                label: name,
                isSelected: isSelected,
                onTap: () => controller.selectCategory(name),
              );
            });
          },
        ),
      );
    });
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        height: 32,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 12 : 24,
          vertical: isSelected ? 6 : 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFFF7B39), Color(0xFFFF3E1A)],
                )
              : null,
          color: isSelected ? null : Colors.white,
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFD6D6D6), width: 1),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.heading,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(
                RemixIcons.shining_2_fill,
                size: 12.375,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryFilteredCampaignsSection extends StatelessWidget {
  const _CategoryFilteredCampaignsSection({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isCampaignsLoading.value;
      final hasError = controller.campaignsError.value != null;
      final items = controller.campaigns;

      if (!isLoading && !hasError && items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Builder(
          builder: (context) {
            if (isLoading && items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  ),
                ),
              );
            }

            if (hasError && items.isEmpty) {
              return Center(
                child: TextButton(
                  onPressed: controller.loadCampaigns,
                  child: const Text("Couldn't load campaigns — tap to retry"),
                ),
              );
            }

            return Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  _CampaignListItem(
                    campaign: items[i],
                    onTap: () => controller.openCampaign(items[i]),
                  ),
                  if (i != items.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Divider(height: 1, color: Color(0xFFECECEC)),
                    ),
                ],
              ],
            );
          },
        ),
      );
    });
  }
}

class _CampaignListItem extends StatelessWidget {
  const _CampaignListItem({required this.campaign, required this.onTap});

  final CampaignEntity campaign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final logoUrl = resolveImageUrl(campaign.brandLogoUrl);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF4F4F4),
              ),
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              child: logoUrl == null
                  ? Text(
                      campaign.brandName.isNotEmpty
                          ? campaign.brandName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    )
                  : Image.network(
                      logoUrl,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) => Text(
                        campaign.brandName.isNotEmpty
                            ? campaign.brandName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    campaign.brandName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      color: Color(0xFF29252A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    campaign.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      color: Color(0xFF6F6875),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // image-box
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFBFBFB),
                border: Border.fromBorderSide(
                  BorderSide(color: Color(0xFFFFFFFF), width: 1.17),
                ),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.categoryHelperPng,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class PopularCampaignsSection extends StatelessWidget {
  const PopularCampaignsSection({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      RemixIcons.fire_fill,
                      size: 20,
                      color: Color(0xFFFF5722),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Popular Campaigns',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.cardTitle,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: controller.seeAllPopularCampaigns,
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 118,
            child: Obx(() {
              if (controller.isPopularCampaignsLoading.value &&
                  controller.popularCampaigns.isEmpty) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  ),
                );
              }

              if (controller.popularCampaignsError.value != null &&
                  controller.popularCampaigns.isEmpty) {
                return Center(
                  child: TextButton(
                    onPressed: controller.loadPopularCampaigns,
                    child: const Text("Couldn't load — tap to retry"),
                  ),
                );
              }

              if (controller.popularCampaigns.isEmpty) {
                return const SizedBox.shrink();
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 20),
                itemCount: controller.popularCampaigns.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final campaign = controller.popularCampaigns[index];
                  return _CampaignSquareItem(
                    campaign: campaign,
                    onTap: () => controller.openCampaign(campaign),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CampaignSquareItem extends StatelessWidget {
  const _CampaignSquareItem({required this.campaign, required this.onTap});

  final CampaignEntity campaign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final logoUrl = resolveImageUrl(campaign.brandLogoUrl);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 79,
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color(0xFFF4F4F4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: logoUrl == null
                  ? const Icon(
                      RemixIcons.store_2_line,
                      size: 28,
                      color: AppColors.heading,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        logoUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
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
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            RemixIcons.store_2_line,
                            size: 28,
                            color: AppColors.heading,
                          );
                        },
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              campaign.brandName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentlyViewedSection extends StatelessWidget {
  const _RecentlyViewedSection({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isMarketplaceRecentLoading.value;
      final hasError = controller.marketplaceRecentError.value != null;
      final items = controller.marketplaceRecentCampaigns;

      if (!isLoading && !hasError && items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  Icon(
                    RemixIcons.time_line,
                    size: 20,
                    color: AppColors.heading,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Recently Viewed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cardTitle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 92,
              child: Builder(
                builder: (context) {
                  if (isLoading && items.isEmpty) {
                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      ),
                    );
                  }

                  if (hasError && items.isEmpty) {
                    return Center(
                      child: TextButton(
                        onPressed: controller.loadMarketplaceRecent,
                        child: const Text(
                          "Couldn't load recent items — tap to retry",
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 20),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final recent = items[index];
                      return _CampaignCircleItem(
                        campaign: recent.campaign,
                        onTap: () => controller.openCampaign(recent.campaign),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
      final isLoading = controller.isFavouriteCampaignsLoading.value;
      final hasError = controller.favouriteCampaignsError.value != null;
      final items = controller.favouriteCampaigns;

      if (!isLoading && !hasError && items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  Icon(
                    RemixIcons.heart_line,
                    size: 20,
                    color: AppColors.heading,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Favourite Campaigns',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cardTitle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 92,
              child: Builder(
                builder: (context) {
                  if (!isLoading && !hasError && items.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  if (hasError && items.isEmpty) {
                    return Center(
                      child: TextButton(
                        onPressed: controller.loadFavouriteCampaigns,
                        child: const Text(
                          "Couldn't load favourites — tap to retry",
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 20),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final fav = items[index];
                      return _CampaignCircleItem(
                        campaign: fav.campaign,
                        onTap: () => controller.openCampaign(fav.campaign),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _CampaignCircleItem extends StatelessWidget {
  const _CampaignCircleItem({required this.campaign, required this.onTap});

  final CampaignEntity campaign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final logoUrl = resolveImageUrl(campaign.brandLogoUrl);
    final name = campaign.brandName;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brandLogoBg,
                border: Border.all(color: AppColors.chipUnselectedBorder),
              ),
              alignment: Alignment.center,
              child: logoUrl == null
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    )
                  : Image.network(
                      logoUrl,
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
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
                      errorBuilder: (context, error, stackTrace) => Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentlyRewardedSection extends StatelessWidget {
  const _RecentlyRewardedSection({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recently Rewarded',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.cardTitle,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Top posts from our member community',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.bodyGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: controller.viewAllRecentlyRewarded,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 190,
            child: Obx(() {
              if (controller.isRecentlyRewardedLoading.value &&
                  controller.recentlyRewarded.isEmpty) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  ),
                );
              }

              if (controller.recentlyRewardedError.value != null &&
                  controller.recentlyRewarded.isEmpty) {
                return Center(
                  child: TextButton(
                    onPressed: controller.loadRecentlyRewarded,
                    child: const Text(
                      'Couldn\'t load recent posts — tap to retry',
                    ),
                  ),
                );
              }

              final posts = controller.displayableRecentlyRewarded;

              if (posts.isEmpty) {
                return const SizedBox.shrink();
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 20),
                itemCount: posts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return _RewardedPostCard(
                    post: post,
                    onTap: () => controller.openRewardedPost(post),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _RewardedPostCard extends StatelessWidget {
  const _RewardedPostCard({required this.post, required this.onTap});

  final RewardedPostEntity post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = resolveImageUrl(post.brandLogoUrl);

    if (thumbnailUrl == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 148,
        height: 190,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFFF4F4F4),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFFF4F4F4),
                alignment: Alignment.center,
                child: const Icon(
                  RemixIcons.image_2_line,
                  size: 22,
                  color: AppColors.bodyGrey,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 64,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.11),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        post.brandName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.cardTitle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.9),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      RemixIcons.user_3_fill,
                      size: 13,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      post.platform,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
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
