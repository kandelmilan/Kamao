import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../entities/rewarded_post_entity.dart';
import '../repositories/home_extras_repository.dart';
import '../../../brand/domain/usecase/get_popular_brands_usecase.dart' show TakeParams;

class GetRecentlyRewardedUseCase
    implements UseCase<List<RewardedPostEntity>, TakeParams> {
  GetRecentlyRewardedUseCase(this._repository);
  final HomeExtrasRepository _repository;

  @override
  Future<Either<Failure, List<RewardedPostEntity>>> call(TakeParams params) {
    return _repository.getRecentlyRewarded(take: params.take);
  }
}
