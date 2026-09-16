// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kamao/src/brand/domain/usecase/get_popular_brands_usecase.dart';
// import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
// import 'package:kamao/src/home/domain/entities/campaign/favourite_campaign_entity.dart';
// import 'package:kamao/src/home/domain/entities/campaign/recent_campaign_entity.dart';
// import 'package:kamao/src/home/domain/entities/rewarded_post_entity.dart';
// import 'package:kamao/src/home/domain/usecase/campaign/get_campaigns_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/campaign/get_favourite_campaigns_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/campaign/get_popular_campaigns_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/get_recently_rewarded_usecase.dart';
// import 'package:kamao/core/core.dart';
// import 'package:kamao/src/auth/auth.dart';
// import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/marketplace/get_marketplace_recent_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/marketplace/join_campaign_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/marketplace/toggle_favourite_campaign_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/marketplace/view_campaign_usecase.dart';
// import 'package:kamao/src/home/presentation/utils/campaign_list/campaign_list_page.dart';
// import 'package:kamao/src/wallet/wallet.dart';
// import 'package:kamao/src/social_connections/domain/entities/social_platform.dart';
// import 'package:kamao/src/social_connections/domain/entities/social_connection_status.dart';
// import 'package:kamao/src/social_connections/data/repositories/social_connections_repository.dart';
// import 'package:kamao/src/social_connections/services/social_deep_link_service.dart';
// import 'package:kamao/src/social_connections/widgets/social_connections_sheet.dart'
//     show SocialConnectionsHost;
// import 'package:remixicon/remixicon.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../domain/entities/home_category_entity.dart';

// class HomeController extends GetxController implements SocialConnectionsHost {
//   HomeController(
//     this._getWalletUseCase,
//     this._getPopularCampaignsUseCase,
//     this._getHomeCategoriesUseCase,
//     this._getRecentlyRewardedUseCase,
//     this._socialConnectionsRepository,
//     this._getCampaignsUseCase,
//     // this._getRecentCampaignsUseCase,
//     this._getFavouriteCampaignsUseCase,
//     this._getMarketplaceRecentUseCase,
//     this._joinCampaignUseCase,
//     this._toggleFavouriteCampaignUseCase,
//     this._viewCampaignUseCase,
//   );

//   final GetWalletUseCase _getWalletUseCase;
//   final GetPopularCampaignsUseCase _getPopularCampaignsUseCase;
//   final _getHomeCategoriesUseCase;
//   final GetRecentlyRewardedUseCase _getRecentlyRewardedUseCase;
//   final SocialConnectionsRepository _socialConnectionsRepository;
//   final GetCampaignsUseCase _getCampaignsUseCase;
//   // final GetRecentCampaignsUseCase _getRecentCampaignsUseCase;
//   final GetFavouriteCampaignsUseCase _getFavouriteCampaignsUseCase;
//   final GetMarketplaceRecentUseCase _getMarketplaceRecentUseCase;
//   final JoinCampaignUseCase _joinCampaignUseCase;
//   final ToggleFavouriteCampaignUseCase _toggleFavouriteCampaignUseCase;
//   final ViewCampaignUseCase _viewCampaignUseCase;

//   // ---------------------------------------------------------------
//   // Recently rewarded — GET /creator/home/recently-rewarded
//   // ---------------------------------------------------------------
//   final RxList<RewardedPostEntity> recentlyRewarded =
//       <RewardedPostEntity>[].obs;
//   final RxBool isRecentlyRewardedLoading = false.obs;
//   final RxnString recentlyRewardedError = RxnString();

//   AuthController get _authController => Get.find<AuthController>();

//   // ---------------------------------------------------------------
//   // Wallet — backed by GET /creator/wallet
//   // ---------------------------------------------------------------
//   final Rxn<WalletEntity> wallet = Rxn<WalletEntity>();
//   final Rxn<WalletSummaryEntity> walletSummary = Rxn<WalletSummaryEntity>();
//   final RxString withdrawalHint = ''.obs;
//   final RxBool isWalletLoading = false.obs;
//   final RxnString walletError = RxnString();
//   final RxBool isBalanceVisible = true.obs;

//   final RxDouble weeklyGrowthPercent = 12.4.obs;
//   final RxInt unreadNotifications = 1.obs;

//   @override
//   final List<SocialPlatform> socialPlatforms = const [
//     SocialPlatform(
//       id: 'youtube',
//       name: 'YouTube',
//       icon: RemixIcons.youtube_fill,
//       iconColor: Colors.white,
//       backgroundColor: Color(0xFFE02020),
//       notConnectedLabel: 'Optional — public stats use the tenant API key',
//     ),
//     SocialPlatform(
//       id: 'facebook',
//       name: 'Facebook',
//       icon: RemixIcons.facebook_fill,
//       iconColor: Colors.white,
//       backgroundColor: Color(0xFF1877F2),
//     ),
//     SocialPlatform(
//       id: 'instagram',
//       name: 'Instagram',
//       icon: RemixIcons.instagram_fill,
//       iconColor: Colors.white,
//       backgroundGradient: [
//         Color(0xFFFED576),
//         Color(0xFFF47133),
//         Color(0xFFBC3081),
//         Color(0xFF4F5BD5),
//       ],
//     ),
//     SocialPlatform(
//       id: 'tiktok',
//       name: 'TikTok',
//       icon: RemixIcons.tiktok_fill,
//       iconColor: Colors.white,
//       backgroundColor: Color(0xFF010101),
//     ),
//   ];

//   @override
//   final RxMap<String, SocialConnectionStatus> socialConnections =
//       <String, SocialConnectionStatus>{
//         'youtube': SocialConnectionStatus.initial,
//         'facebook': SocialConnectionStatus.initial,
//         'instagram': SocialConnectionStatus.initial,
//         'tiktok': SocialConnectionStatus.initial,
//       }.obs;
//   final _deepLinkService = Get.find<SocialDeepLinkService>();
//   String? _pendingPlatformId;

//   @override
//   Future<void> connectPlatform(String platformId) async {
//     socialConnections[platformId] = const SocialConnectionStatus(
//       state: SocialConnectionState.connecting,
//     );
//     _pendingPlatformId = platformId;

//     try {
//       final authUrl = await _socialConnectionsRepository.startConnect(
//         platformId,
//       );
//       final launched = await launchUrl(
//         Uri.parse(authUrl),
//         mode: LaunchMode.externalApplication,
//       );
//       if (!launched) {
//         _pendingPlatformId = null;
//         socialConnections[platformId] = const SocialConnectionStatus(
//           state: SocialConnectionState.error,
//           errorMessage: "Couldn't open the browser",
//         );
//       }
//     } catch (e) {
//       _pendingPlatformId = null;
//       socialConnections[platformId] = SocialConnectionStatus(
//         state: SocialConnectionState.error,
//         errorMessage: '$e',
//       );
//     }
//   }

//   Future<void> _handleSocialDeepLink(Uri uri) async {
//     final platformId = uri.queryParameters['platform']?.toLowerCase();
//     if (platformId == null) return;

//     final ok = uri.queryParameters['ok'];
//     if (ok == '1') {
//       socialConnections[platformId] = const SocialConnectionStatus(
//         state: SocialConnectionState.connected,
//       );
//       Get.snackbar('Connected', '$platformId connected successfully');
//       loadSocialConnectionStatuses();
//     } else {
//       socialConnections[platformId] = SocialConnectionStatus(
//         state: SocialConnectionState.error,
//         errorMessage:
//             uri.queryParameters['message'] ??
//             uri.queryParameters['error'] ??
//             'Connection failed',
//       );
//     }
//   }

