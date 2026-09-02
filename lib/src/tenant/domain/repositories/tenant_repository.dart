import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/tenant/tenant.dart';

abstract class TenantRepository {
  Future<Either<Failure, List<TenantEntity>>> getTenants();
}
