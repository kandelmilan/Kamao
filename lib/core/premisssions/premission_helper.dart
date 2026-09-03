import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';

bool userHasPermission(String permission) {
  final user = Get.find<AuthController>().currentUser.value;
  return user?.permissions.contains(permission) ?? false;
}

bool userHasAnyPermission(Iterable<String> anyOf) {
  final user = Get.find<AuthController>().currentUser.value;
  if (user == null) return false;
  return anyOf.any(user.permissions.contains);
}
