import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../entities/app_config_entity.dart';
import '../repositories/app_config_repository.dart';

class GetAppConfigUseCase implements UseCase<AppConfigEntity, NoParams> {
  GetAppConfigUseCase(this._repository);
  final AppConfigRepository _repository;

  @override
  Future<Either<Failure, AppConfigEntity>> call(NoParams params) {
    return _repository.getAppConfig();
  }
}
