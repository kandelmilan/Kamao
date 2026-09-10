import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kamao/core/core.dart';
import '../../domain/entities/app_config_entity.dart';
import '../../domain/repositories/app_config_repository.dart';
import '../datasources/app_config_remote_data_source.dart';

class AppConfigRepositoryImpl implements AppConfigRepository {
  AppConfigRepositoryImpl(this._remoteDataSource);
  final AppConfigRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AppConfigEntity>> getAppConfig() async {
    try {
      final config = await _remoteDataSource.getAppConfig();
      return Right(config);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to load app config'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
