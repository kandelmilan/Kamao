import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseEntity>> login(
    LoginRequestEntity request,
  );
  Future<Either<Failure, RegisterResponseEntity>> register(
    RegisterRequestEntity request,
  );

  Future<Either<Failure, LoginResponseEntity>> refreshToken(
    RefreshTokenRequestEntity request,
  );

  Future<Either<Failure, UserEntity>> getMe();

  Future<Either<Failure, ForgotPasswordResponseEntity>> forgotPassword(
    ForgotPasswordRequestEntity request,
  );

  Future<Either<Failure, bool>> changePassword(
    ChangePasswordRequestEntity request,
  );
}
