import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/domain/entities/response/profile_entity.dart';
import 'package:kamao/src/auth/domain/entities/response/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();

  Future<Either<Failure, ProfileProgressStatsEntity>> getProgress();

  Future<Either<Failure, ProfileProgressEntity>> getProgressGuide();

  Future<Either<Failure, UserEntity>> uploadAvatar(String filePath);

  Future<Either<Failure, UserEntity>> deleteAvatar();
}
