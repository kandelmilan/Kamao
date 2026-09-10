import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/marketplace_campaign_entity.dart';
import 'package:kamao/src/home/domain/repositories/marketplace_repository.dart';

class GetNewCampaignsUsecase
    implements UseCase<List<MarketplaceCampaignEntity>, NewCampaignsParams> {
  GetNewCampaignsUsecase(this._repository);
  final MarketplaceRepository _repository;

  @override
  Future<Either<Failure, List<MarketplaceCampaignEntity>>> call(
    NewCampaignsParams params,
  ) {
    return _repository.getMarketplaceCampaigns(
      sort: params.sort,
      category: params.category,
    );
  }
}

class NewCampaignsParams extends Equatable {
  const NewCampaignsParams({this.sort = 'new', this.category});
  final String sort;
  final String? category;

  @override
  List<Object?> get props => [sort, category];
}
