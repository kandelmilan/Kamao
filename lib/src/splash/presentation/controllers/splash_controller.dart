import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

class SplashController extends GetxController {
  final AuthController userController = Get.find<AuthController>();

  /// How long the branded splash stays on screen at minimum, regardless
  /// of how fast the session check below resolves. Bump this if you want
  /// the animation to breathe longer, or drop it if you'd rather route
  /// the instant the check finishes.
  static const _minDisplayTime = Duration(seconds: 3);

  @override
  void onInit() {
    super.onInit();
    checkAppState();
  }

  Future<void> checkAppState() async {
    try {
      // Run the session check and the minimum-display timer in parallel,
      // so a slow check doesn't add to the 3s, and a fast check doesn't
      // cut the splash short.
      final results = await Future.wait([
        _resolveDestination(),
        Future.delayed(_minDisplayTime),
      ]);

      final destination = results.first as String;
      Get.offAllNamed(destination);
    } catch (e) {
      AppLogger.error('Splash error: $e', tag: 'SPLASH');
      // Prefer login over onboarding on unexpected errors — first-launch
      // is already handled inside _resolveDestination.
      Get.offAllNamed(AppRoutes.login);
    }
  }

  /// Routing:
  /// 1. First launch → onboarding
  /// 2. No auth token → login
  /// 3. Valid token → main nav (home)
  Future<String> _resolveDestination() async {
    final storage = Get.find<AuthStorageService>();

    final firstLaunch = await storage.isFirstLaunch();
    if (firstLaunch) {
      return AppRoutes.onboarding;
    }

    final accessToken = await storage.getAccessToken();
    final hasToken = accessToken != null && accessToken.isNotEmpty;
    if (!hasToken) {
      await storage.clearAuthData();
      return AppRoutes.login;
    }

    final inactivityService = Get.find<InactivityService>();
    final expired = await inactivityService.hasSessionExpired();
    if (expired) {
      await userController.logout();
      return AppRoutes.login;
    }

    inactivityService.initialize();
    try {
      await userController.getMe().timeout(const Duration(seconds: 15));
    } catch (e) {
      // Token exists but profile fetch failed — still enter the app;
      // API interceptor will handle auth failures on subsequent calls.
      AppLogger.error('Splash getMe failed: $e', tag: 'SPLASH');
    }

    return AppRoutes.mainNav;
  }
}
