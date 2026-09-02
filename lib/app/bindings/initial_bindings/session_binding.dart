import 'package:get/get.dart';
import 'package:kamao/core/core.dart';

class SessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InactivityService>(
      () => InactivityService(
        Get.find<AuthStorageService>(),
        // timeout: const Duration(seconds: 15),
      ),
    );

    Get.put<AutoLogoutHandler>(
      AutoLogoutHandler(Get.find<AuthStorageService>()),
      permanent: true,
    );
  }
}
