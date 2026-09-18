import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

class ChangePasswordUseCase
    extends UseCase<bool, Params<ChangePasswordRequestEntity>> {
  ChangePasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, bool>> call(
    Params<ChangePasswordRequestEntity> params,
  ) {
    return _repository.changePassword(params.data);
  }
}
