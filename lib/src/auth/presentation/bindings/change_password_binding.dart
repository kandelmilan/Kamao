import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChangePasswordUseCase>()) {
      Get.lazyPut<ChangePasswordUseCase>(
        () => ChangePasswordUseCase(Get.find()),
      );
    }
    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(Get.find()),
    );
  }
}
