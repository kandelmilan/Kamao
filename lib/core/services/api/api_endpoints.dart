class ApiEndpoints {
  ApiEndpoints._();
  // ── Auth ──────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/me';
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
  static const String homeCategories = '/creator/home/categories';
  static const String homeRecentlyRewarded = '/creator/home/recently-rewarded';
}
