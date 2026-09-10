import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/campaign/recent_campaign_entity.dart';
import 'package:kamao/src/brand/domain/usecase/get_popular_brands_usecase.dart';
import '../../repositories/marketplace_repository.dart';

class GetMarketplaceRecentUseCase
    implements UseCase<List<RecentCampaignEntity>, TakeParams> {
  GetMarketplaceRecentUseCase(this._repository);
  final MarketplaceRepository _repository;

  @override
  Future<Either<Failure, List<RecentCampaignEntity>>> call(TakeParams params) {
    return _repository.getRecentCampaigns(take: params.take);
  }
}
