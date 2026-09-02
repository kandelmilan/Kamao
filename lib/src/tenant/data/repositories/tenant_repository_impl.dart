import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/tenant/tenant.dart';

class TenantRepositoryImpl implements TenantRepository {
  TenantRepositoryImpl(this.remoteDataSource);

  final TenantRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<TenantEntity>>> getTenants() async {
    final result = await remoteDataSource.getTenants();

    return result.fold(
      (failure) {
        return Left(failure);
      },

      (response) {
        final tenants = response.data?.map((e) => e.toEntity()).toList() ?? [];

        return Right(tenants);
      },
    );
  }
}
