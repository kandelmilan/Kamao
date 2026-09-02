import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/tenant/tenant.dart';

class GetTenantsUseCase extends UseCase<List<TenantEntity>, NoParams> {
  GetTenantsUseCase(this.repository);

  final TenantRepository repository;

  @override
  Future<Either<Failure, List<TenantEntity>>> call(NoParams params) {
    return repository.getTenants();
  }
}
