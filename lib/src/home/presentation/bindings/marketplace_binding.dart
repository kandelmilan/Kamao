import 'package:get/get.dart';
import 'package:kamao/src/home/data/datasources/app_config_remote_data_source.dart';
import 'package:kamao/src/home/data/datasources/home_extras_remote_data_source.dart';
import 'package:kamao/src/home/data/datasources/marketplace_remote_data_source.dart';
import 'package:kamao/src/home/data/repositories/app_config_repository_impl.dart';
import 'package:kamao/src/home/data/repositories/home_extras_repository_impl.dart';
import 'package:kamao/src/home/data/repositories/marketplace_repository_impl.dart';
import 'package:kamao/src/home/domain/repositories/home_extras_repository.dart';
import 'package:kamao/src/home/domain/repositories/marketplace_repository.dart';
import 'package:kamao/src/home/domain/repositories/app_config_repository.dart';
import 'package:kamao/src/home/domain/usecase/campaign/get_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/get_app_config_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_featured_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_new_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/toggle_favourite_campaign_usecase.dart';
import 'package:kamao/src/home/presentation/controllers/marketplace_controller.dart';

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
