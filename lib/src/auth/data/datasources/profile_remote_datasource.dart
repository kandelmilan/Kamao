import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/data/models/response/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, ApiResponse<ProfileModel>>> getProfile();
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
}
