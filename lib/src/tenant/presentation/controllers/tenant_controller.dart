import 'package:kamao/core/core.dart';
import 'package:kamao/src/tenant/tenant.dart';
import 'package:get/get.dart';

class TenantController extends GetxController {
  TenantController(this._getTenantsUseCase);

  final GetTenantsUseCase _getTenantsUseCase;

  final isLoading = false.obs;
  final tenants = <TenantEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    getTenants();
  }

  Future<void> getTenants() async {
    isLoading.value = true;

    final result = await _getTenantsUseCase(const NoParams());

    result.fold(
      (failure) {
        Get.snackbar("Error", failure.message);
      },
      (data) {
        tenants.assignAll(data.where((e) => e.isActive).toList());
      },
    );

    isLoading.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