//   // ---------------------------------------------------------------
//   // Home categories — GET /creator/home/categories
//   // ---------------------------------------------------------------
//   final RxList<HomeCategoryEntity> homeCategories = <HomeCategoryEntity>[].obs;
//   final RxBool isHomeCategoriesLoading = false.obs;
//   final RxnString homeCategoriesError = RxnString();

//   // ---------------------------------------------------------------
//   // Campaigns — GET /creator/home/campaigns
//   // ---------------------------------------------------------------
//   final RxList<CampaignEntity> campaigns = <CampaignEntity>[].obs;
//   final RxBool isCampaignsLoading = false.obs;
//   final RxnString campaignsError = RxnString();

//   // ---------------------------------------------------------------
//   // Popular campaigns — GET /creator/home/popular-campaigns
//   // ---------------------------------------------------------------
//   final RxList<CampaignEntity> popularCampaigns = <CampaignEntity>[].obs;
//   final RxBool isPopularCampaignsLoading = false.obs;
//   final RxnString popularCampaignsError = RxnString();

//   // ---------------------------------------------------------------
//   // Recent campaigns — GET /creator/home/recent-campaigns
//   // ---------------------------------------------------------------
//   final RxList<RecentCampaignEntity> recentCampaigns =
//       <RecentCampaignEntity>[].obs;
//   final RxBool isRecentCampaignsLoading = false.obs;
//   final RxnString recentCampaignsError = RxnString();

//   // ---------------------------------------------------------------
//   // Favourite campaigns — GET /creator/home/favourite-campaigns
//   // ---------------------------------------------------------------
//   final RxList<FavouriteCampaignEntity> favouriteCampaigns =
//       <FavouriteCampaignEntity>[].obs;
//   final RxBool isFavouriteCampaignsLoading = false.obs;
//   final RxnString favouriteCampaignsError = RxnString();

//   /// IDs currently mid-toggle (PUT in flight). Used to disable/spin
//   /// the favourite button for that one campaign only, and to guard
//   /// against double-taps firing two overlapping requests.
//   final RxSet<String> togglingFavouriteIds = <String>{}.obs;

//   // ---------------------------------------------------------------
//   // Marketplace — recently viewed (GET /creator/marketplace/recent)
//   // and join (POST /creator/marketplace/{id}/join). Separate feed
//   // from the Home-tab "recent campaigns" above: this one is driven
//   // by marketplace views. View-tracking now happens in this
//   // controller (see _recordCampaignView, called from openCampaign),
//   // and the feed is re-fetched here (GET) whenever the user returns
//   // to Home or opens a new campaign.
//   // ---------------------------------------------------------------
//   final RxList<RecentCampaignEntity> marketplaceRecentCampaigns =
//       <RecentCampaignEntity>[].obs;
//   final RxBool isMarketplaceRecentLoading = false.obs;
//   final RxnString marketplaceRecentError = RxnString();
//   final RxnString joiningCampaignId = RxnString();

//   // ---------------------------------------------------------------
//   // Header (from AuthController.currentUser)
//   // ---------------------------------------------------------------

//   UserEntity? get currentUser => _authController.currentUser.value;

//   String get greetingName {
//     final user = currentUser;
//     if (user == null) return '';
//     final name = user.fullName.trim().isNotEmpty
//         ? user.fullName.trim()
//         : user.userName.trim();
//     if (name.isEmpty) return '';
//     return name.split(' ').first;
//   }

//   // ---------------------------------------------------------------
//   // Wallet helpers
//   // ---------------------------------------------------------------

//   String _currencySymbol(String currency) {
//     switch (currency.toUpperCase()) {
//       case 'NPR':
//         return 'Rs. ';
//       default:
//         return '$currency ';
//     }
//   }

//   String get formattedBalance {
//     final w = wallet.value;
//     if (w == null) return '—';
//     return '${_currencySymbol(w.currency)}${w.balance.toStringAsFixed(2)}';
//   }

//   Future<void> loadWallet() async {
//     isWalletLoading.value = true;
//     walletError.value = null;

//     final result = await _getWalletUseCase(const NoParams());

//     result.fold((failure) => walletError.value = failure.message, (summary) {
//       walletSummary.value = summary;
//       wallet.value = summary.primaryWallet;
//       withdrawalHint.value = summary.withdrawalHint;
//     });

//     isWalletLoading.value = false;
//   }

//   void toggleBalanceVisibility() {
//     isBalanceVisible.value = !isBalanceVisible.value;
//   }

//   /// Design wants the raw currency code ("NPR 12,450.00"), not the
//   /// "Rs." symbol substitution used by [formattedBalance] elsewhere.
//   String get walletCardBalanceLabel {
//     final w = wallet.value;
//     if (w == null) return '—';
//     return '${w.currency.toUpperCase()} ${w.balance.toStringAsFixed(2)}';
//   }

//   /// TODO(wallet-card): the API's withdrawalHint confirms a withdrawal
//   /// debits the wallet balance the moment it's *requested*, not once
//   /// processed — so `wallet.balance` already reflects anything
//   /// pending. There's no evidence in the current payload that a
//   /// "withdrawable" figure should ever differ from the balance shown
//   /// above it. Needs a product/backend decision (a hold period? a
//   /// minimum reserve?) before wiring this to real data. Returns null
//   /// until then, so the UI shows "****" instead of a fabricated
//   /// amount.
//   String? get formattedWithdrawable => null;

//   /// Withdrawal requests submitted but not yet marked Paid/Rejected.
//   /// Real data now that WalletSummaryEntity.withdrawals is typed —
//   /// useful for e.g. "1 withdrawal in progress" messaging, but NOT
//   /// wired into [formattedWithdrawable] (see that getter's comment).
//   List<WalletWithdrawalEntity> get pendingWithdrawals =>
//       walletSummary.value?.pendingWithdrawals ?? const [];

//   Future<void> loadSocialConnectionStatuses() async {
//     try {
//       final statuses = await _socialConnectionsRepository
//           .fetchAllConnectionStatuses();
//       socialConnections.addAll(statuses);
//       debugPrint('[SocialConnections] loaded: $statuses');
//     } catch (e) {
//       debugPrint('[SocialConnections] fetchAllConnectionStatuses FAILED: $e');
//     }
//   }

//   // ---------------------------------------------------------------
//   // Home categories
//   // ---------------------------------------------------------------

//   Future<void> loadHomeCategories() async {
//     isHomeCategoriesLoading.value = true;
//     homeCategoriesError.value = null;

//     final result = await _getHomeCategoriesUseCase(const NoParams());

//     result.fold(
//       (failure) => homeCategoriesError.value = failure.message,
//       (categories) => homeCategories.assignAll(categories),
//     );

//     isHomeCategoriesLoading.value = false;
//   }

//   // ---------------------------------------------------------------
//   // Campaigns (Home tab)
//   // ---------------------------------------------------------------

//   Future<void> loadCampaigns({int take = 12}) async {
//     isCampaignsLoading.value = true;
//     campaignsError.value = null;

//     final result = await _getCampaignsUseCase(TakeParams(take: take));

//     result.fold(
//       (failure) => campaignsError.value = failure.message,
//       (list) => campaigns.assignAll(list),
//     );

//     isCampaignsLoading.value = false;
//   }

//   // ---------------------------------------------------------------
//   // Popular campaigns
//   // ---------------------------------------------------------------

