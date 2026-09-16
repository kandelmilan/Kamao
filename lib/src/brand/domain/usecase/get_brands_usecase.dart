import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import 'package:kamao/src/brand/domain/repositories/brand_repository.dart';

class GetBrandsUseCase
    implements UseCase<List<BrandEntity>, BrandQueryParams> {
  GetBrandsUseCase(this._repository);
  final BrandRepository _repository;

  @override
  Future<Either<Failure, List<BrandEntity>>> call(BrandQueryParams params) {
    return _repository.getBrands(params);
  }
}
