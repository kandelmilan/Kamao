import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/home/home.dart';
import 'package:kamao/src/home/presentation/bindings/campaign_detail_binding.dart';
import 'package:kamao/src/home/presentation/bindings/marketplace_binding.dart';
import 'package:kamao/src/home/presentation/utils/campaign_list/campaign_list_page.dart';
import 'package:kamao/src/home/presentation/views/campaign_detail_page.dart';
import 'package:kamao/src/home/presentation/views/marketplace_page.dart';
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

    GetPage(
      name: AppRoutes.campaignDetail,
      page: () => const CampaignDetailPage(),
      binding: CampaignDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.marketplace,
      page: () => const MarketplacePage(),
      binding: MarketplaceBinding(),
    ),
  ];
}