//   Future<void> loadPopularCampaigns({int take = 12}) async {
//     isPopularCampaignsLoading.value = true;
//     popularCampaignsError.value = null;

//     final result = await _getPopularCampaignsUseCase(TakeParams(take: take));

//     result.fold(
//       (failure) => popularCampaignsError.value = failure.message,
//       (list) => popularCampaigns.assignAll(list),
//     );

//     isPopularCampaignsLoading.value = false;
//   }

//   void seeAllPopularCampaigns() {
//     Get.to(
//       () => CampaignListPage(
//         title: 'Popular Campaigns',
//         fetcher: ({required page, required take, search}) =>
//             _getPopularCampaignsUseCase(TakeParams(take: take)),
//         onCampaignTap: openCampaign,
//       ),
//     );
//   }

//   void seeAllNewCampaigns() {
//     // Get.to(
//     //   () => CampaignListPage(
//     //     title: 'New Campaigns',
//     //     fetcher: ({required page, required take, search}) =>
//     //         getNewCampaignsUseCase(
//     //           CampaignQueryParams(page: page, take: take, search: search),
//     //         ),
//     //     onCampaignTap: openCampaign,
//     //   ),
//     // );
//   }
//   // Future<void> loadRecentCampaigns({int take = 12}) async {
//   //   isRecentCampaignsLoading.value = true;
//   //   recentCampaignsError.value = null;

//   //   final result = await _getRecentCampaignsUseCase(TakeParams(take: take));

//   //   result.fold(
//   //     (failure) => recentCampaignsError.value = failure.message,
//   //     (list) => recentCampaigns.assignAll(list),
//   //   );

//   //   isRecentCampaignsLoading.value = false;
//   // }

//   Future<void> loadFavouriteCampaigns({int take = 24}) async {
//     isFavouriteCampaignsLoading.value = true;
//     favouriteCampaignsError.value = null;

//     final result = await _getFavouriteCampaignsUseCase(TakeParams(take: take));

//     // result.fold(
//     //   (failure) => favouriteCampaignsError.value = failure.message,
//     //   (list) => favouriteCampaigns.assignAll(list),
//     // );

//     result.fold(
//       (failure) => favouriteCampaignsError.value = failure.message,
//       (list) => favouriteCampaigns.assignAll(list),
//     );
//     isFavouriteCampaignsLoading.value = false;
//   }

//   // ---------------------------------------------------------------
//   // Marketplace — recently viewed, join, favourite, view-tracking
//   // ---------------------------------------------------------------

//   Future<void> loadMarketplaceRecent({int take = 12}) async {
//     isMarketplaceRecentLoading.value = true;
//     marketplaceRecentError.value = null;

//     final result = await _getMarketplaceRecentUseCase(TakeParams(take: take));

//     result.fold(
//       (failure) => marketplaceRecentError.value = failure.message,
//       (list) => marketplaceRecentCampaigns.assignAll(list),
//     );

//     isMarketplaceRecentLoading.value = false;
//   }

//   /// Joins a campaign, then optimistically flips `alreadyJoined` to
//   /// true everywhere that campaign currently appears — campaigns,
//   /// popularCampaigns, recentCampaigns, favouriteCampaigns,
//   /// marketplaceRecentCampaigns — rather than refetching all five
//   /// lists.
//   // Future<bool> joinCampaign(String campaignId) async {
//   //   joiningCampaignId.value = campaignId;

//   //   final result = await _joinCampaignUseCase(JoinCampaignParams(campaignId));

//   //   final joined = result.fold((failure) {
//   //     Get.snackbar('Couldn\'t join', failure.message);
//   //     return false;
//   //   }, (success) => success);

//   //   if (joined) {
//   //     _markCampaignJoined(campaignId);
//   //   }

//   //   joiningCampaignId.value = null;
//   //   return joined;
//   // }

//   Future<bool> joinCampaign(String campaignId) async {
//     joiningCampaignId.value = campaignId;

//     final result = await _joinCampaignUseCase(JoinCampaignParams(campaignId));

//     final joined = result.fold((failure) {
//       Get.snackbar('Couldn\'t join', failure.message);
//       return false;
//     }, (success) => success);

//     if (joined) {
//       markCampaignJoinedExternally(campaignId);
//     }

//     joiningCampaignId.value = null;
//     return joined;
//   }

//   /// Public so CampaignDetailController can push a "joined" state
//   /// change into Home's lists immediately after joining from the
//   /// detail page, instead of Home staying stale until its next
//   /// full refresh.
//   void markCampaignJoinedExternally(String campaignId) {
//     campaigns.value = campaigns
//         .map((c) => c.id == campaignId ? c.copyWith(alreadyJoined: true) : c)
//         .toList();

//     popularCampaigns.value = popularCampaigns
//         .map((c) => c.id == campaignId ? c.copyWith(alreadyJoined: true) : c)
//         .toList();

//     recentCampaigns.value = recentCampaigns
//         .map(
//           (r) => r.campaign.id == campaignId
//               ? r.copyWith(campaign: r.campaign.copyWith(alreadyJoined: true))
//               : r,
//         )
//         .toList();

//     favouriteCampaigns.value = favouriteCampaigns
//         .map(
//           (f) => f.campaign.id == campaignId
//               ? f.copyWith(campaign: f.campaign.copyWith(alreadyJoined: true))
//               : f,
//         )
//         .toList();

//     marketplaceRecentCampaigns.value = marketplaceRecentCampaigns
//         .map(
//           (r) => r.campaign.id == campaignId
//               ? r.copyWith(campaign: r.campaign.copyWith(alreadyJoined: true))
//               : r,
//         )
//         .toList();
//   }

//   void _markCampaignJoined(String campaignId) {
//     campaigns.value = campaigns
//         .map((c) => c.id == campaignId ? c.copyWith(alreadyJoined: true) : c)
//         .toList();

//     popularCampaigns.value = popularCampaigns
//         .map((c) => c.id == campaignId ? c.copyWith(alreadyJoined: true) : c)
//         .toList();

//     recentCampaigns.value = recentCampaigns
//         .map(
//           (r) => r.campaign.id == campaignId
//               ? r.copyWith(campaign: r.campaign.copyWith(alreadyJoined: true))
//               : r,
//         )
//         .toList();

//     favouriteCampaigns.value = favouriteCampaigns
//         .map(
//           (f) => f.campaign.id == campaignId
//               ? f.copyWith(campaign: f.campaign.copyWith(alreadyJoined: true))
//               : f,
//         )
//         .toList();

//     marketplaceRecentCampaigns.value = marketplaceRecentCampaigns
//         .map(
//           (r) => r.campaign.id == campaignId
//               ? r.copyWith(campaign: r.campaign.copyWith(alreadyJoined: true))
//               : r,
//         )
//         .toList();
//   }

//   /// PUT /creator/marketplace/{id}/favourite — the API flips the
//   /// favourite state server-side and returns the *resulting* state
//   /// in `data`, so we mirror that value locally rather than blindly
//   /// inverting whatever we currently show (avoids drift if state was
//   /// changed elsewhere, e.g. another device).
//   // Future<void> toggleFavouriteCampaign(String campaignId) async {
//   //   if (togglingFavouriteIds.contains(campaignId)) return; // debounce
//   //   togglingFavouriteIds.add(campaignId);

//   //   final result = await _toggleFavouriteCampaignUseCase(
//   //     CampaignIdParams(campaignId),
//   //   );

