import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/auth/domain/entities/request/register_request_entity.dart';
import 'package:kamao/src/auth/domain/entities/response/register_response_entity.dart';

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
}
