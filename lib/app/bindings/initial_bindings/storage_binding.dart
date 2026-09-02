
import 'package:get/get.dart';
import 'package:kamao/core/core.dart';

class StorageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthStorageService>(
      AuthStorageService(),
      permanent: true,
    );
  }
}