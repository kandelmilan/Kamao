import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/data/datasources/app_config_remote_data_source.dart';
import 'package:kamao/src/home/data/datasources/home_extras_remote_data_source.dart';
import 'package:kamao/src/home/data/datasources/marketplace_remote_data_source.dart';
import 'package:kamao/src/home/data/repositories/app_config_repository_impl.dart';
import 'package:kamao/src/home/data/repositories/home_extras_repository_impl.dart';
import 'package:kamao/src/home/data/repositories/marketplace_repository_impl.dart';
import 'package:kamao/src/home/domain/usecase/campaign/get_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/campaign/get_favourite_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/campaign/get_popular_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/campaign/get_recent_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/get_app_config_usecase.dart';
import 'package:kamao/src/home/domain/usecase/get_home_categories_usecase.dart';
import 'package:kamao/src/home/domain/usecase/get_recently_rewarded_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_marketplace_recent_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/join_campaign_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/toggle_favourite_campaign_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/view_campaign_usecase.dart';
import 'package:kamao/src/home/home.dart';
import 'package:kamao/src/wallet/wallet.dart';
import 'package:kamao/src/social_connections/data/repositories/social_connections_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put() unconditionally destroys and replaces any existing
    // HomeController, which orphans widgets (e.g. the connect sheet)
    // that already captured a reference to the previous instance —
    // this was the actual cause of "snackbar says connected but the
    // sheet still shows not connected." Only construct it once.
    if (Get.isRegistered<HomeController>()) return;

    final apiService = Get.find<ApiService>();

    // Wallet
    final walletRemoteDataSource = WalletRemoteDataSourceImpl(apiService);
    final walletRepository = WalletRepositoryImpl(walletRemoteDataSource);
    final getWalletUseCase = GetWalletUseCase(walletRepository);

    // Home extras: categories, campaigns, popular campaigns
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
    // final getRecentCampaignsUseCase = GetRecentCampaignsUseCase(
    //   homeExtrasRepository,
    // );
    final getFavouriteCampaignsUseCase = GetFavouriteCampaignsUseCase(
      homeExtrasRepository,
    );

    // Marketplace: recently viewed campaigns, join, favourite, view-tracking
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

    final socialConnectionsRepository = SocialConnectionsRepository(apiService);

    final appConfigRemoteDataSource = AppConfigRemoteDataSourceImpl(apiService);
    final appConfigRepository = AppConfigRepositoryImpl(
      appConfigRemoteDataSource,
    );
    final getAppConfigUseCase = GetAppConfigUseCase(appConfigRepository);
    Get.put(
      HomeController(
        getWalletUseCase,
        getPopularCampaignsUseCase,
        getHomeCategoriesUseCase,
        getRecentlyRewardedUseCase,
        getAppConfigUseCase,
        socialConnectionsRepository,
        getCampaignsUseCase,
        // getRecentCampaignsUseCase,
        getFavouriteCampaignsUseCase,
        getMarketplaceRecentUseCase,
        joinCampaignUseCase,
        toggleFavouriteCampaignUseCase,
        viewCampaignUseCase,
      ),
    );
  }
}
