import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/home/home.dart';
import 'package:kamao/src/main_nav/main_nav.dart';
import 'package:kamao/src/onboarding/onboarding.dart';
import 'package:kamao/src/splash/splash.dart';
import 'app_routes.dart';

abstract class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(name: AppRoutes.login, page: () => LoginView()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),

    // GetPage(name: AppRoutes.dashboard, page: () => const DashboardView()),
    // GetPage(name: AppRoutes.profile, page: () => const ProfilePage()),
    GetPage(
      name: AppRoutes.mainNav,
      page: () => const MainNavView(),
      binding: MainNavBinding(),
    ),
  ];
}
