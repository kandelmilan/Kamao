import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

class ForgotPasswordUseCase
    extends
        UseCase<
          ForgotPasswordResponseEntity,
          Params<ForgotPasswordRequestEntity>
        > {
  ForgotPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, ForgotPasswordResponseEntity>> call(
    Params<ForgotPasswordRequestEntity> params,
  ) {
    return _repository.forgotPassword(params.data);
  }
}
