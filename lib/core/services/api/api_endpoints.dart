class ApiEndpoints {
  ApiEndpoints._();
  // ── Auth ──────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/me';
  static const String profileUser = '/creator/profile';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  // ── Tenant ──────────────────────────────────────────────────────────
  static const String tenants = "/auth/login-tenants";
  // ── Wallet ────────────────────────────────────────────────────────
  static const String wallet = "/creator/wallet";
  // ── Brands ──────────────────────────────────────────────────────────
  static const String brands = '/creator/brands';
  static const String brandsPopular = '/creator/brands/popular';
  static const String brandsFeatured = '/creator/brands/featured';
  static const String brandsRecent = '/creator/brands/recent';
  static const String brandsFavourites = '/creator/brands/favourites';
  static String brandDetail(String brandId) => '/creator/brands/$brandId';
  static String brandView(String brandId) => '/creator/brands/$brandId/view';
  static String brandFavourite(String brandId) =>
      '/creator/brands/$brandId/favourite';
  static String brandUnfavourite(String brandId) =>
      '/creator/brands/$brandId/unfavourite';
 
  static const String homePopularBrands = brandsPopular;
  static const String homeFeaturedBrands = brandsFeatured;
  // ── Campaigns ──────────────────────────────────────────────────────────
  static const String homePopularCampaigns = '/creator/home/popular-campaigns';
  static const String homeCategories = '/creator/home/categories';
  static const String appConfig = '/public/app-config';
  static const String homeRecentlyRewarded = '/creator/home/recently-rewarded';
  static const String homeCampaigns = '/creator/home/campaigns';
  static const String homeRecentCampaigns = '/creator/home/recent-campaigns';
  static const String homeFavouriteCampaigns =
      '/creator/home/favourite-campaigns';
  // ── Marketplace ──────────────────────────────────────────────────────────
  static const marketplaceRecent = '/creator/marketplace/recent';
  static String marketplaceJoin(String campaignId) =>
      '/creator/marketplace/$campaignId/join';
  static String marketplaceDetail(String campaignId) =>
      '/creator/marketplace/$campaignId';
  static String marketplaceFavourite(String campaignId) =>
      '/creator/marketplace/$campaignId/favourite';
  static String marketplaceView(String campaignId) =>
      '/creator/marketplace/$campaignId/view';
  static const String marketplaceFeatured = '/creator/marketplace/featured';
  static const String marketplaceList = '/creator/marketplace';
  static const String walletWithdrawals = '/creator/wallet/withdrawals';
  static const String walletPayoutMethod = '/creator/wallet/payout-method';
  // ── Submissions / posts ─────────────────────────────────────────────
  static const String submissionsForm = '/creator/submissions/form';
  static const String submissionsPending = '/creator/submissions/pending';
  static const String submissionsApproved = '/creator/submissions/approved';
  static const String socialMedia = '/creator/social/media';
  // ── Social connections (OAuth) ───────────────────────────────────────
  static const String socialConnections = '/creator/social/connections';
  static String socialStart(String platform) =>
      '/creator/social/$platform/start';
}