//   //   result.fold(
//   //     (failure) => Get.snackbar("Couldn't update favourite", failure.message),
//   //     (isFavourite) => _applyFavouriteState(campaignId, isFavourite),
//   //   );

//   //   togglingFavouriteIds.remove(campaignId);
//   // }
//   Future<void> toggleFavouriteCampaign(String campaignId) async {
//     if (togglingFavouriteIds.contains(campaignId)) return;
//     togglingFavouriteIds.add(campaignId);

//     final result = await _toggleFavouriteCampaignUseCase(
//       CampaignIdParams(campaignId),
//     );

//     result.fold(
//       (failure) => Get.snackbar("Couldn't update favourite", failure.message),
//       (isFavourite) => applyFavouriteState(campaignId, isFavourite),
//     );

//     togglingFavouriteIds.remove(campaignId);
//   }

//   /// Public so other controllers (e.g. CampaignDetailController) can
//   /// push a favourite-state change into Home's lists immediately,
//   /// instead of Home staying stale until its next full refresh.
//   void applyFavouriteState(String campaignId, bool isFavourite) {
//     campaigns.value = campaigns
//         .map(
//           (c) => c.id == campaignId ? c.copyWith(isFavourite: isFavourite) : c,
//         )
//         .toList();

//     popularCampaigns.value = popularCampaigns
//         .map(
//           (c) => c.id == campaignId ? c.copyWith(isFavourite: isFavourite) : c,
//         )
//         .toList();

//     recentCampaigns.value = recentCampaigns
//         .map(
//           (r) => r.campaign.id == campaignId
//               ? r.copyWith(
//                   campaign: r.campaign.copyWith(isFavourite: isFavourite),
//                 )
//               : r,
//         )
//         .toList();

//     marketplaceRecentCampaigns.value = marketplaceRecentCampaigns
//         .map(
//           (r) => r.campaign.id == campaignId
//               ? r.copyWith(
//                   campaign: r.campaign.copyWith(isFavourite: isFavourite),
//                 )
//               : r,
//         )
//         .toList();

//     if (isFavourite) {
//       // We only have a CampaignEntity locally, not a full
//       // FavouriteCampaignEntity (which may carry extra fields like
//       // favouritedAt) — refetch that one list instead of fabricating it.
//       loadFavouriteCampaigns();
//     } else {
//       favouriteCampaigns.removeWhere((f) => f.campaign.id == campaignId);
//     }
//   }

//   void _applyFavouriteState(String campaignId, bool isFavourite) {
//     campaigns.value = campaigns
//         .map(
//           (c) => c.id == campaignId ? c.copyWith(isFavourite: isFavourite) : c,
//         )
//         .toList();

//     popularCampaigns.value = popularCampaigns
//         .map(
//           (c) => c.id == campaignId ? c.copyWith(isFavourite: isFavourite) : c,
//         )
//         .toList();

//     recentCampaigns.value = recentCampaigns
//         .map(
//           (r) => r.campaign.id == campaignId
//               ? r.copyWith(
//                   campaign: r.campaign.copyWith(isFavourite: isFavourite),
//                 )
//               : r,
//         )
//         .toList();

//     marketplaceRecentCampaigns.value = marketplaceRecentCampaigns
//         .map(
//           (r) => r.campaign.id == campaignId
//               ? r.copyWith(
//                   campaign: r.campaign.copyWith(isFavourite: isFavourite),
//                 )
//               : r,
//         )
//         .toList();

//     if (isFavourite) {
//       // We only have a CampaignEntity locally, not a full
//       // FavouriteCampaignEntity (which may carry extra fields like
//       // favouritedAt) — refetch that one list instead of fabricating it.
//       loadFavouriteCampaigns();
//     } else {
//       favouriteCampaigns.removeWhere((f) => f.campaign.id == campaignId);
//     }
//   }

//   /// Convenience for a favourites-tab "remove" button, where we
//   /// already know the campaign is currently favourited.
//   Future<void> unfavouriteCampaign(String campaignId) =>
//       toggleFavouriteCampaign(campaignId);

//   Future<void> refreshHome() async {
//     await Future.wait([
//       loadWallet(),
//       loadHomeCategories(),
//       loadRecentlyRewarded(),
//       loadCampaigns(),
//       loadPopularCampaigns(),
//       // loadRecentCampaigns(),
//       loadFavouriteCampaigns(),
//       loadMarketplaceRecent(),
//       _authController.getMe(),
//     ]);
//   }

//   void openNotifications() {
//     // TODO: Get.toNamed(AppRoutes.notifications);
//   }

//   void withdraw() {
//     Get.snackbar(
//       'Withdrawals',
//       'Withdrawal requests aren\'t available in the app yet. '
//           'Please contact support.',
//       duration: const Duration(seconds: 5),
//     );
//   }

//   /// Opens the campaign detail screen and, in the background, records
//   /// a marketplace "view" so it surfaces in Recently Viewed. Not
//   /// awaited — navigation must never wait on this.
//   void openCampaign(CampaignEntity campaign) {
//     // Get.toNamed(AppRoutes.campaignDetail, arguments: campaign.id);
//     // _recordCampaignView(campaign.id);
//   }

//   Future<void> _recordCampaignView(String campaignId) async {
//     final result = await _viewCampaignUseCase(CampaignIdParams(campaignId));

//     result.fold(
//       (failure) =>
//           debugPrint('[Marketplace] view record failed: ${failure.message}'),
//       (_) => loadMarketplaceRecent(),
//     );
//   }

//   void seeAllCampaigns() {
//     // TODO: Get.toNamed(AppRoutes.campaigns);
//   }

//   List<RewardedPostEntity> get displayableRecentlyRewarded =>
//       recentlyRewarded.where((p) => p.brandLogoImageUrl != null).toList();

//   Future<void> loadRecentlyRewarded({int take = 12}) async {
//     isRecentlyRewardedLoading.value = true;
//     recentlyRewardedError.value = null;

//     final result = await _getRecentlyRewardedUseCase(TakeParams(take: take));

//     result.fold(
//       (failure) => recentlyRewardedError.value = failure.message,
//       (posts) => recentlyRewarded.assignAll(posts),
//     );

//     isRecentlyRewardedLoading.value = false;
//   }

//   void openRewardedPost(RewardedPostEntity post) {
//     // TODO: open post.contentUrl (e.g. url_launcher) or a detail view.
//   }

//   void viewAllRecentlyRewarded() {
//     // TODO: Get.toNamed(AppRoutes.recentlyRewarded);
//   }

//   @override
//   void onInit() {
//     super.onInit();

//     final pendingLink = _deepLinkService.consumePendingLink();
//     if (pendingLink != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _handleSocialDeepLink(pendingLink);
//       });
//     }
//     _deepLinkService.listen(_handleSocialDeepLink);

//     if (_authController.isLoggedIn) {
//       loadWallet();
//       loadHomeCategories();
//       loadRecentlyRewarded();
//       loadSocialConnectionStatuses();
//       loadCampaigns();
//       loadPopularCampaigns();
//       // loadRecentCampaigns();
//       loadFavouriteCampaigns();
//       loadMarketplaceRecent();
//     }
//   }

