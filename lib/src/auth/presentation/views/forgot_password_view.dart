import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';

// Forgot-password screen — brought in line with the new login_view.dart /
// register_view.dart design (same local-palette convention, same gradient,
// same logo widget and field styling).
class _Palette {
  _Palette._();

  static const purple = Color(0xFF4B0070);
  static const heading = Color(0xFF353037);
  static const gradientLilac = Color(0xFFF1D9FF);
}

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  static const _brandColor = _Palette.purple;

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
            // Same lilac → white gradient as login_view.dart /
            // register_view.dart.
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_Palette.gradientLilac, Colors.white],
                stops: [0.0, 0.4],
              ),
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                // Centers the form vertically on tall screens, while
                // still scrolling normally if content (or the
                // keyboard) needs more room than the screen provides.
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
                          const AppLogo(size: 96),
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
                            "We'll send instructions if an account exists for that mail",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
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
                              hint: 'yourcompany@gmail.com',
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
                                  borderRadius: BorderRadius.circular(30),
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
                                  WidgetSpan(
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
