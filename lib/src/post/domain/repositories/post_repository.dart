import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../entities/social_media_entity.dart';
import '../entities/submission_entity.dart';
import '../entities/submit_post_params.dart';

abstract class PostRepository {
  Future<Either<Failure, SocialMediaEntity>> getSocialMedia({
    required String platform,
    int take = 24,
  });

  Future<Either<Failure, List<SubmissionEntity>>> getPendingSubmissions();

  Future<Either<Failure, List<SubmissionEntity>>> getApprovedSubmissions();

  /// Returns the new submission id on success.
  Future<Either<Failure, String>> submitPost(SubmitPostParams params);
}
