import 'package:get/get.dart';
import 'package:kamao/core/core.dart';

class ApiBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiConfig>(ApiConfig(), permanent: true);
    Get.put<ApiService>(ApiService(Get.find<ApiConfig>().dio), permanent: true);
  }
}
