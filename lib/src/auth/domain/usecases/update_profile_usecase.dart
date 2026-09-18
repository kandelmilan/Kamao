import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/domain/entities/request/update_profile_request_entity.dart';
import 'package:kamao/src/auth/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase
    extends UseCase<bool, Params<UpdateProfileRequestEntity>> {
  UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, bool>> call(
    Params<UpdateProfileRequestEntity> params,
  ) {
    return _repository.updateProfile(params.data);
  }
}