//   @override
//   void onClose() {
//     // Do NOT call _deepLinkService.dispose() here — it's a permanent
//     // singleton owned by main.dart. Disposing it here would break the
//     // flow for any future HomeController (e.g. after logout → login
//     // again), since it can never be re-created.
//     super.onClose();
//   }
// }

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import 'package:kamao/src/brand/domain/usecase/get_featured_brands_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_popular_brands_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_recent_brands_usecase.dart';
import 'package:kamao/src/brand/presentation/utils/brand_list_page.dart';
import 'package:kamao/src/brand/presentation/widgets/brand_square_item.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/campaign/favourite_campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/campaign/recent_campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/rewarded_post_entity.dart';
import 'package:kamao/src/home/domain/usecase/campaign/get_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/campaign/get_favourite_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/campaign/get_popular_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/get_app_config_usecase.dart';
import 'package:kamao/src/home/domain/usecase/get_recently_rewarded_usecase.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_marketplace_recent_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/join_campaign_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/toggle_favourite_campaign_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/view_campaign_usecase.dart';
import 'package:kamao/src/home/presentation/utils/campaign_list/campaign_list_page.dart';
import 'package:kamao/src/home/presentation/utils/favourite_campaigns_list/favourite_campaigns_list_page.dart';
import 'package:kamao/src/home/presentation/utils/recently_rewarded_list/recently_rewarded_list_page.dart';
import 'package:kamao/src/wallet/wallet.dart';
import 'package:kamao/src/social_connections/presentation/controllers/social_connections_controller.dart';
import '../../domain/entities/home_category_entity.dart';

class HomeController extends GetxController {
  HomeController(
    this._getWalletUseCase,
    this._getPopularCampaignsUseCase,
    this._getHomeCategoriesUseCase,
    this._getRecentlyRewardedUseCase,
    this._getAppConfigUseCase,
    this._getCampaignsUseCase,
    // this._getRecentCampaignsUseCase,
    this._getFavouriteCampaignsUseCase,
    this._getMarketplaceRecentUseCase,
    this._joinCampaignUseCase,
    this._toggleFavouriteCampaignUseCase,
    this._viewCampaignUseCase,
    this._getPopularBrandsUseCase,
    this._getFeaturedBrandsUseCase,
    this._getRecentBrandsUseCase,
  );

  final GetWalletUseCase _getWalletUseCase;
  final GetPopularCampaignsUseCase _getPopularCampaignsUseCase;
  final _getHomeCategoriesUseCase;
  final GetRecentlyRewardedUseCase _getRecentlyRewardedUseCase;
  final GetAppConfigUseCase _getAppConfigUseCase;
  final GetCampaignsUseCase _getCampaignsUseCase;
  // final GetRecentCampaignsUseCase _getRecentCampaignsUseCase;
  final GetFavouriteCampaignsUseCase _getFavouriteCampaignsUseCase;
  final GetMarketplaceRecentUseCase _getMarketplaceRecentUseCase;
  final JoinCampaignUseCase _joinCampaignUseCase;
  final ToggleFavouriteCampaignUseCase _toggleFavouriteCampaignUseCase;
  final ViewCampaignUseCase _viewCampaignUseCase;
  final GetPopularBrandsUseCase _getPopularBrandsUseCase;
  final GetFeaturedBrandsUseCase _getFeaturedBrandsUseCase;
  final GetRecentBrandsUseCase _getRecentBrandsUseCase;

  // ---------------------------------------------------------------
  // Recently rewarded — GET /creator/home/recently-rewarded
  // ---------------------------------------------------------------
  final RxList<RewardedPostEntity> recentlyRewarded =
      <RewardedPostEntity>[].obs;
  final RxBool isRecentlyRewardedLoading = false.obs;
  final RxnString recentlyRewardedError = RxnString();

  AuthController get _authController => Get.find<AuthController>();

  // ---------------------------------------------------------------
  // Wallet — backed by GET /creator/wallet
  // ---------------------------------------------------------------
  final Rxn<WalletEntity> wallet = Rxn<WalletEntity>();
  final Rxn<WalletSummaryEntity> walletSummary = Rxn<WalletSummaryEntity>();
  final RxString withdrawalHint = ''.obs;
  final RxBool isWalletLoading = false.obs;
  final RxnString walletError = RxnString();
  final RxBool isBalanceVisible = true.obs;

  final RxDouble weeklyGrowthPercent = 12.4.obs;
  final RxInt unreadNotifications = 1.obs;

  // ---------------------------------------------------------------
  // Brands — popular / featured / recent APIs
  // ---------------------------------------------------------------
  final RxList<BrandEntity> popularBrands = <BrandEntity>[].obs;
  final RxBool isPopularBrandsLoading = false.obs;
  final RxnString popularBrandsError = RxnString();

  final RxList<BrandEntity> featuredBrands = <BrandEntity>[].obs;
  final RxBool isFeaturedBrandsLoading = false.obs;
  final RxnString featuredBrandsError = RxnString();

  final RxList<BrandEntity> recentBrands = <BrandEntity>[].obs;
  final RxBool isRecentBrandsLoading = false.obs;
  final RxnString recentBrandsError = RxnString();

  /// In-page home search — filters brands / favourites / rewarded on Home.
  final RxString searchQuery = ''.obs;

  final RxList<String> brandCategories = <String>[].obs;
  final RxBool isAppConfigLoading = false.obs;
  final RxnString appConfigError = RxnString();

  bool get needsSocialConnect =>
      Get.isRegistered<SocialConnectionsController>() &&
      Get.find<SocialConnectionsController>().needsSocialConnect.value;

  void openSocialConnections(BuildContext context) {
    if (!Get.isRegistered<SocialConnectionsController>()) return;
    Get.find<SocialConnectionsController>().openSheet(context);
  }

  // ---------------------------------------------------------------
  // Home categories — GET /creator/home/categories
  // ---------------------------------------------------------------
  final RxList<HomeCategoryEntity> homeCategories = <HomeCategoryEntity>[].obs;
  final RxBool isHomeCategoriesLoading = false.obs;
  final RxnString homeCategoriesError = RxnString();

  /// Currently selected category chip. `null` == "Featured" (no filter).
  final RxnString selectedCategory = RxnString();

  // ---------------------------------------------------------------
  // Campaigns (Home tab) — GET /creator/home/campaigns
  // This is the list the category chips filter.
  // ---------------------------------------------------------------
  final RxList<CampaignEntity> campaigns = <CampaignEntity>[].obs;
  final RxBool isCampaignsLoading = false.obs;
  final RxnString campaignsError = RxnString();

  // ---------------------------------------------------------------
  // Popular campaigns — GET /creator/home/popular-campaigns
  // ---------------------------------------------------------------
  final RxList<CampaignEntity> popularCampaigns = <CampaignEntity>[].obs;
  final RxBool isPopularCampaignsLoading = false.obs;
  final RxnString popularCampaignsError = RxnString();

  // ---------------------------------------------------------------
  // Recent campaigns — GET /creator/home/recent-campaigns
  // ---------------------------------------------------------------
  final RxList<RecentCampaignEntity> recentCampaigns =
      <RecentCampaignEntity>[].obs;
  final RxBool isRecentCampaignsLoading = false.obs;
  final RxnString recentCampaignsError = RxnString();

  // ---------------------------------------------------------------
  // Favourite campaigns — GET /creator/home/favourite-campaigns
  // ---------------------------------------------------------------
  final RxList<FavouriteCampaignEntity> favouriteCampaigns =
      <FavouriteCampaignEntity>[].obs;
  final RxBool isFavouriteCampaignsLoading = false.obs;
  final RxnString favouriteCampaignsError = RxnString();

  /// IDs currently mid-toggle (PUT in flight). Used to disable/spin
  /// the favourite button for that one campaign only, and to guard
  /// against double-taps firing two overlapping requests.
  final RxSet<String> togglingFavouriteIds = <String>{}.obs;

