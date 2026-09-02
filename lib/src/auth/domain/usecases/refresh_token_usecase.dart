import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

class RefreshTokenUseCase
    extends UseCase<LoginResponseEntity, Params<RefreshTokenRequestEntity>> {
  RefreshTokenUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, LoginResponseEntity>> call(
    Params<RefreshTokenRequestEntity> params,
  ) {
    return _repository.refreshToken(params.data);
  }
}
