import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/brand.dart';
import 'package:kamao/src/home/home.dart';
import 'package:kamao/src/social_connections/social_connections.dart';
import 'package:kamao/src/wallet/wallet.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<HomeController>()) return;

    SocialConnectionsBinding().dependencies();

    final apiService = Get.find<ApiService>();
    final walletRemoteDataSource = WalletRemoteDataSourceImpl(apiService);
    final walletRepository = WalletRepositoryImpl(walletRemoteDataSource);
    final getWalletUseCase = GetWalletUseCase(walletRepository);
    final homeExtrasRemoteDataSource = HomeExtrasRemoteDataSourceImpl(
      apiService,
    );
    final homeExtrasRepository = HomeExtrasRepositoryImpl(
      homeExtrasRemoteDataSource,
    );
    final getHomeCategoriesUseCase = GetHomeCategoriesUseCase(
      homeExtrasRepository,
    );
    final getRecentlyRewardedUseCase = GetRecentlyRewardedUseCase(
      homeExtrasRepository,
    );
    final getCampaignsUseCase = GetCampaignsUseCase(homeExtrasRepository);
    final getPopularCampaignsUseCase = GetPopularCampaignsUseCase(
      homeExtrasRepository,
    );
    final getFavouriteCampaignsUseCase = GetFavouriteCampaignsUseCase(
      homeExtrasRepository,
    );
    final marketplaceRemoteDataSource = MarketplaceRemoteDataSourceImpl(
      apiService,
    );
    final marketplaceRepository = MarketplaceRepositoryImpl(
      marketplaceRemoteDataSource,
    );
    final getMarketplaceRecentUseCase = GetMarketplaceRecentUseCase(
      marketplaceRepository,
    );
    final joinCampaignUseCase = JoinCampaignUseCase(marketplaceRepository);
    final toggleFavouriteCampaignUseCase = ToggleFavouriteCampaignUseCase(
      marketplaceRepository,
    );
    final viewCampaignUseCase = ViewCampaignUseCase(marketplaceRepository);

    final appConfigRemoteDataSource = AppConfigRemoteDataSourceImpl(apiService);
    final appConfigRepository = AppConfigRepositoryImpl(
      appConfigRemoteDataSource,
    );
    final getAppConfigUseCase = GetAppConfigUseCase(appConfigRepository);

    final brandRemoteDataSource = BrandRemoteDataSourceImpl(apiService);
    final brandRepository = BrandRepositoryImpl(brandRemoteDataSource);
    final getPopularBrandsUseCase = GetPopularBrandsUseCase(brandRepository);
    final getFeaturedBrandsUseCase = GetFeaturedBrandsUseCase(brandRepository);
    final getRecentBrandsUseCase = GetRecentBrandsUseCase(brandRepository);

    Get.put(
      HomeController(
        getWalletUseCase,
        getPopularCampaignsUseCase,
        getHomeCategoriesUseCase,
        getRecentlyRewardedUseCase,
        getAppConfigUseCase,
        getCampaignsUseCase,
        getFavouriteCampaignsUseCase,
        getMarketplaceRecentUseCase,
        joinCampaignUseCase,
        toggleFavouriteCampaignUseCase,
        viewCampaignUseCase,
        getPopularBrandsUseCase,
        getFeaturedBrandsUseCase,
        getRecentBrandsUseCase,
      ),
    );
  }
}
