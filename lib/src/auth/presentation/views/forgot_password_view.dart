import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/theme/app_colors.dart';
import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/tenant/tenant.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});
  static const _brandColor = Color(0xFF2A2F7A);

  // Same palette used by SiteDetailsSection / LoginView's dropdown picker,
  // so all three look identical.
  static const _textColor = Color(0xff1A1A1A);

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
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _brandColor, width: 2),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF0A2540),
          fontWeight: FontWeight.w600,
          fontSize: 14.5,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Organization dropdown — inline picker, same pattern as LoginView
  // ---------------------------------------------------------------------

  Widget _buildOrganizationField(
    BuildContext context, {
    required AuthController controller,
    required TenantController tenantController,
  }) {
    return Obx(() {
      final tenants = tenantController.tenants;
      final isLoading = tenantController.isLoading.value;
      final selectedCode = controller.selectedTenantCode.value;

      final currentValue = tenants.any((t) => (t.code) == selectedCode)
          ? selectedCode
          : null;

      return DropdownButtonFormField<String>(
        initialValue: currentValue,
        isExpanded: true,
        icon: isLoading
            ? const Padding(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : const Icon(Icons.keyboard_arrow_down),
        style: const TextStyle(fontSize: 16, color: _textColor),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        hint: const Text('Select organization'),
        decoration: _buildFieldDecoration(hint: 'Select organization'),
        items: [
          for (final tenant in tenants)
            DropdownMenuItem(value: tenant.code, child: Text(tenant.name)),
        ],
        onChanged: isLoading
            ? null
            : (value) {
                if (value != null) controller.selectedTenantCode.value = value;
              },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tenantController = Get.find<TenantController>();
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Full-screen white backdrop
          Positioned.fill(child: Container(color: Colors.white)),

          /// COLORED HEADER — pinned to top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.gradientTop,
                      AppColors.gradientMiddle,
                      AppColors.gradientBottom,
                    ],
                    stops: [0.0, 0.45, 1.0],
                  ),
                ),
                child: Stack(
                  children: [
                    /// LEFT BIG CIRCLE
                    Positioned(
                      left: -204,
                      top: 125,
                      child: Container(
                        width: 275.32,
                        height: 275.32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.circleLarge.withOpacity(.075),
                        ),
                      ),
                    ),

                    /// TOP RIGHT CIRCLES
                    Positioned(
                      right: -110,
                      top: -15,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 222,
                            height: 222,
                            child: CustomPaint(
                              painter: DottedCirclePainter(
                                color: AppColors.accent.withOpacity(.17),
                                strokeWidth: 1,
                                dashLength: 6,
                                spaceLength: 7,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.circleLarge.withOpacity(.04),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.circleLarge.withOpacity(.045),
                            ),
                          ),
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.circleLarge.withOpacity(.075),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// SMALL RING CIRCLE
                    Positioned(
                      right: 10,
                      top: 280,
                      child: CustomPaint(
                        size: const Size(100, 100),
                        painter: DottedCirclePainter(
                          color: AppColors.primaryLight.withOpacity(0.08),
                          strokeWidth: 1.0,
                          dashLength: 8.0,
                          spaceLength: 8.0,
                        ),
                      ),
                    ),

                    /// HEADER CONTENT
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              'Reset Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "You'll reset your password within a click",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.75),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// WHITE CARD — Figma: x:-1, y:303, w:413, h:614 on a 412x917 frame
          Positioned(
            left: size.width * (-1 / 412),
            top: size.height * (303 / 917),
            width: size.width * (413 / 412),
            height: size.height * (614 / 917),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2540),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "We'll send instructions if an account exists for that mail",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _fieldLabel('Organization'),
                    const SizedBox(height: 8),
                    _buildOrganizationField(
                      context,
                      controller: controller,
                      tenantController: tenantController,
                    ),

                    const SizedBox(height: 20),
                    _fieldLabel('Email Address'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildFieldDecoration(
                        hint: 'yourcompany@gmail.com',
                      ),
                    ),
                    const SizedBox(height: 28),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.forgotPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _brandColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Send reset link',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text.rich(
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
