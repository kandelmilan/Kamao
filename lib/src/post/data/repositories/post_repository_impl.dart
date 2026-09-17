import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kamao/core/core.dart';
import '../../domain/entities/social_media_entity.dart';
import '../../domain/entities/submission_entity.dart';
import '../../domain/entities/submit_post_params.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this._remoteDataSource);
  final PostRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, SocialMediaEntity>> getSocialMedia({
    required String platform,
    int take = 24,
  }) async {
    try {
      final result = await _remoteDataSource.getSocialMedia(
        platform: platform,
        take: take,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to load social posts'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SubmissionEntity>>> getPendingSubmissions() async {
    try {
      final result = await _remoteDataSource.getPendingSubmissions();
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to load pending submissions'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SubmissionEntity>>>
  getApprovedSubmissions() async {
    try {
      final result = await _remoteDataSource.getApprovedSubmissions();
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to load approved submissions'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> submitPost(SubmitPostParams params) async {
    try {
      final id = await _remoteDataSource.submitPost(
        campaignId: params.campaignId,
        platform: params.platform,
        contentUrl: params.contentUrl,
        externalPostId: params.externalPostId,
        caption: params.caption,
        thumbnailUrl: params.thumbnailUrl,
        receiptPath: params.hasReceipt ? params.receiptPath : null,
      );
      return Right(id);
    } on DioException catch (e) {
      return Left(
        ServerFailure(_dioMessage(e, fallback: 'Failed to submit post')),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _dioMessage(DioException e, {required String fallback}) {
    final data = e.response?.data;
    if (data is Map) {
      final detail = data['detail'] ?? data['message'] ?? data['title'];
      if (detail is String && detail.trim().isNotEmpty) return detail.trim();
    }
    return e.message ?? fallback;
  }
}
