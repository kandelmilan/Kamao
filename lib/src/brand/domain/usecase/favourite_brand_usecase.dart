import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/repositories/brand_repository.dart';
import 'get_brand_detail_usecase.dart' show IdParams;

class FavouriteBrandUseCase implements UseCase<bool, IdParams> {
  FavouriteBrandUseCase(this._repository);
  final BrandRepository _repository;

  @override
  Future<Either<Failure, bool>> call(IdParams params) {
    return _repository.favouriteBrand(params.id);
  }
}

class UnfavouriteBrandUseCase implements UseCase<bool, IdParams> {
  UnfavouriteBrandUseCase(this._repository);
  final BrandRepository _repository;

  @override
  Future<Either<Failure, bool>> call(IdParams params) {
    return _repository.unfavouriteBrand(params.id);
  }
}
