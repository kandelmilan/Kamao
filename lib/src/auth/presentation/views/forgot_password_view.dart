import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/auth/auth.dart';

/// Reset password — Figma Campaign App 711:1070 (green brand system).
class _Palette {
  _Palette._();

  static const brand = AppColors.onboardingGreen;
  static const heading = AppColors.heading;
  static const subtitle = Color(0xFF7B7B7B);
  static const gradientTop = AppColors.onboardingBgTop;
}

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  static const _brandColor = _Palette.brand;

  InputDecoration _buildFieldDecoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      suffixIcon: suffixIcon,
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
        color: _Palette.heading,
        fontWeight: FontWeight.w700,
        fontSize: 12.5,
        letterSpacing: 0.4,
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
                      40 * scale,
                      24,
                      32 * scale,
                    ),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppLogo(),
                          SizedBox(height: 20 * scale),
                          Text(
                            'Reset Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _Palette.heading,
                              fontWeight: FontWeight.w700,
                              fontSize: 24 * scale,
                            ),
                          ),
                          SizedBox(height: 8 * scale),
                          Text(
                            "We'll send instructions if an account exists for that email.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _Palette.subtitle,
                              fontSize: 14 * scale,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 20 * scale),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _fieldLabel('EMAIL ADDRESS'),
                          ),
                          SizedBox(height: 8 * scale),
                          TextField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _buildFieldDecoration(
                              hint: 'john.doe@example.com',
                            ),
                          ),
                          SizedBox(height: 28 * scale),
                          SizedBox(
                            width: double.infinity,
                            height: 56 * scale,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      FocusScope.of(context).unfocus();
                                      controller.forgotPassword();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _brandColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'Send reset link',
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
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 14,
                                      color: _brandColor,
                                    ),
                                    alignment: PlaceholderAlignment.middle,
                                  ),
                                  TextSpan(
                                    text: ' Back to sign in',
                                    style: TextStyle(
                                      color: _brandColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14 * scale,
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
