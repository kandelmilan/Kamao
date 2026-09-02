import 'package:get/get.dart';
import 'package:kamao/app/bindings/initial_bindings/api_binding.dart';
import 'package:kamao/app/bindings/initial_bindings/auth_dependency_binding.dart';
import 'package:kamao/app/bindings/initial_bindings/session_binding.dart';
import 'package:kamao/app/bindings/initial_bindings/storage_binding.dart';
import 'package:kamao/app/bindings/initial_bindings/tenant_dependency_binding.dart';
import 'package:kamao/src/home/home.dart';
import 'package:kamao/src/main_nav/main_nav.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core
    print('dependencies() start');
    StorageBinding().dependencies();
    ApiBinding().dependencies();
    AuthDependencyBinding().dependencies();
    TenantDependencyBinding().dependencies();
    MainNavBinding().dependencies();
    SessionBinding().dependencies();
    HomeBinding().dependencies();
    print('dependencies() end');
  }
}
