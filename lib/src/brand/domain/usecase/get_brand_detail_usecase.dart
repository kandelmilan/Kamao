import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../entities/brand_detail_entity.dart';
import '../repositories/brand_repository.dart';

class IdParams {
  const IdParams(this.id);
  final String id;
}

class GetBrandDetailUseCase implements UseCase<BrandDetailEntity, IdParams> {
  GetBrandDetailUseCase(this._repository);
  final BrandRepository _repository;

  @override
  Future<Either<Failure, BrandDetailEntity>> call(IdParams params) {
    return _repository.getBrandDetail(params.id);
  }
}
