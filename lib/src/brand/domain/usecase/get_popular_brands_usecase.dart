import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/repositories/brand_repository.dart';
import '../entities/brand_entity.dart';

class TakeParams {
  const TakeParams({this.take = 12});
  final int take;
}

class GetPopularBrandsUseCase
    implements UseCase<List<BrandEntity>, TakeParams> {
  GetPopularBrandsUseCase(this._repository);
  final BrandRepository _repository;

  @override
  Future<Either<Failure, List<BrandEntity>>> call(TakeParams params) {
    return _repository.getPopularBrands(take: params.take);
  }
}
