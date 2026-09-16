import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../entities/social_media_entity.dart';
import '../repositories/post_repository.dart';

class GetSocialMediaParams {
  const GetSocialMediaParams({required this.platform, this.take = 24});

  final String platform;
  final int take;
}

class GetSocialMediaUseCase
    implements UseCase<SocialMediaEntity, GetSocialMediaParams> {
  GetSocialMediaUseCase(this._repository);
  final PostRepository _repository;

  @override
  Future<Either<Failure, SocialMediaEntity>> call(GetSocialMediaParams params) {
    return _repository.getSocialMedia(
      platform: params.platform,
      take: params.take,
    );
  }
}
