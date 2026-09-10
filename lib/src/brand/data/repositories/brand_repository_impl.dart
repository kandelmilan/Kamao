import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import '../../domain/entities/brand_detail_entity.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/brand_remote_data_source.dart';

class BrandRepositoryImpl implements BrandRepository {
  BrandRepositoryImpl(this._remoteDataSource);
  final BrandRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, BrandDetailEntity>> getBrandDetail(
    String brandId,
  ) async {
    try {
      final result = await _remoteDataSource.getBrandDetail(brandId);
      return Right(result);
    } on DioException catch (e) {
      // TODO: match whatever Failure subclass(es) your other
      // repositories throw (ServerFailure / NetworkFailure / etc.) —
      // this is a placeholder shape.
      return Left(ServerFailure(e.message ?? 'Failed to load brand'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BrandEntity>>> getPopularBrands({
    int take = 12,
  }) async {
    try {
      final brands = await _remoteDataSource.getPopularBrands(take: take);
      return Right(brands);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to load popular brands'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BrandEntity>>> getFeaturedBrands({
    int take = 12,
  }) async {
    try {
      final brands = await _remoteDataSource.getFeaturedBrands(take: take);
      return Right(brands);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to load featured brands'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
