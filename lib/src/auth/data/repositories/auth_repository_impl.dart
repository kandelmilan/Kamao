import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  @override
  Future<Either<Failure, LoginResponseEntity>> login(
    LoginRequestEntity request,
  ) async {
    final requestModel = LoginRequestModel.fromEntity(request);

    final result = await _remoteDataSource.login(requestModel);

    return result.fold((failure) => Left(failure), (response) {
      final loginResponse = response.data;

      if (loginResponse == null) {
        return Left(ServerFailure("Login response data is null"));
      }

      return Right(loginResponse.toEntity());
    });
  }

  @override
  Future<Either<Failure, RegisterResponseEntity>> register(
    RegisterRequestEntity request,
  ) async {
    final requestModel = RegisterRequestModel.fromEntity(request);

    final result = await _remoteDataSource.register(requestModel);

    return result.fold((failure) => Left(failure), (response) {
      final registerResponse = response.data;

      if (registerResponse == null) {
        return Left(ServerFailure("Register response data is null"));
      }

      return Right(registerResponse.toEntity());
    });
  }

  @override
  Future<Either<Failure, LoginResponseEntity>> refreshToken(
    RefreshTokenRequestEntity request,
  ) async {
    final requestModel = RefreshTokenRequestModel.fromEntity(request);

    final result = await _remoteDataSource.refreshToken(requestModel);

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!.toEntity()),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> getMe() async {
    final result = await _remoteDataSource.getMe();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!.toEntity()),
    );
  }

  @override
  Future<Either<Failure, ForgotPasswordResponseEntity>> forgotPassword(
    ForgotPasswordRequestEntity request,
  ) async {
    final requestModel = ForgotPasswordRequestModel.fromEntity(request);

    final result = await _remoteDataSource.forgotPassword(requestModel);

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!.toEntity()),
    );
  }
}
