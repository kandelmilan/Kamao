import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/data/datasources/profile_remote_datasource.dart';
import 'package:kamao/src/auth/domain/entities/response/profile_entity.dart';
import 'package:kamao/src/auth/domain/repositories/profile_repository.dart';

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
}
