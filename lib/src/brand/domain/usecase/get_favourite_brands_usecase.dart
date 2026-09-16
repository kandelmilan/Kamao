import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import 'package:kamao/src/brand/domain/repositories/brand_repository.dart';
import 'get_popular_brands_usecase.dart' show TakeParams;

class GetFavouriteBrandsUseCase
    implements UseCase<List<BrandEntity>, TakeParams> {
  GetFavouriteBrandsUseCase(this._repository);
  final BrandRepository _repository;

  @override
  Future<Either<Failure, List<BrandEntity>>> call(TakeParams params) {
    return _repository.getFavouriteBrands(take: params.take);
  }
}
