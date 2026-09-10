import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:kamao/src/home/domain/repositories/marketplace_repository.dart';

class GetCampaignDetailUseCase
    implements UseCase<CampaignDetailEntity, CampaignIdParams> {
  GetCampaignDetailUseCase(this._repository);
  final MarketplaceRepository _repository;

  @override
  Future<Either<Failure, CampaignDetailEntity>> call(CampaignIdParams params) {
    return _repository.getCampaignDetail(params.campaignId);
  }
}

class CampaignIdParams {
  const CampaignIdParams(this.campaignId);
  final String campaignId;
}
