import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../entities/app_config_entity.dart';

abstract class AppConfigRepository {
  Future<Either<Failure, AppConfigEntity>> getAppConfig();
}
