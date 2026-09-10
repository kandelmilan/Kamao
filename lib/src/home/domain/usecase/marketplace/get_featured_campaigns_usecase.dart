import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/marketplace_campaign_entity.dart';
import 'package:kamao/src/home/domain/repositories/marketplace_repository.dart';

class GetFeaturedCampaignsUsecase
    implements
        UseCase<List<MarketplaceCampaignEntity>, FeaturedCampaignsParams> {
  GetFeaturedCampaignsUsecase(this._repository);
  final MarketplaceRepository _repository;

  @override
  Future<Either<Failure, List<MarketplaceCampaignEntity>>> call(
    FeaturedCampaignsParams params,
  ) {
    return _repository.getFeaturedCampaigns(
      take: params.take,
      category: params.category,
    );
  }
}

class FeaturedCampaignsParams extends Equatable {
  const FeaturedCampaignsParams({this.take = 12, this.category});
  final int take;
  final String? category;

  @override
  List<Object?> get props => [take, category];
}
