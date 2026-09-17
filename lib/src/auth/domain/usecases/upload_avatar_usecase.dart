import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/domain/entities/response/user_entity.dart';
import 'package:kamao/src/auth/domain/repositories/profile_repository.dart';

class UploadAvatarParams {
  const UploadAvatarParams(this.filePath);

  final String filePath;
}

class UploadAvatarUseCase extends UseCase<UserEntity, UploadAvatarParams> {
  UploadAvatarUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(UploadAvatarParams params) {
    return _repository.uploadAvatar(params.filePath);
  }
}
