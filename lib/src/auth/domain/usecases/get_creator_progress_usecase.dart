import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/domain/entities/response/profile_entity.dart';
import 'package:kamao/src/auth/domain/repositories/profile_repository.dart';

class GetCreatorProgressUseCase
    extends UseCase<ProfileProgressStatsEntity, NoParams> {
  GetCreatorProgressUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, ProfileProgressStatsEntity>> call(NoParams params) {
    return _repository.getProgress();
  }
}
