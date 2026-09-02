// Store values that are used across the app.
class AppConstants {
  AppConstants._();

  // =========================
  // App
  // =========================

  static const String appName = 'Kamao';

  // =========================
  // API
  // =========================

  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 60);

  // =========================
  // Storage Keys
  // =========================

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  static const String userIdKey = 'user_id';
  static const String tenantIdKey = 'tenant_id';
  static const String sessionIdKey = 'session_id';
  static const String roleIdKey = 'role_id';

  // =========================
  // Pagination
  // =========================

  static const int defaultPageSize = 10;

  // =========================
  // Animation
  // =========================

  static const Duration animationDuration = Duration(milliseconds: 300);

  /// App
  static const String firstLaunchKey = 'first_launch';

  static const String lastActivityKey = 'last_activity';
}
