import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';
import '../../repositories/marketplace_repository.dart';

class ToggleFavouriteCampaignUseCase
    implements UseCase<bool, CampaignIdParams> {
  ToggleFavouriteCampaignUseCase(this._repository);
  final MarketplaceRepository _repository;

  @override
  Future<Either<Failure, bool>> call(CampaignIdParams params) {
    return _repository.toggleFavouriteCampaign(params.campaignId);
  }
}
