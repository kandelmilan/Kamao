import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';

/// Reads straight off your existing AuthController.currentUser (populated
/// by AuthController.getMe(), which already runs right after login/token
/// refresh — see auth_controller.dart). No separate session state is kept
/// here; this is just a query helper.
///
/// This is UX polish on top of what the server already enforces — a 403
/// from the API is still the real security boundary, not this check.
bool userHasPermission(String permission) {
  final user = Get.find<AuthController>().currentUser.value;
  return user?.permissions.contains(permission) ?? false;
}

bool userHasAnyPermission(Iterable<String> anyOf) {
  final user = Get.find<AuthController>().currentUser.value;
  if (user == null) return false;
  return anyOf.any(user.permissions.contains);
}
