import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kamao/src/tenant/tenant.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart' show DottedCirclePainter;

// Same brand palette as login_view.dart — kept local per-file per the same
// convention used there, so Register visually matches Login exactly.
class _Palette {
  _Palette._();

  static const walletGradientStart = Color(0xFF6F338D);
  static const walletGradientMid = Color(0xFF571A78);
  static const walletGradientEnd = Color(0xFF3E0163);
  static const purple = Color(0xFF4B0070);
  static const coral = Color(0xFFFF6B6B);
  static const heading = Color(0xFF353037);
  static const ink = Color(0xFF17121A);
  static const white = Colors.white;
}

// Adjust this list to whatever account types the backend actually accepts
// for this tenant — "Creator" is confirmed from the sample request, the
// others are placeholders.
const List<String> _kAccountTypes = ['Creator'];

class RegisterView extends GetView<AuthController> {
  RegisterView({super.key});
  TenantController get tenantController => Get.find<TenantController>();

  static const _brandColor = _Palette.purple;
  static const _textColor = _Palette.ink;
  static const double _illustrationToTitleGap = 28.0;
  static const double _cardOverlap = 24.0;

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

  Widget _fieldLabel(String label, {bool required = true}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: _Palette.heading,
          fontWeight: FontWeight.w600,
          fontSize: 14.5,
        ),
        children: required
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ]
            : [],
      ),
    );
  }

  Widget _buildOrganizationField(BuildContext context) {
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

  Widget _buildAccountTypeField() {
    return Obx(() {
      final selected = controller.selectedAccountType.value;

      return DropdownButtonFormField<String>(
        initialValue: selected.isEmpty ? null : selected,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        style: const TextStyle(fontSize: 16, color: _textColor),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        hint: const Text('Select account type'),
        decoration: _buildFieldDecoration(hint: 'Select account type'),
        items: [
          for (final type in _kAccountTypes)
            DropdownMenuItem(value: type, child: Text(type)),
        ],
        onChanged: (value) {
          if (value != null) controller.selectedAccountType.value = value;
        },
      );
    });
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
              color: Colors.red.withOpacity(0.06),
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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final topPadding = MediaQuery.of(context).padding.top;

            final screenHeight = MediaQuery.sizeOf(context).height;
            final scale = (screenHeight / 812).clamp(0.6, 1.0);

            final headerVerticalPadding = 24.0 * scale;
            final fieldSpacing = 18.0 * scale;
            final sectionSpacing = 20.0 * scale;
            // Same reasoning as login_view.dart: tied to screenHeight, not
            // constraints.maxHeight, so the header doesn't collapse when
            // the keyboard opens.
            final headerHeight = screenHeight * 0.28 + topPadding;

            final cardTopPadding =
                (_illustrationToTitleGap -
                        headerVerticalPadding +
                        _cardOverlap * scale)
                    .clamp(8.0, 60.0);

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: headerHeight,
                    child: ClipRect(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _Palette.walletGradientStart,
                              _Palette.walletGradientMid,
                              _Palette.walletGradientEnd,
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: -204,
                              top: 100 + topPadding,
                              child: Container(
                                width: 275.32,
                                height: 275.32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _Palette.white.withOpacity(.06),
                                ),
                              ),
                            ),
                            Positioned(
                              right: -110,
                              top: -15 + topPadding,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 222,
                                    height: 222,
                                    child: CustomPaint(
                                      painter: DottedCirclePainter(
                                        color: _Palette.coral.withOpacity(.25),
                                        strokeWidth: 1,
                                        dashLength: 6,
                                        spaceLength: 7,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _Palette.white.withOpacity(
                                            .04,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _Palette.white.withOpacity(.045),
                                    ),
                                  ),
                                  Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _Palette.white.withOpacity(.07),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                24,
                                0,
                                24,
                                headerVerticalPadding,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create Account',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22 * scale,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 6 * scale),
                                    Text(
                                      'Sign up to start managing your projects',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.75),
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
                  Transform.translate(
                    offset: const Offset(0, -80),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                        24,
                        cardTopPadding,
                        24,
                        30 * scale,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(52),
                          topRight: Radius.circular(52),
                        ),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 24 * scale,
                                  fontWeight: FontWeight.bold,
                                  color: _Palette.heading,
                                ),
                              ),
                              SizedBox(height: sectionSpacing),
                              _fieldLabel('Organization'),
                              SizedBox(height: 8 * scale),
                              _buildOrganizationField(context),
                              SizedBox(height: fieldSpacing),
                              _fieldLabel('Full Name'),
                              SizedBox(height: 8 * scale),
                              TextField(
                                controller: controller.fullNameController,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                decoration: _buildFieldDecoration(
                                  hint: 'Your full name',
                                ),
                              ),
                              SizedBox(height: fieldSpacing),
                              _fieldLabel('Email Address'),
                              SizedBox(height: 8 * scale),
                              TextField(
                                controller: controller.registerEmailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _buildFieldDecoration(
                                  hint: 'yourcompany@gmail.com',
                                ),
                              ),
                              SizedBox(height: fieldSpacing),
                              _fieldLabel('Account Type'),
                              SizedBox(height: 8 * scale),
                              _buildAccountTypeField(),
                              SizedBox(height: fieldSpacing),
                              _fieldLabel('Password'),
                              SizedBox(height: 8 * scale),
                              TextField(
                                controller:
                                    controller.registerPasswordController,
                                obscureText:
                                    controller.obscureRegisterPassword.value,
                                decoration: _buildFieldDecoration(
                                  hint: 'Create a password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.obscureRegisterPassword.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey.shade600,
                                    ),
                                    onPressed: controller
                                        .toggleRegisterPasswordVisibility,
                                  ),
                                ),
                              ),
                              SizedBox(height: fieldSpacing),
                              _fieldLabel('Confirm Password'),
                              SizedBox(height: 8 * scale),
                              TextField(
                                controller:
                                    controller.confirmPasswordController,
                                obscureText:
                                    controller.obscureConfirmPassword.value,
                                decoration: _buildFieldDecoration(
                                  hint: 'Re-enter your password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.obscureConfirmPassword.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey.shade600,
                                    ),
                                    onPressed: controller
                                        .toggleConfirmPasswordVisibility,
                                  ),
                                ),
                              ),
                              SizedBox(height: fieldSpacing),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value:
                                          controller.acceptedMinimumAge.value,
                                      activeColor: _brandColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      onChanged: (value) {
                                        controller.acceptedMinimumAge.value =
                                            value ?? false;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10 * scale),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.acceptedMinimumAge.value =
                                            !controller
                                                .acceptedMinimumAge
                                                .value;
                                      },
                                      child: Text(
                                        'I confirm that I meet the minimum age requirement.',
                                        style: TextStyle(
                                          color: _Palette.heading,
                                          fontSize: 13.5 * scale,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _errorMessage(
                                controller.registerErrorMessage.value,
                                scale,
                              ),
                              SizedBox(height: sectionSpacing),
                              SizedBox(
                                width: double.infinity,
                                height: 54 * scale,
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
                                      borderRadius: BorderRadius.circular(12),
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
                                          'Create Account',
                                          style: TextStyle(
                                            fontSize: 16 * scale,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: 12 * scale),
                              Center(
                                child: TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    'Already have an account? Sign in',
                                    style: TextStyle(
                                      color: _brandColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14 * scale,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
