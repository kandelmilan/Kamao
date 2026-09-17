import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/brand.dart';
import 'package:kamao/src/home/home.dart';
import 'package:kamao/src/social_connections/presentation/bindings/social_connections_binding.dart';

class CampaignDetailBinding extends Bindings {
  @override
  void dependencies() {
    final rawId = Get.parameters['id'] ?? Get.arguments;
    if (rawId is! String || rawId.isEmpty) {
      throw ArgumentError(
        'CampaignDetailBinding: no campaign id. '
        'parameters=${Get.parameters}, arguments=${Get.arguments}',
      );
    }
    final campaignId = rawId;

    SocialConnectionsBinding().dependencies();

    final apiService = Get.find<ApiService>();
    final marketplaceRepository = MarketplaceRepositoryImpl(
      MarketplaceRemoteDataSourceImpl(apiService),
    );
    final brandRepository = BrandRepositoryImpl(
      BrandRemoteDataSourceImpl(apiService),
    );

    Get.put(
      CampaignDetailController(
        getCampaignDetailUseCase: GetCampaignDetailUseCase(
          marketplaceRepository,
        ),
        joinCampaignUseCase: JoinCampaignUseCase(marketplaceRepository),
        toggleFavouriteCampaignUseCase: ToggleFavouriteCampaignUseCase(
          marketplaceRepository,
        ),
        getBrandDetailUseCase: GetBrandDetailUseCase(brandRepository),
        campaignId: campaignId,
      ),
    );
  }
}
