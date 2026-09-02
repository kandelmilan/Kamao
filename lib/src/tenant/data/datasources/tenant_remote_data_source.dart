import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/tenant/tenant.dart';

abstract class TenantRemoteDataSource {
  Future<Either<Failure, ApiResponse<List<TenantModel>>>> getTenants();
}

class TenantRemoteDataSourceImpl implements TenantRemoteDataSource {
  TenantRemoteDataSourceImpl(this.apiService);

  final ApiService apiService;

  @override
  Future<Either<Failure, ApiResponse<List<TenantModel>>>> getTenants() {
    return ApiResponseHandler.handleResponse<List<TenantModel>>(
      () => apiService.get(ApiEndpoints.tenants),
      (data) {
        final list = data as List<dynamic>;
        return list
            .map((e) => TenantModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
