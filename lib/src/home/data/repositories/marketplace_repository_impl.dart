import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/campaign/recent_campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:kamao/src/home/domain/entities/marketplace_campaign_entity.dart';
import '../../domain/repositories/marketplace_repository.dart';
import '../datasources/marketplace_remote_data_source.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  MarketplaceRepositoryImpl(this._remoteDataSource);
  final MarketplaceRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<RecentCampaignEntity>>> getRecentCampaigns({
    int take = 12,
  }) async {
    try {
      final campaigns = await _remoteDataSource.getRecentCampaigns(take: take);
      return Right(campaigns);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to load recently viewed campaigns'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> joinCampaign(String campaignId) async {
    try {
      final joined = await _remoteDataSource.joinCampaign(campaignId);
      return Right(joined);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to join campaign'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CampaignDetailEntity>> getCampaignDetail(
    String campaignId,
  ) async {
    try {
      final detail = await _remoteDataSource.getCampaignDetail(campaignId);
      return Right(detail);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to load campaign details'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavouriteCampaign(
    String campaignId,
  ) async {
    try {
      final isFavourite = await _remoteDataSource.toggleFavouriteCampaign(
        campaignId,
      );
      return Right(isFavourite);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update favourite'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> viewCampaign(String campaignId) async {
    try {
      final ok = await _remoteDataSource.viewCampaign(campaignId);
      return Right(ok);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to record view'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MarketplaceCampaignEntity>>>
  getFeaturedCampaigns({int take = 12, String? category}) async {
    try {
      final campaigns = await _remoteDataSource.getFeaturedCampaigns(
        take: take,
        category: category,
      );
      return Right(campaigns);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to load featured campaigns'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MarketplaceCampaignEntity>>>
  getMarketplaceCampaigns({String sort = 'new', String? category}) async {
    try {
      final campaigns = await _remoteDataSource.getMarketplaceCampaigns(
        sort: sort,
        category: category,
      );
      return Right(campaigns);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to load marketplace campaigns'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
