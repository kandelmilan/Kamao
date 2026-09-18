import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, ApiResponse<LoginResponseModel>>> login(
    LoginRequestModel request,
  );

  Future<Either<Failure, ApiResponse<RegisterResponseModel>>> register(
    RegisterRequestModel request,
  );

  Future<Either<Failure, ApiResponse<LoginResponseModel>>> refreshToken(
    RefreshTokenRequestModel request,
  );

  Future<Either<Failure, ApiResponse<UserModel>>> getMe();
  Future<Either<Failure, ApiResponse<ForgotPasswordResponseModel>>>
  forgotPassword(ForgotPasswordRequestModel request);

  Future<Either<Failure, ApiResponse<bool>>> changePassword(
    ChangePasswordRequestModel request,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Either<Failure, ApiResponse<LoginResponseModel>>> login(
    LoginRequestModel request,
  ) {
    return ApiResponseHandler.handleResponse<LoginResponseModel>(
      () => _apiService.post(ApiEndpoints.login, data: request.toJson()),
      (data) => LoginResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<RegisterResponseModel>>> register(
    RegisterRequestModel request,
  ) {
    return ApiResponseHandler.handleResponse<RegisterResponseModel>(
      () => _apiService.post(ApiEndpoints.register, data: request.toJson()),
      (data) => RegisterResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<LoginResponseModel>>> refreshToken(
    RefreshTokenRequestModel request,
  ) {
    return ApiResponseHandler.handleResponse<LoginResponseModel>(
      () => _apiService.post(ApiEndpoints.refreshToken, data: request.toJson()),
      (data) => LoginResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<UserModel>>> getMe() {
    return ApiResponseHandler.handleResponse<UserModel>(
      () => _apiService.get(ApiEndpoints.profile),
      (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<ForgotPasswordResponseModel>>>
  forgotPassword(ForgotPasswordRequestModel request) {
    return ApiResponseHandler.handleResponse<ForgotPasswordResponseModel>(
      () =>
          _apiService.post(ApiEndpoints.forgotPassword, data: request.toJson()),
      (data) =>
          ForgotPasswordResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<bool>>> changePassword(
    ChangePasswordRequestModel request,
  ) {
    return ApiResponseHandler.handleResponse<bool>(
      () => _apiService.post(
        ApiEndpoints.changePassword,
        data: request.toJson(),
      ),
      (data) => data is bool ? data : data == true || data?.toString() == 'true',
    );
  }
}
