import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/data/datasources/marketplace_remote_data_source.dart';
import 'package:kamao/src/home/data/repositories/marketplace_repository_impl.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/join_campaign_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/toggle_favourite_campaign_usecase.dart';
import 'package:kamao/src/home/presentation/controllers/campaign_detail_controller.dart';
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
    final remoteDataSource = MarketplaceRemoteDataSourceImpl(apiService);
    final repository = MarketplaceRepositoryImpl(remoteDataSource);

    Get.put(
      CampaignDetailController(
        GetCampaignDetailUseCase(repository),
        JoinCampaignUseCase(repository),
        ToggleFavouriteCampaignUseCase(repository),
        campaignId,
      ),
    );
  }
}
