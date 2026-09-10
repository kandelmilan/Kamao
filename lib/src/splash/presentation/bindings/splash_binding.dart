import 'package:get/get.dart';
import 'package:kamao/src/splash/splash.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
