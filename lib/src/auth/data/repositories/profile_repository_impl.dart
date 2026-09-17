import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    final result = await _remoteDataSource.getProfile();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!.toEntity()),
    );
  }

  @override
  Future<Either<Failure, ProfileProgressStatsEntity>> getProgress() async {
    final result = await _remoteDataSource.getProgress();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!.toEntity()),
    );
  }

  @override
  Future<Either<Failure, ProfileProgressEntity>> getProgressGuide() async {
    final result = await _remoteDataSource.getProgressGuide();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!.toEntity()),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> uploadAvatar(String filePath) async {
    final result = await _remoteDataSource.uploadAvatar(filePath);

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!.toEntity()),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> deleteAvatar() async {
    final result = await _remoteDataSource.deleteAvatar();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!.toEntity()),
    );
  }
}
