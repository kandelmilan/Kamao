import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

class RegisterUserUsecase
    extends UseCase<RegisterResponseEntity, Params<RegisterRequestEntity>> {
  RegisterUserUsecase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, RegisterResponseEntity>> call(
    Params<RegisterRequestEntity> params,
  ) {
    return _repository.register(params.data);
  }
}
