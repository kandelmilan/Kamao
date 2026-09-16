import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/brand/presentation/bindings/brands_binding.dart';
import 'package:kamao/src/brand/presentation/views/brands_page.dart';
import 'package:kamao/src/home/home.dart';
import 'package:kamao/src/home/presentation/bindings/campaign_detail_binding.dart';
import 'package:kamao/src/home/presentation/bindings/marketplace_binding.dart';
import 'package:kamao/src/home/presentation/views/campaign_detail_page.dart';
import 'package:kamao/src/home/presentation/views/marketplace_page.dart';
import 'package:kamao/src/main_nav/main_nav.dart';
import 'package:kamao/src/onboarding/onboarding.dart';
import 'package:kamao/src/post/presentation/bindings/submit_post_binding.dart';
import 'package:kamao/src/post/presentation/views/submit_post_view.dart';
import 'package:kamao/src/splash/splash.dart';
import 'package:kamao/src/wallet/presentation/bindings%20/wallet_bindings.dart';
import 'package:kamao/src/wallet/presentation/bindings/withdraw_binding.dart';
import 'package:kamao/src/wallet/presentation/views/wallet_transactions_view.dart';
import 'package:kamao/src/wallet/presentation/views/wallet_view.dart';
import 'package:kamao/src/wallet/presentation/views/withdraw_view.dart';
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
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
      name: AppRoutes.mainNav,
      page: () => const MainNavView(),
      binding: MainNavBinding(),
    ),
    // Kept for deep links / direct pushes; primary shell is [AppRoutes.mainNav].
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.campaignDetail,
      page: () => const CampaignDetailPage(),
      binding: CampaignDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.submitPost,
      page: () => const SubmitPostView(),
      binding: SubmitPostBinding(),
    ),
    GetPage(
      name: AppRoutes.marketplace,
      page: () => const MarketplacePage(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: AppRoutes.brands,
      page: () => const BrandsPage(),
      binding: BrandsBinding(),
    ),
    GetPage(
      name: AppRoutes.wallet,
      page: () => WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: AppRoutes.walletdetails,
      page: () => WalletTransactionsView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: AppRoutes.withdraw,
      page: () => const WithdrawView(),
      binding: WithdrawBinding(),
    ),
  ];
}
