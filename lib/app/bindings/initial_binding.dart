import 'package:get/get.dart';
import 'package:kamao/app/bindings/initial_bindings/api_binding.dart';
import 'package:kamao/app/bindings/initial_bindings/auth_dependency_binding.dart';
import 'package:kamao/app/bindings/initial_bindings/session_binding.dart';
import 'package:kamao/app/bindings/initial_bindings/storage_binding.dart';
import 'package:kamao/app/bindings/initial_bindings/tenant_dependency_binding.dart';
import 'package:kamao/src/auth/presentation/bindings/profile_binding.dart';
import 'package:kamao/src/home/presentation/bindings/marketplace_binding.dart';
import 'package:kamao/src/wallet/presentation/bindings%20/wallet_bindings.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    StorageBinding().dependencies();
    ApiBinding().dependencies();
    AuthDependencyBinding().dependencies();
    TenantDependencyBinding().dependencies();
    SessionBinding().dependencies();
    ProfileBinding().dependencies();
    MarketplaceBinding().dependencies();
    WalletBinding().dependencies();
  }
}
