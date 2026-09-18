import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/auth/presentation/controllers/change_password_controller.dart';
import 'package:kamao/src/help_support/presentation/widgets/support_ui.dart';
import 'package:remixicon/remixicon.dart';

/// Change password — Figma Campaign App 965:1181.
class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Color(0xFFFAFAF9))),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.onboardingBgTop,
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const _ChangePasswordHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF2F5F9)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A1A153B),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Obx(
                            () => _PasswordField(
                              label: 'ENTER EXISTING PASSWORD',
                              controller: controller.currentPasswordController,
                              obscure: controller.obscureCurrent.value,
                              onToggle: controller.toggleCurrentVisibility,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => _PasswordField(
                              label: 'ENTER NEW PASSWORD',
                              controller: controller.newPasswordController,
                              obscure: controller.obscureNew.value,
                              onToggle: controller.toggleNewVisibility,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => _PasswordField(
                              label: 'CONFIRM NEW PASSWORD',
                              controller: controller.confirmPasswordController,
                              obscure: controller.obscureConfirm.value,
                              onToggle: controller.toggleConfirmVisibility,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => controller.submit(),
                            ),
                          ),
                          Obx(() {
                            final err = controller.fieldError.value;
                            if (err == null || err.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                err,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFDC2626),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 24),
                          Obx(() {
                            final busy = controller.isSubmitting.value;
                            return SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: busy ? null : controller.submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.walletButton,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: AppColors
                                      .walletButton
                                      .withValues(alpha: 0.5),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: busy
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordHeader extends StatelessWidget {
  const _ChangePasswordHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              RemixIcons.arrow_left_s_line,
              size: 28,
              color: AppColors.heading,
            ),
          ),
          const Expanded(
            child: Text(
              'Change Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: Color(0xFF6E6971),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.heading,
          ),
          decoration: supportInputDecoration(
            hint: '',
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? RemixIcons.eye_off_line
                    : RemixIcons.eye_line,
                size: 20,
                color: const Color(0xFF8A9A86),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
