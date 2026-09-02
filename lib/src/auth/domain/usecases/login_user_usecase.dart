import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

class LoginUserUsecase
    extends UseCase<LoginResponseEntity, Params<LoginRequestEntity>> {
  LoginUserUsecase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, LoginResponseEntity>> call(
    Params<LoginRequestEntity> params,
  ) {
    return _repository.login(params.data);
  }
}
