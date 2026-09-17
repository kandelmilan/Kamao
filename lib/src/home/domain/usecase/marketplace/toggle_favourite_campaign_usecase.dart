import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../../repositories/marketplace_repository.dart';

class ToggleFavouriteCampaignParams {
  const ToggleFavouriteCampaignParams({
    required this.campaignId,
    required this.currentlyFavourite,
  });

  final String campaignId;
  final bool currentlyFavourite;
}

/// POST /favourite or POST /unfavourite based on [currentlyFavourite].
class ToggleFavouriteCampaignUseCase
    implements UseCase<bool, ToggleFavouriteCampaignParams> {
  ToggleFavouriteCampaignUseCase(this._repository);
  final MarketplaceRepository _repository;

  @override
  Future<Either<Failure, bool>> call(ToggleFavouriteCampaignParams params) {
    return params.currentlyFavourite
        ? _repository.unfavouriteCampaign(params.campaignId)
        : _repository.favouriteCampaign(params.campaignId);
  }
}
