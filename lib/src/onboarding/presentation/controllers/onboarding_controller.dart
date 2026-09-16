import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  static const int totalPages = 3;

  void onPageChanged(int index) => currentPage.value = index;

  void next() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void skip() => _finish();

  Future<void> _finish() async {
    // Persist so splash never sends this device back to onboarding.
    final storage = Get.find<AuthStorageService>();
    await storage.setFirstLaunchCompleted();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
