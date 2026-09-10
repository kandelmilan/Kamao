import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/repositories/brand_repository.dart';
import '../entities/brand_entity.dart';
import 'get_popular_brands_usecase.dart' show TakeParams;

class GetFeaturedBrandsUseCase
    implements UseCase<List<BrandEntity>, TakeParams> {
  GetFeaturedBrandsUseCase(this._repository);
  final BrandRepository _repository;

  @override
  Future<Either<Failure, List<BrandEntity>>> call(TakeParams params) {
    return _repository.getFeaturedBrands(take: params.take);
  }
}
