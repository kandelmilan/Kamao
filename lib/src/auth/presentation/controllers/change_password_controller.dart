import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordController(this._changePasswordUseCase);

  final ChangePasswordUseCase _changePasswordUseCase;

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscureCurrent = true.obs;
  final obscureNew = true.obs;
  final obscureConfirm = true.obs;
  final isSubmitting = false.obs;
  final RxnString fieldError = RxnString();

  void toggleCurrentVisibility() => obscureCurrent.toggle();
  void toggleNewVisibility() => obscureNew.toggle();
  void toggleConfirmVisibility() => obscureConfirm.toggle();

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final current = currentPasswordController.text;
    final next = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    if (current.isEmpty) {
      fieldError.value = 'Please enter your existing password.';
      return;
    }
    if (next.isEmpty) {
      fieldError.value = 'Please enter a new password.';
      return;
    }
    if (confirm.isEmpty) {
      fieldError.value = 'Please confirm your new password.';
      return;
    }
    if (next != confirm) {
      fieldError.value = 'New passwords do not match.';
      return;
    }
    if (next == current) {
      fieldError.value =
          'New password must be different from your existing password.';
      return;
    }

    fieldError.value = null;
    isSubmitting.value = true;

    final result = await _changePasswordUseCase(
      Params(
        data: ChangePasswordRequestEntity(
          currentPassword: current,
          newPassword: next,
        ),
      ),
    );

    result.fold(
      (failure) {
        fieldError.value = failure.message;
        Get.snackbar(
          "Couldn't change password",
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: const Color(0xFF353037),
          margin: const EdgeInsets.all(16),
        );
      },
      (_) {
        Get.back();
        Get.snackbar(
          'Password updated',
          'Your password has been changed successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: const Color(0xFF353037),
          margin: const EdgeInsets.all(16),
        );
      },
    );

    isSubmitting.value = false;
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
