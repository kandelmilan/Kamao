import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';

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

  void _finish() {
    Get.offNamed(AppRoutes.login); // change to your next route
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
