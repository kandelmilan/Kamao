import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/src/help_support/domain/usecases/create_support_ticket_usecase.dart';

class RaiseTicketController extends GetxController {
  RaiseTicketController(this._createSupportTicketUseCase);

  final CreateSupportTicketUseCase _createSupportTicketUseCase;

  static const priorities = ['Low', 'Medium', 'High', 'Critical'];

  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxString priority = 'Medium'.obs;
  final RxBool isSubmitting = false.obs;
  final RxnString fieldError = RxnString();

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    final subject = subjectController.text.trim();
    final description = descriptionController.text.trim();

    if (subject.isEmpty) {
      fieldError.value = 'Please enter a subject.';
      return;
    }
    if (description.isEmpty) {
      fieldError.value = 'Please enter a description.';
      return;
    }

    fieldError.value = null;
    isSubmitting.value = true;

    final result = await _createSupportTicketUseCase(
      CreateSupportTicketParams(
        subject: subject,
        description: description,
        priority: priority.value,
      ),
    );

    result.fold(
      (failure) {
        fieldError.value = failure.message;
        Get.snackbar(
          "Couldn't submit ticket",
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
          'Ticket submitted',
          'Your support ticket has been raised successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: const Color(0xFF353037),
          margin: const EdgeInsets.all(16),
        );
      },
    );

    isSubmitting.value = false;
  }
}
