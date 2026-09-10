import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../entities/home_category_entity.dart';
import '../repositories/home_extras_repository.dart';

class GetHomeCategoriesUseCase
    implements UseCase<List<HomeCategoryEntity>, NoParams> {
  GetHomeCategoriesUseCase(this._repository);
  final HomeExtrasRepository _repository;

  @override
  Future<Either<Failure, List<HomeCategoryEntity>>> call(NoParams params) {
    return _repository.getHomeCategories();
  }
}
