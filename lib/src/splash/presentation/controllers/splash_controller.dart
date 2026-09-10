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
      print("Splash error: $e");
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  /// Figures out where to go, without actually navigating — kept separate
  /// so it can run alongside the minimum-display timer above.
  Future<String> _resolveDestination() async {
    final storage = Get.find<AuthStorageService>();

    final firstLaunch = await storage.isFirstLaunch();
    if (firstLaunch) {
      return AppRoutes.onboarding;
    }

    final hasValidSession = await storage.hasValidSession();
    if (!hasValidSession) {
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
    await userController.getMe().timeout(const Duration(seconds: 15));

    return AppRoutes.mainNav;
  }
}