  // ---------------------------------------------------------------
  // Marketplace — recently viewed (GET /creator/marketplace/recent)
  // and join (POST /creator/marketplace/{id}/join). Separate feed
  // from the Home-tab "recent campaigns" above: this one is driven
  // by marketplace views. View-tracking now happens in this
  // controller (see _recordCampaignView, called from openCampaign),
  // and the feed is re-fetched here (GET) whenever the user returns
  // to Home or opens a new campaign.
  // ---------------------------------------------------------------
  final RxList<RecentCampaignEntity> marketplaceRecentCampaigns =
      <RecentCampaignEntity>[].obs;
  final RxBool isMarketplaceRecentLoading = false.obs;
  final RxnString marketplaceRecentError = RxnString();
  final RxnString joiningCampaignId = RxnString();

  // ---------------------------------------------------------------
  // Header (from AuthController.currentUser)
  // ---------------------------------------------------------------

  UserEntity? get currentUser => _authController.currentUser.value;

  String get greetingName {
    final user = currentUser;
    if (user == null) return '';
    final name = user.fullName.trim().isNotEmpty
        ? user.fullName.trim()
        : user.userName.trim();
    if (name.isEmpty) return '';
    return name.split(' ').first;
  }

  String get timeOfDayGreeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  // ---------------------------------------------------------------
  // Wallet helpers
  // ---------------------------------------------------------------

