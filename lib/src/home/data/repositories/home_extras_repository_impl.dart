import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/campaign/favourite_campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/rewarded_post_entity.dart';
import '../../domain/entities/home_category_entity.dart';
import '../../domain/repositories/home_extras_repository.dart';
import '../datasources/home_extras_remote_data_source.dart';

class HomeExtrasRepositoryImpl implements HomeExtrasRepository {
  HomeExtrasRepositoryImpl(this._remoteDataSource);
  final HomeExtrasRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<HomeCategoryEntity>>> getHomeCategories() async {
    try {
      final categories = await _remoteDataSource.getHomeCategories();
      return Right(categories);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to load categories'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RewardedPostEntity>>> getRecentlyRewarded({
    int take = 12,
  }) async {
    try {
      final posts = await _remoteDataSource.getRecentlyRewarded(take: take);
      return Right(posts);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to load recently rewarded posts'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CampaignEntity>>> getCampaigns({
    int take = 12,
    String? category,
  }) async {
    try {
      final campaigns = await _remoteDataSource.getCampaigns(
        take: take,
        category: category,
      );
      return Right(campaigns);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to load campaigns'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, List<RecentCampaignEntity>>> getRecentCampaigns({
  //   int take = 12,
  // }) async {
  //   try {
  //     final campaigns = await _remoteDataSource.getRecentCampaigns(take: take);
  //     return Right(campaigns);
  //   } on DioException catch (e) {
  //     return Left(
  //       ServerFailure(e.message ?? 'Failed to load recent campaigns'),
  //     );
  //   } catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, List<CampaignEntity>>> getPopularCampaigns({
    int take = 12,
  }) async {
    try {
      final campaigns = await _remoteDataSource.getPopularCampaigns(take: take);
      return Right(campaigns);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to load popular campaigns'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
 @override
  Future<Either<Failure, List<FavouriteCampaignEntity>>> getFavouriteCampaigns({
    int take = 24,
  }) async {
    try {
      final campaigns = await _remoteDataSource.getFavouriteCampaigns(
        take: take,
      );
      return Right(campaigns);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to load favourite campaigns'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
