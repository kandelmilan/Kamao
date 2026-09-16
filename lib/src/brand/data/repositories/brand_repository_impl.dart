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

  Future<Either<Failure, List<BrandEntity>>> _guardList(
    Future<List<BrandEntity>> Function() run,
    String fallback,
  ) async {
    try {
      return Right(await run());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? fallback));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BrandDetailEntity>> getBrandDetail(
    String brandId,
  ) async {
    try {
      final result = await _remoteDataSource.getBrandDetail(brandId);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to load brand'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BrandEntity>>> getBrands(
    BrandQueryParams params,
  ) {
    return _guardList(
      () => _remoteDataSource.getBrands(
        take: params.take,
        category: params.category,
        sort: params.sort,
      ),
      'Failed to load brands',
    );
  }

  @override
  Future<Either<Failure, List<BrandEntity>>> getPopularBrands({
    int take = 12,
  }) {
    return _guardList(
      () => _remoteDataSource.getPopularBrands(take: take),
      'Failed to load popular brands',
    );
  }

  @override
  Future<Either<Failure, List<BrandEntity>>> getFeaturedBrands({
    int take = 12,
  }) {
    return _guardList(
      () => _remoteDataSource.getFeaturedBrands(take: take),
      'Failed to load featured brands',
    );
  }

  @override
  Future<Either<Failure, List<BrandEntity>>> getRecentBrands({int take = 12}) {
    return _guardList(
      () => _remoteDataSource.getRecentBrands(take: take),
      'Failed to load recent brands',
    );
  }

  @override
  Future<Either<Failure, List<BrandEntity>>> getFavouriteBrands({
    int take = 48,
  }) {
    return _guardList(
      () => _remoteDataSource.getFavouriteBrands(take: take),
      'Failed to load favourite brands',
    );
  }

  Future<Either<Failure, bool>> _guardBool(
    Future<bool> Function() run,
    String fallback,
  ) async {
    try {
      return Right(await run());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? fallback));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> viewBrand(String brandId) {
    return _guardBool(
      () => _remoteDataSource.viewBrand(brandId),
      'Failed to record brand view',
    );
  }

  @override
  Future<Either<Failure, bool>> favouriteBrand(String brandId) {
    return _guardBool(
      () => _remoteDataSource.favouriteBrand(brandId),
      'Failed to favourite brand',
    );
  }

  @override
  Future<Either<Failure, bool>> unfavouriteBrand(String brandId) {
    return _guardBool(
      () => _remoteDataSource.unfavouriteBrand(brandId),
      'Failed to unfavourite brand',
    );
  }
}
