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
  // ── Home ──────────────────────────────────────────────────────────
  static const String homePopularBrands = '/creator/home/popular-brands';
  static const String homeFeaturedBrands = '/creator/home/featured-brands';
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
}
