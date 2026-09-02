import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';

class AutoLogoutHandler {
  AutoLogoutHandler(this._authStorage);

  final AuthStorageService _authStorage;

  /// Called when the inactivity timeout is reached.
  Future<void> handleTimeout() async {
    try {
      Get.find<InactivityService>().stop();

      // Clear authenticated session
      await _authStorage.clearAuthData();

      // TODO:
      // - Clear cached user/profile controller if needed
      // - Stop sync service (when implemented)
      // - Cancel background tasks (if any)

      // Navigate to Login
      Get.offAllNamed(AppRoutes.login);

      // Notify the user
      Get.snackbar(
        'Session Expired',
        'Your session has expired due to inactivity. Please sign in again to continue.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } catch (e, stackTrace) {
      debugPrint('Auto logout failed: $e');
      debugPrintStack(stackTrace: stackTrace);

      // Even if clearing storage fails, force navigation to Login.
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
