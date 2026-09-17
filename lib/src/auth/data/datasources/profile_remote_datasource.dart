import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, ApiResponse<ProfileModel>>> getProfile();

  /// GET `/creator/progress` — current progress snapshot.
  Future<Either<Failure, ApiResponse<ProfileProgressStatsModel>>> getProgress();

  /// GET `/creator/progress/guide` — progress + levels + badge catalog.
  Future<Either<Failure, ApiResponse<ProfileProgressModel>>> getProgressGuide();

  /// POST `/auth/me/avatar` — multipart upload (`file` field).
  Future<Either<Failure, ApiResponse<UserModel>>> uploadAvatar(String filePath);

  /// DELETE `/auth/me/avatar`.
  Future<Either<Failure, ApiResponse<UserModel>>> deleteAvatar();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Either<Failure, ApiResponse<ProfileModel>>> getProfile() {
    return ApiResponseHandler.handleResponse<ProfileModel>(
      () => _apiService.get(ApiEndpoints.profileUser),
      (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<ProfileProgressStatsModel>>> getProgress() {
    return ApiResponseHandler.handleResponse<ProfileProgressStatsModel>(
      () => _apiService.get(ApiEndpoints.creatorProgress),
      (data) => ProfileProgressStatsModel.fromJson(
        data as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<ProfileProgressModel>>> getProgressGuide() {
    return ApiResponseHandler.handleResponse<ProfileProgressModel>(
      () => _apiService.get(ApiEndpoints.creatorProgressGuide),
      (data) => ProfileProgressModel.fromJson(
        data as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<UserModel>>> uploadAvatar(String filePath) {
    return ApiResponseHandler.handleResponse<UserModel>(
      () async {
        final name = filePath.split('/').last;
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            filePath,
            filename: name.isNotEmpty ? name : 'avatar.jpg',
          ),
        });
        return _apiService.uploadFile(
          ApiEndpoints.profileAvatar,
          formData: formData,
        );
      },
      (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<UserModel>>> deleteAvatar() {
    return ApiResponseHandler.handleResponse<UserModel>(
      () => _apiService.delete(ApiEndpoints.profileAvatar),
      (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
