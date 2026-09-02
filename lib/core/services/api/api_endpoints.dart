class ApiEndpoints {
  ApiEndpoints._();
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/me';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String tenants = "/auth/login-tenants";
  static const String wallet = "/creator/wallet";
}
