import 'package:get/get.dart';
import 'package:kamao/src/tenant/tenant.dart';

class TenantDependencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenantRemoteDataSource>(
      () => TenantRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut<TenantRepository>(
      () => TenantRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut<GetTenantsUseCase>(
      () => GetTenantsUseCase(Get.find()),
      fenix: true,
    );
    Get.lazyPut<TenantController>(
      () => TenantController(Get.find()),
      fenix: true,
    );
  }
}
