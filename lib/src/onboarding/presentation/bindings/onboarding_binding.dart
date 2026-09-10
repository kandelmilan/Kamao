import 'package:get/get.dart';
import 'package:kamao/src/onboarding/onboarding.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnboardingController());
  }
}
