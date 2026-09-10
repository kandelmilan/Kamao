import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:kamao/src/home/domain/repositories/home_extras_repository.dart';
import 'package:kamao/src/brand/domain/usecase/get_popular_brands_usecase.dart'
    show TakeParams;

class GetPopularCampaignsUseCase
    implements UseCase<List<CampaignEntity>, TakeParams> {
  GetPopularCampaignsUseCase(this._repository);
  final HomeExtrasRepository _repository;

  @override
  Future<Either<Failure, List<CampaignEntity>>> call(TakeParams params) {
    return _repository.getPopularCampaigns(take: params.take);
  }
}
