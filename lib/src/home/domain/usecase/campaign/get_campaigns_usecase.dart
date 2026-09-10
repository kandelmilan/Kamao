import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:kamao/src/home/domain/repositories/home_extras_repository.dart';

class CampaignFilterParams extends Equatable {
  const CampaignFilterParams({this.take = 12, this.category});

  final int take;
  final String? category;

  @override
  List<Object?> get props => [take, category];
}

class GetCampaignsUseCase
    implements UseCase<List<CampaignEntity>, CampaignFilterParams> {
  GetCampaignsUseCase(this._repository);
  final HomeExtrasRepository _repository;

  @override
  Future<Either<Failure, List<CampaignEntity>>> call(
    CampaignFilterParams params,
  ) {
    return _repository.getCampaigns(
      take: params.take,
      category: params.category,
    );
  }
}
