import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/data/datasources/marketplace_remote_data_source.dart';
import 'package:kamao/src/home/data/repositories/marketplace_repository_impl.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';
import 'package:kamao/src/post/data/datasources/post_remote_data_source.dart';
import 'package:kamao/src/post/data/repositories/post_repository_impl.dart';
import 'package:kamao/src/post/domain/usecase/get_social_media_usecase.dart';
import 'package:kamao/src/post/domain/usecase/submit_post_usecase.dart';
import '../controllers/submit_post_controller.dart';

class SubmitPostBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final params = Get.parameters;

    String? campaignId;
    String? platformId;

    if (args is Map) {
      campaignId = args['campaignId'] as String?;
      platformId = args['platformId'] as String?;
    } else if (args is String) {
      campaignId = args;
    }
    campaignId ??= params['id'];

    if (campaignId == null || campaignId.isEmpty) {
      throw ArgumentError(
        'SubmitPostBinding: no campaign id. '
        'parameters=${Get.parameters}, arguments=${Get.arguments}',
      );
    }

    final apiService = Get.find<ApiService>();

    final marketplaceDs = MarketplaceRemoteDataSourceImpl(apiService);
    final marketplaceRepo = MarketplaceRepositoryImpl(marketplaceDs);

    final postDs = PostRemoteDataSourceImpl(apiService);
    final postRepo = PostRepositoryImpl(postDs);

    Get.put(
      SubmitPostController(
        GetCampaignDetailUseCase(marketplaceRepo),
        GetSocialMediaUseCase(postRepo),
        SubmitPostUseCase(postRepo),
        campaignId,
        initialPlatformId: platformId,
      ),
    );
  }
}
