import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/domain/entities/response/user_entity.dart';
import 'package:kamao/src/auth/domain/repositories/profile_repository.dart';

class DeleteAvatarUseCase extends UseCase<UserEntity, NoParams> {
  DeleteAvatarUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return _repository.deleteAvatar();
  }
}
