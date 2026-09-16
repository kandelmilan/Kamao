import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/repositories/brand_repository.dart';
import 'get_brand_detail_usecase.dart' show IdParams;

class ViewBrandUseCase implements UseCase<bool, IdParams> {
  ViewBrandUseCase(this._repository);
  final BrandRepository _repository;

  @override
  Future<Either<Failure, bool>> call(IdParams params) {
    return _repository.viewBrand(params.id);
  }
}
