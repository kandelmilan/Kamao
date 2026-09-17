import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';

class CreatorLevelsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<GetCreatorProgressUseCase>()) {
      Get.lazyPut(
        () => GetCreatorProgressUseCase(Get.find<ProfileRepository>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetCreatorProgressGuideUseCase>()) {
      Get.lazyPut(
        () => GetCreatorProgressGuideUseCase(Get.find<ProfileRepository>()),
        fenix: true,
      );
    }
    Get.lazyPut(
      () => CreatorLevelsController(Get.find<GetCreatorProgressGuideUseCase>()),
    );
  }
}