  String _currencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'NPR':
        return 'रू ';
      default:
        return '$currency ';
    }
  }

  String get formattedBalance {
    final w = wallet.value;
    if (w == null) return '—';
    return '${_currencySymbol(w.currency)}${_formatAmount(w.balance)}';
  }

  /// Compact chip label (no decimals), e.g. "रू 21,500".
  String get balanceChipLabel {
    final w = wallet.value;
    if (w == null) return '—';
    return '${_currencySymbol(w.currency).trim()} ${_formatAmount(w.balance, decimals: 0)}';
  }

  String get walletCardBalanceLabel {
    final w = wallet.value;
    if (w == null) return '—';
    return '${_currencySymbol(w.currency)}${_formatAmount(w.balance)}';
  }

  /// Weekly growth amount for the wallet badge.
  /// TODO: replace with API-backed weekly earnings when available.
  final RxDouble weeklyGrowthAmount = 1850.0.obs;

  /// Weekly growth amount for the wallet badge.
  String get weeklyGrowthAmountLabel {
    return '+रू ${_formatAmount(weeklyGrowthAmount.value, decimals: 0)}';
  }

  String _formatAmount(num value, {int decimals = 2}) {
    final pattern = decimals == 0 ? '#,##0' : '#,##0.${'0' * decimals}';
    return NumberFormat(pattern).format(value);
  }

  /// Brands recently viewed — GET /creator/brands/recent.
  Future<void> loadRecentBrands({int take = 12}) async {
    isRecentBrandsLoading.value = true;
    recentBrandsError.value = null;
    final result = await _getRecentBrandsUseCase(TakeParams(take: take));
    result.fold(
      (failure) => recentBrandsError.value = failure.message,
      (list) => recentBrands.assignAll(list),
    );
    isRecentBrandsLoading.value = false;
  }

  Future<void> loadPopularBrands({int take = 12}) async {
    isPopularBrandsLoading.value = true;
    popularBrandsError.value = null;
    final result = await _getPopularBrandsUseCase(TakeParams(take: take));
    result.fold(
      (failure) => popularBrandsError.value = failure.message,
      (list) => popularBrands.assignAll(list),
    );
    isPopularBrandsLoading.value = false;
  }

  Future<void> loadFeaturedBrands({int take = 12}) async {
    isFeaturedBrandsLoading.value = true;
    featuredBrandsError.value = null;
    final result = await _getFeaturedBrandsUseCase(TakeParams(take: take));
    result.fold(
      (failure) => featuredBrandsError.value = failure.message,
      (list) => featuredBrands.assignAll(list),
    );
    isFeaturedBrandsLoading.value = false;
  }

  Future<void> loadAllBrandRails() async {
    await Future.wait([
      loadPopularBrands(),
      loadFeaturedBrands(),
      loadRecentBrands(),
    ]);
  }

  void openWallet() {
    Get.toNamed(AppRoutes.wallet);
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  bool get isSearching => searchQuery.value.trim().isNotEmpty;

  bool get hasActiveHomeFilter =>
      isSearching || selectedCategory.value != null;

  List<BrandEntity> get filteredPopularBrands =>
      _filterBrands(popularBrands);

  List<BrandEntity> get filteredRecentBrands => _filterBrands(recentBrands);

  List<BrandEntity> get filteredFeaturedBrands =>
      _filterBrands(featuredBrands);

  List<FavouriteCampaignEntity> get filteredFavouriteCampaigns =>
      _filterFavouriteCampaigns(favouriteCampaigns);

  List<RewardedPostEntity> get filteredRecentlyRewarded {
    final base = displayableRecentlyRewarded;
    final q = searchQuery.value.trim().toLowerCase();
    final category = selectedCategory.value?.trim().toLowerCase();

    // Rewarded posts have no category field — hide under category filter.
    if (category != null && category.isNotEmpty) return const [];

    if (q.isEmpty) return base;
    return base
        .where(
          (p) =>
              p.brandName.toLowerCase().contains(q) ||
              p.campaignName.toLowerCase().contains(q) ||
              (p.caption ?? '').toLowerCase().contains(q),
        )
        .toList();
  }

  bool get hasFilteredHomeResults =>
      filteredPopularBrands.isNotEmpty ||
      filteredRecentBrands.isNotEmpty ||
      filteredFeaturedBrands.isNotEmpty ||
      filteredFavouriteCampaigns.isNotEmpty ||
      filteredRecentlyRewarded.isNotEmpty;

  List<BrandEntity> _filterBrands(List<BrandEntity> source) {
    final q = searchQuery.value.trim().toLowerCase();
    final category = selectedCategory.value?.trim().toLowerCase();

    return source.where((b) {
      if (category != null && category.isNotEmpty) {
        final brandCategory = (b.categoryName ?? '').trim().toLowerCase();
        if (brandCategory != category) return false;
      }
      if (q.isEmpty) return true;
      return b.name.toLowerCase().contains(q) ||
          (b.categoryName ?? '').toLowerCase().contains(q) ||
          (b.bio ?? '').toLowerCase().contains(q);
    }).toList();
  }

  List<FavouriteCampaignEntity> _filterFavouriteCampaigns(
    List<FavouriteCampaignEntity> source,
  ) {
    final q = searchQuery.value.trim().toLowerCase();
    final category = selectedCategory.value?.trim().toLowerCase();

    return source.where((item) {
      final c = item.campaign;
      if (category != null && category.isNotEmpty) {
        final campaignCategory = (c.brandCategory ?? '').trim().toLowerCase();
        if (campaignCategory != category) return false;
      }
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) ||
          c.brandName.toLowerCase().contains(q) ||
          c.objective.toLowerCase().contains(q) ||
          (c.brandCategory ?? '').toLowerCase().contains(q);
    }).toList();
  }

  void openBrand(BrandEntity brand) => openBrandDetail(brand.id);

  void seeAllPopularBrands() {
    _openBrandList(
      title: 'Popular Brands',
      fetcher: ({required int take}) =>
          _getPopularBrandsUseCase(TakeParams(take: take)),
    );
  }

  void seeAllRecentBrands() {
    _openBrandList(
      title: 'Recent Brands',
      fetcher: ({required int take}) =>
          _getRecentBrandsUseCase(TakeParams(take: take)),
    );
  }

  void seeAllFeaturedBrands() {
    _openBrandList(
      title: 'Featured Brands',
      fetcher: ({required int take}) =>
          _getFeaturedBrandsUseCase(TakeParams(take: take)),
    );
  }

  void seeAllFavouriteCampaigns() {
    Get.to(
      () => FavouriteCampaignsListPage(
        fetcher: ({required int take}) =>
            _getFavouriteCampaignsUseCase(TakeParams(take: take)),
        onCampaignTap: openCampaign,
      ),
    );
  }

  void _openBrandList({
    required String title,
    required BrandListFetcher fetcher,
  }) {
    Get.to(
      () => BrandListPage(
        title: title,
        fetcher: fetcher,
        onBrandTap: openBrand,
      ),
    );
  }

  Future<void> loadWallet() async {
    isWalletLoading.value = true;
    walletError.value = null;

    final result = await _getWalletUseCase(const NoParams());

    result.fold((failure) => walletError.value = failure.message, (summary) {
      walletSummary.value = summary;
      wallet.value = summary.primaryWallet;
      withdrawalHint.value = summary.withdrawalHint;
    });

    isWalletLoading.value = false;
  }

  void toggleBalanceVisibility() {
    isBalanceVisible.value = !isBalanceVisible.value;
  }

  /// TODO(wallet-card): the API's withdrawalHint confirms a withdrawal
  /// debits the wallet balance the moment it's *requested*, not once
  /// processed — so `wallet.balance` already reflects anything
  /// pending. There's no evidence in the current payload that a
  /// "withdrawable" figure should ever differ from the balance shown
  /// above it. Needs a product/backend decision (a hold period? a
  /// minimum reserve?) before wiring this to real data. Returns null
  /// until then, so the UI shows "****" instead of a fabricated
  /// amount.
  String? get formattedWithdrawable => null;

  /// Withdrawal requests submitted but not yet marked Paid/Rejected.
  /// Real data now that WalletSummaryEntity.withdrawals is typed —
  /// useful for e.g. "1 withdrawal in progress" messaging, but NOT
  /// wired into [formattedWithdrawable] (see that getter's comment).
  List<WalletWithdrawalEntity> get pendingWithdrawals =>
      walletSummary.value?.pendingWithdrawals ?? const [];

  // ---------------------------------------------------------------
  // Home categories
  // ---------------------------------------------------------------

  Future<void> loadHomeCategories() async {
    isHomeCategoriesLoading.value = true;
    homeCategoriesError.value = null;

    final result = await _getHomeCategoriesUseCase(const NoParams());

    result.fold(
      (failure) => homeCategoriesError.value = failure.message,
      (categories) => homeCategories.assignAll(categories),
    );

    isHomeCategoriesLoading.value = false;
  }

  List<String> get allCategoryNames {
    final seen = <String>{};
    final names = <String>[];
    for (final name in [
      ...homeCategories.map((c) => c.name.trim()),
      ...brandCategories.map((c) => c.trim()),
    ]) {
      if (name.isEmpty) continue;
      final key = name.toLowerCase();
      if (seen.add(key)) names.add(name);
    }
    return names;
  }

  /// Exclusive chip selection on Home — one active, rest unselected.
  /// Tap the active category again (or All) to clear.
  void selectCategory(String? categoryName) {
    final next = categoryName?.trim();
    if (next == null || next.isEmpty) {
      selectedCategory.value = null;
      return;
    }
    final current = selectedCategory.value?.trim();
    if (current != null &&
        current.toLowerCase() == next.toLowerCase()) {
      selectedCategory.value = null;
      return;
    }
    selectedCategory.value = next;
  }

  // ---------------------------------------------------------------
  // Campaigns (Home tab) — filtered by selectedCategory
  // ---------------------------------------------------------------

  Future<void> loadCampaigns({int take = 12}) async {
    isCampaignsLoading.value = true;
    campaignsError.value = null;

    final result = await _getCampaignsUseCase(
      CampaignFilterParams(take: take, category: selectedCategory.value),
    );

    result.fold(
      (failure) => campaignsError.value = failure.message,
      (list) => campaigns.assignAll(list),
    );

    isCampaignsLoading.value = false;
  }

  // ---------------------------------------------------------------
  // Popular campaigns
  // ---------------------------------------------------------------

  Future<void> loadPopularCampaigns({int take = 12}) async {
    isPopularCampaignsLoading.value = true;
    popularCampaignsError.value = null;

    final result = await _getPopularCampaignsUseCase(TakeParams(take: take));

    result.fold(
      (failure) => popularCampaignsError.value = failure.message,
      (list) => popularCampaigns.assignAll(list),
    );

    isPopularCampaignsLoading.value = false;
  }

  Future<void> loadAppConfig() async {
    isAppConfigLoading.value = true;
    appConfigError.value = null;

    final result = await _getAppConfigUseCase(const NoParams());

    result.fold(
      (failure) => appConfigError.value = failure.message,
      (config) => brandCategories.assignAll(config.brandCategories),
    );

    isAppConfigLoading.value = false;
  }

  // void seeAllPopularCampaigns() {
  //   Get.to(
  //     () => CampaignListPage(
  //       title: 'Popular Campaigns',
  //       fetcher: ({required page, required take, search}) =>
  //           _getPopularCampaignsUseCase(TakeParams(take: take)),
  //       onCampaignTap: openCampaign,
  //     ),
  //   );
  // }
  void seeAllPopularCampaigns() {
    Get.to(
      () => CampaignListPage<CampaignEntity>(
        title: 'Popular Campaigns',
        idOf: (c) => c.id,
        nameOf: (c) => c.brandName,
        logoUrlOf: (c) => resolveImageUrl(c.brandLogoUrl),
        enableSearch: true, // TakeParams has no search param
        fetcher: ({required int page, required int take, String? search}) {
          if (page > 1) {
            return Future.value(const Right<Failure, List<CampaignEntity>>([]));
          }
          return _getPopularCampaignsUseCase(TakeParams(take: take));
        },
        onCampaignTap: openCampaign,
      ),
    );
  }

  // Future<void> loadRecentCampaigns({int take = 12}) async {
  //   isRecentCampaignsLoading.value = true;
  //   recentCampaignsError.value = null;

  //   final result = await _getRecentCampaignsUseCase(TakeParams(take: take));

  //   result.fold(
  //     (failure) => recentCampaignsError.value = failure.message,
  //     (list) => recentCampaigns.assignAll(list),
  //   );

  //   isRecentCampaignsLoading.value = false;
  // }

  Future<void> loadFavouriteCampaigns({int take = 24}) async {
    isFavouriteCampaignsLoading.value = true;
    favouriteCampaignsError.value = null;

    final result = await _getFavouriteCampaignsUseCase(TakeParams(take: take));

    result.fold(
      (failure) => favouriteCampaignsError.value = failure.message,
      (list) => favouriteCampaigns.assignAll(list),
    );
    isFavouriteCampaignsLoading.value = false;
  }

  // ---------------------------------------------------------------
  // Marketplace — recently viewed, join, favourite, view-tracking
  // ---------------------------------------------------------------

  Future<void> loadMarketplaceRecent({int take = 12}) async {
    isMarketplaceRecentLoading.value = true;
    marketplaceRecentError.value = null;

    final result = await _getMarketplaceRecentUseCase(TakeParams(take: take));

    result.fold(
      (failure) => marketplaceRecentError.value = failure.message,
      (list) => marketplaceRecentCampaigns.assignAll(list),
    );

    isMarketplaceRecentLoading.value = false;
  }

  Future<bool> joinCampaign(String campaignId) async {
    joiningCampaignId.value = campaignId;

    final result = await _joinCampaignUseCase(JoinCampaignParams(campaignId));

    final joined = result.fold((failure) {
      Get.snackbar('Couldn\'t join', failure.message);
      return false;
    }, (success) => success);

    if (joined) {
      markCampaignJoinedExternally(campaignId);
    }

    joiningCampaignId.value = null;
    return joined;
  }

  /// Public so CampaignDetailController can push a "joined" state
  /// change into Home's lists immediately after joining from the
  /// detail page, instead of Home staying stale until its next
  /// full refresh.
  void markCampaignJoinedExternally(String campaignId) {
    campaigns.value = campaigns
        .map((c) => c.id == campaignId ? c.copyWith(alreadyJoined: true) : c)
        .toList();

    popularCampaigns.value = popularCampaigns
        .map((c) => c.id == campaignId ? c.copyWith(alreadyJoined: true) : c)
        .toList();

    recentCampaigns.value = recentCampaigns
        .map(
          (r) => r.campaign.id == campaignId
              ? r.copyWith(campaign: r.campaign.copyWith(alreadyJoined: true))
              : r,
        )
        .toList();

    favouriteCampaigns.value = favouriteCampaigns
        .map(
          (f) => f.campaign.id == campaignId
              ? f.copyWith(campaign: f.campaign.copyWith(alreadyJoined: true))
              : f,
        )
        .toList();

    marketplaceRecentCampaigns.value = marketplaceRecentCampaigns
        .map(
          (r) => r.campaign.id == campaignId
              ? r.copyWith(campaign: r.campaign.copyWith(alreadyJoined: true))
              : r,
        )
        .toList();
  }

  /// PUT /creator/marketplace/{id}/favourite — the API flips the
  /// favourite state server-side and returns the *resulting* state
  /// in `data`, so we mirror that value locally rather than blindly
  /// inverting whatever we currently show (avoids drift if state was
  /// changed elsewhere, e.g. another device).
  Future<void> toggleFavouriteCampaign(String campaignId) async {
    if (togglingFavouriteIds.contains(campaignId)) return;
    togglingFavouriteIds.add(campaignId);

    final result = await _toggleFavouriteCampaignUseCase(
      CampaignIdParams(campaignId),
    );

    result.fold(
      (failure) => Get.snackbar("Couldn't update favourite", failure.message),
      (isFavourite) => applyFavouriteState(campaignId, isFavourite),
    );

    togglingFavouriteIds.remove(campaignId);
  }

  /// Public so other controllers (e.g. CampaignDetailController) can
  /// push a favourite-state change into Home's lists immediately,
  /// instead of Home staying stale until its next full refresh.
  void applyFavouriteState(String campaignId, bool isFavourite) {
    campaigns.value = campaigns
        .map(
          (c) => c.id == campaignId ? c.copyWith(isFavourite: isFavourite) : c,
        )
        .toList();

    popularCampaigns.value = popularCampaigns
        .map(
          (c) => c.id == campaignId ? c.copyWith(isFavourite: isFavourite) : c,
        )
        .toList();

    recentCampaigns.value = recentCampaigns
        .map(
          (r) => r.campaign.id == campaignId
              ? r.copyWith(
                  campaign: r.campaign.copyWith(isFavourite: isFavourite),
                )
              : r,
        )
        .toList();

    marketplaceRecentCampaigns.value = marketplaceRecentCampaigns
        .map(
          (r) => r.campaign.id == campaignId
              ? r.copyWith(
                  campaign: r.campaign.copyWith(isFavourite: isFavourite),
                )
              : r,
        )
        .toList();

    if (isFavourite) {
      // We only have a CampaignEntity locally, not a full
      // FavouriteCampaignEntity (which may carry extra fields like
      // favouritedAt) — refetch that one list instead of fabricating it.
      loadFavouriteCampaigns();
    } else {
      favouriteCampaigns.removeWhere((f) => f.campaign.id == campaignId);
    }
  }

  /// Convenience for a favourites-tab "remove" button, where we
  /// already know the campaign is currently favourited.
  Future<void> unfavouriteCampaign(String campaignId) =>
      toggleFavouriteCampaign(campaignId);

  Future<void> refreshHome() async {
    await Future.wait([
      loadWallet(),
      loadHomeCategories(),
      loadRecentlyRewarded(),
      loadAppConfig(),
      loadCampaigns(),
      loadPopularCampaigns(),
      loadFavouriteCampaigns(),
      loadMarketplaceRecent(),
      loadAllBrandRails(),
      _authController.getMe(),
      if (Get.isRegistered<SocialConnectionsController>())
        Get.find<SocialConnectionsController>().loadConnectionStatuses(),
    ]);
  }

  void openNotifications() {
    // TODO: Get.toNamed(AppRoutes.notifications);
  }

  void withdraw() {
    Get.toNamed(AppRoutes.withdraw);
  }

  /// Opens the campaign detail screen and, in the background, records
  /// a marketplace "view" so it surfaces in Recently Viewed. Not
  /// awaited — navigation must never wait on this.
  void openCampaign(CampaignEntity campaign) {
    Get.toNamed(AppRoutes.campaignDetail, arguments: campaign.id);
    _recordCampaignView(campaign.id);
  }

  Future<void> _recordCampaignView(String campaignId) async {
    final result = await _viewCampaignUseCase(CampaignIdParams(campaignId));

    result.fold(
      (failure) =>
          debugPrint('[Marketplace] view record failed: ${failure.message}'),
      (_) => loadMarketplaceRecent(),
    );
  }

  void seeAllCampaigns() {
    // TODO: Get.toNamed(AppRoutes.campaigns);
  }

  List<RewardedPostEntity> get displayableRecentlyRewarded =>
      recentlyRewarded.where((p) => p.brandLogoImageUrl != null).toList();

  Future<void> loadRecentlyRewarded({int take = 12}) async {
    isRecentlyRewardedLoading.value = true;
    recentlyRewardedError.value = null;

    final result = await _getRecentlyRewardedUseCase(TakeParams(take: take));

    result.fold(
      (failure) => recentlyRewardedError.value = failure.message,
      (posts) => recentlyRewarded.assignAll(posts),
    );

    isRecentlyRewardedLoading.value = false;
  }

  void openRewardedPost(RewardedPostEntity post) {
    Get.toNamed(AppRoutes.campaignDetail, arguments: post.campaignId);
  }

  void viewAllRecentlyRewarded() {
    Get.to(
      () => RecentlyRewardedListPage(
        fetcher: ({required int take}) =>
            _getRecentlyRewardedUseCase(TakeParams(take: take)),
        onPostTap: openRewardedPost,
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadAppConfig();

    if (_authController.isLoggedIn) {
      loadWallet();
      loadHomeCategories();
      loadRecentlyRewarded();
      if (Get.isRegistered<SocialConnectionsController>()) {
        Get.find<SocialConnectionsController>().loadConnectionStatuses();
      }
      loadCampaigns();
      loadPopularCampaigns();
      loadFavouriteCampaigns();
      loadMarketplaceRecent();
      loadAllBrandRails();
    }
  }
}
