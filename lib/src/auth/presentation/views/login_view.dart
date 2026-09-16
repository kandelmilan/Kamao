import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/auth/auth.dart';

/// Login — Figma Campaign App 711:1033 (green brand system).
class _Palette {
  _Palette._();

  static const brand = AppColors.onboardingGreen;
  static const heading = AppColors.onboardingTitle;
  static const subtitle = Color(0xFF7B7B7B);
  static const label = AppColors.heading;
  static const gradientTop = AppColors.onboardingBgTop;
}

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  static const _brandColor = _Palette.brand;

  InputDecoration _buildFieldDecoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: _Palette.subtitle,
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
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
        color: _Palette.label,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _loginErrorMessage(double scale) {
    final message = controller.loginErrorMessage.value;
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
      body: Center(
        child: LayoutBuilder(
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
                  constraints: BoxConstraints(minHeight: screenHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        20 * scale,
                        24,
                        40 * scale,
                      ),
                      child: Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const AppLogo(),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Welcome Back ',
                                    style: TextStyle(
                                      color: _Palette.heading,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 24 * scale,
                                      height: 1.0,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '👋',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8 * scale),
                            SizedBox(
                              width: double.infinity,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Log in to access your rewards, wallet & active campaigns',
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
                            SizedBox(height: 30 * scale),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: _fieldLabel('EMAIL '),
                            ),
                            SizedBox(height: 8 * scale),
                            TextField(
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _buildFieldDecoration(
                                hint: 'john.doe@example.com',
                              ),
                            ),
                            SizedBox(height: 18 * scale),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: _fieldLabel('PASSWORD'),
                            ),
                            SizedBox(height: 8 * scale),
                            TextField(
                              controller: controller.passwordController,
                              obscureText: controller.obscurePassword.value,
                              decoration: _buildFieldDecoration(
                                hint: '••••••',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscurePassword.value
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey.shade500,
                                  ),
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                ),
                              ),
                            ),
                            _loginErrorMessage(scale),
                            SizedBox(height: 28 * scale),
                            SizedBox(
                              width: double.infinity,
                              height: 56 * scale,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () {
                                        FocusScope.of(context).unfocus();
                                        controller.login();
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
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 16 * scale,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 20 * scale),
                            TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                Get.to(() => const RegisterView());
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14 * scale,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: "Don't Have an Account ? ",
                                    ),
                                    TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                        color: _brandColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                Get.to(() => const ForgotPasswordView());
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14 * scale,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'Forget Password?',
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
      ),
    );
  }
}
