import 'package:get/get.dart';
import 'package:kamao/src/home/home.dart';

class MarketplaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketplaceRemoteDataSource>(
      () => MarketplaceRemoteDataSourceImpl(Get.find()),
    );
    Get.lazyPut<AppConfigRemoteDataSource>(
      () => AppConfigRemoteDataSourceImpl(Get.find()),
    );
    Get.lazyPut<HomeExtrasRemoteDataSource>(
      () => HomeExtrasRemoteDataSourceImpl(Get.find()),
    );
    Get.lazyPut<MarketplaceRepository>(
      () => MarketplaceRepositoryImpl(Get.find()),
    );

    Get.lazyPut<AppConfigRepository>(() => AppConfigRepositoryImpl(Get.find()));
    Get.lazyPut<HomeExtrasRepository>(
      () => HomeExtrasRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => GetFeaturedCampaignsUsecase(Get.find()));
    Get.lazyPut(() => GetCampaignsUseCase(Get.find()));
    Get.lazyPut(() => GetNewCampaignsUsecase(Get.find()));
    Get.lazyPut(() => GetAppConfigUseCase(Get.find()));
    Get.lazyPut(() => ToggleFavouriteCampaignUseCase(Get.find()));

    Get.lazyPut(
      () => MarketplaceController(
        getCampaignsUseCase: Get.find(),
        getFeaturedCampaigns: Get.find(),
        getNewCampaigns: Get.find(),
        getCategories: Get.find(),
        toggleFavourite: Get.find(),
      ),
    );
  }
}
