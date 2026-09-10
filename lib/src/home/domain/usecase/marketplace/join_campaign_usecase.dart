import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../../repositories/marketplace_repository.dart';

class JoinCampaignParams {
  const JoinCampaignParams(this.campaignId);
  final String campaignId;
}

class JoinCampaignUseCase implements UseCase<bool, JoinCampaignParams> {
  JoinCampaignUseCase(this._repository);
  final MarketplaceRepository _repository;

  @override
  Future<Either<Failure, bool>> call(JoinCampaignParams params) {
    return _repository.joinCampaign(params.campaignId);
  }
}
