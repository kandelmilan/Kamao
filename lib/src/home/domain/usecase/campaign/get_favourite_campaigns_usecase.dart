import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/campaign/favourite_campaign_entity.dart';
import 'package:kamao/src/home/domain/repositories/home_extras_repository.dart';
import 'package:kamao/src/brand/domain/usecase/get_popular_brands_usecase.dart';

class GetFavouriteCampaignsUseCase
    implements UseCase<List<FavouriteCampaignEntity>, TakeParams> {
  GetFavouriteCampaignsUseCase(this._repository);
  final HomeExtrasRepository _repository;

  @override
  Future<Either<Failure, List<FavouriteCampaignEntity>>> call(
    TakeParams params,
  ) {
    return _repository.getFavouriteCampaigns(take: params.take);
  }
}