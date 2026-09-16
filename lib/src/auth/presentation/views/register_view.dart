import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import '../controllers/auth_controller.dart';
import '../widgets/app_logo.dart';

/// Register — Figma Campaign App 711:985 (green brand system).
class _Palette {
  _Palette._();

  static const brand = AppColors.onboardingGreen;
  static const heading = AppColors.onboardingTitle;
  static const subtitle = Color(0xFF7B7B7B);
  static const label = AppColors.heading;
  static const gradientTop = AppColors.onboardingBgTop;
}

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  static const _brandColor = _Palette.brand;

  InputDecoration _buildFieldDecoration({
    required String hint,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: _Palette.subtitle,
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _brandColor, width: 2),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: _Palette.label,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _errorMessage(String? message, double scale) {
    if (message == null || message.isEmpty) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Container(
        key: ValueKey(message),
        margin: EdgeInsets.only(top: 12 * scale),
        padding: EdgeInsets.symmetric(
          horizontal: 14 * scale,
          vertical: 12 * scale,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22 * scale,
              height: 22 * scale,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFFCA5A5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 14 * scale,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10 * scale),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: const Color(0xFFB91C1C),
                  fontSize: 13 * scale,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = MediaQuery.sizeOf(context).height;
          final scale = (screenHeight / 812).clamp(0.75, 1.0);

          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_Palette.gradientTop, Colors.white],
                stops: [0.0, 0.4],
              ),
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      32 * scale,
                      24,
                      32 * scale,
                    ),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppLogo(),
                          Text(
                            'Create Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _Palette.heading,
                              fontWeight: FontWeight.w800,
                              fontSize: 24 * scale,
                              height: 1.0,
                            ),
                          ),
                          SizedBox(height: 8 * scale),
                          SizedBox(
                            width: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Sign up now to start earning cashbacks in NPR!',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                  color: _Palette.subtitle,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 32 * scale),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _fieldLabel('FULL NAME'),
                          ),
                          SizedBox(height: 8 * scale),
                          TextField(
                            controller: controller.fullNameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: _buildFieldDecoration(hint: 'John Doe'),
                          ),
                          SizedBox(height: 18 * scale),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _fieldLabel('EMAIL ADDRESS'),
                          ),
                          SizedBox(height: 8 * scale),
                          TextField(
                            controller: controller.registerEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _buildFieldDecoration(
                              hint: 'john.doe@example.com',
                            ),
                          ),
                          // SizedBox(height: 18 * scale),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: _fieldLabel('PHONE NUMBER'),
                          // ),
                          // SizedBox(height: 8 * scale),
                          // TextField(
                          //   controller: controller.phoneController,
                          //   keyboardType: TextInputType.phone,
                          //   decoration: _buildFieldDecoration(
                          //     hint: '9XXXXXXXXX',
                          //     prefixIcon: Padding(
                          //       padding: const EdgeInsets.only(
                          //         left: 18,
                          //         right: 10,
                          //       ),
                          //       child: Text(
                          //         '+977',
                          //         style: TextStyle(
                          //           color: Colors.grey.shade700,
                          //           fontWeight: FontWeight.w600,
                          //           fontSize: 15,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 18 * scale),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _fieldLabel('PASSWORD'),
                          ),
                          SizedBox(height: 8 * scale),
                          TextField(
                            controller: controller.registerPasswordController,
                            obscureText:
                                controller.obscureRegisterPassword.value,
                            decoration: _buildFieldDecoration(
                              hint: '••••••',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscureRegisterPassword.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey.shade500,
                                ),
                                onPressed:
                                    controller.toggleRegisterPasswordVisibility,
                              ),
                            ),
                          ),
                          SizedBox(height: 18 * scale),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _fieldLabel('CONFIRM PASSWORD'),
                          ),
                          SizedBox(height: 8 * scale),
                          TextField(
                            controller: controller.confirmPasswordController,
                            obscureText:
                                controller.obscureConfirmPassword.value,
                            decoration: _buildFieldDecoration(
                              hint: '••••••',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscureConfirmPassword.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey.shade500,
                                ),
                                onPressed:
                                    controller.toggleConfirmPasswordVisibility,
                              ),
                            ),
                          ),
                          _errorMessage(
                            controller.registerErrorMessage.value,
                            scale,
                          ),
                          SizedBox(height: 28 * scale),
                          SizedBox(
                            width: double.infinity,
                            height: 56 * scale,
                            child: ElevatedButton(
                              onPressed: controller.isRegistering.value
                                  ? null
                                  : () {
                                      FocusScope.of(context).unfocus();
                                      controller.register();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _brandColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: controller.isRegistering.value
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'Create free account',
                                      style: TextStyle(
                                        fontSize: 16 * scale,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 20 * scale),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14 * scale,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Already Have an Account ? ',
                                  ),
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: _brandColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
