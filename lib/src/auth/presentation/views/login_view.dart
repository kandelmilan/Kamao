// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kamao/src/auth/auth.dart';
// import 'package:kamao/src/tenant/tenant.dart';

// // Login screen — matches Figma "Campaign App" login reference.
// // Palette kept local to this file, same convention as splash_view.dart,
// // so this screen visually belongs with the rest of the pre-auth flow.
// class _Palette {
//   _Palette._();

//   static const purple = Color(0xFF4B0070);
//   static const heading = Color(0xFF4A434D);
//   static const subtitle = Color(0xFF7B7B7B);
//   static const gradientLilac = Color(0xFFF1D9FF);
// }

// class LoginView extends GetView<AuthController> {
//   LoginView({super.key});

//   TenantController get tenantController => Get.find<TenantController>();

//   static const _brandColor = _Palette.purple;

//   InputDecoration _buildFieldDecoration({
//     required String hint,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: const TextStyle(
//         color: _Palette.subtitle,
//         fontWeight: FontWeight.w400,
//         fontSize: 15,
//       ),
//       suffixIcon: suffixIcon,
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(color: _brandColor, width: 2),
//       ),
//     );
//   }

//   Widget _fieldLabel(String label) {
//     return Text(
//       label,
//       style: const TextStyle(
//         color: _Palette.heading,
//         fontWeight: FontWeight.w700,
//         fontSize: 12,
//         // Figma spec read as 5% tracking (0.05em), not the literal 50%.
//         letterSpacing: 0.6,
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------
//   // Organization dropdown — required by AuthController.login(), which
//   // blocks submission until selectedTenantCode is set.
//   // ---------------------------------------------------------------------
//   Widget _buildOrganizationField(BuildContext context) {
//     final tenants = tenantController.tenants;
//     final isTenantLoading = tenantController.isLoading.value;
//     final selectedCode = controller.selectedTenantCode.value;

//     final currentValue = tenants.any((t) => t.code == selectedCode)
//         ? selectedCode
//         : null;

//     return DropdownButtonFormField<String>(
//       initialValue: currentValue,
//       isExpanded: true,
//       icon: isTenantLoading
//           ? const Padding(
//               padding: EdgeInsets.all(4),
//               child: SizedBox(
//                 height: 16,
//                 width: 16,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               ),
//             )
//           : const Icon(Icons.keyboard_arrow_down),
//       style: const TextStyle(
//         fontSize: 15,
//         color: _Palette.heading,
//         fontWeight: FontWeight.w400,
//       ),
//       dropdownColor: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       hint: const Text('Select organization'),
//       decoration: _buildFieldDecoration(hint: 'Select organization'),
//       items: [
//         for (final tenant in tenants)
//           DropdownMenuItem(value: tenant.code, child: Text(tenant.name)),
//       ],
//       onChanged: isTenantLoading
//           ? null
//           : (value) {
//               if (value != null) controller.selectedTenantCode.value = value;
//             },
//     );
//   }

//   Widget _loginErrorMessage(double scale) {
//     final message = controller.loginErrorMessage.value;
//     if (message == null || message.isEmpty) return const SizedBox.shrink();

//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 200),
//       child: Container(
//         key: ValueKey(message),
//         margin: EdgeInsets.only(top: 12 * scale),
//         padding: EdgeInsets.symmetric(
//           horizontal: 14 * scale,
//           vertical: 12 * scale,
//         ),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFEF2F2),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.red.withOpacity(0.06),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 22 * scale,
//               height: 22 * scale,
//               alignment: Alignment.center,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFFCA5A5),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.close_rounded,
//                 size: 14 * scale,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(width: 10 * scale),
//             Expanded(
//               child: Text(
//                 message,
//                 style: TextStyle(
//                   color: const Color(0xFFB91C1C),
//                   fontSize: 13 * scale,
//                   fontWeight: FontWeight.w600,
//                   height: 1.3,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: true,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final screenHeight = MediaQuery.sizeOf(context).height;
//           final scale = (screenHeight / 812).clamp(0.75, 1.0);

//           return DecoratedBox(
//             // Lilac → white gradient behind the header content, same
//             // approach as splash_view.dart's background.
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [_Palette.gradientLilac, Colors.white],
//                 stops: [0.0, 0.4],
//               ),
//             ),
//             child: SingleChildScrollView(
//               physics: const ClampingScrollPhysics(),
//               child: ConstrainedBox(
//                 // Ensures the form centers vertically on tall screens,
//                 // while still scrolling normally if content (or the
//                 // keyboard) needs more room than the screen provides.
//                 constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                 child: IntrinsicHeight(
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(
//                       24,
//                       20 * scale,
//                       24,
//                       40 * scale,
//                     ),
//                     child: Obx(
//                       () => Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const AppLogo(size: 96),
//                           // SizedBox(height: 20 * scale),
//                           Text.rich(
//                             TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: 'Welcome Back ',
//                                   style: TextStyle(
//                                     color: _Palette.heading,
//                                     fontWeight: FontWeight.w800,
//                                     fontSize: 24 * scale,
//                                     height: 1.0,
//                                   ),
//                                 ),
//                                 const TextSpan(
//                                   text: '👋',
//                                   style: TextStyle(fontSize: 20),
//                                 ),
//                               ],
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           SizedBox(height: 8 * scale),
//                           SizedBox(
//                             width: double.infinity,
//                             child: FittedBox(
//                               fit: BoxFit.scaleDown,
//                               child: Text(
//                                 'Log in to access your rewards, wallet & active campaigns',
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                   color: _Palette.subtitle,
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 14,
//                                   height: 1.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 30 * scale),
//                           // Align(
//                           //   alignment: Alignment.centerLeft,
//                           //   child: _fieldLabel('ORGANIZATION'),
//                           // ),
//                           // SizedBox(height: 8 * scale),
//                           // _buildOrganizationField(context),
//                           // SizedBox(height: 18 * scale),
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: _fieldLabel('EMAIL'),
//                           ),
//                           SizedBox(height: 8 * scale),
//                           TextField(
//                             controller: controller.emailController,
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: _buildFieldDecoration(
//                               hint: 'john.doe@example.com',
//                             ),
//                           ),
//                           SizedBox(height: 18 * scale),
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: _fieldLabel('PASSWORD'),
//                           ),
//                           SizedBox(height: 8 * scale),
//                           TextField(
//                             controller: controller.passwordController,
//                             obscureText: controller.obscurePassword.value,
//                             decoration: _buildFieldDecoration(
//                               hint: 'Enter Your Password',
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   controller.obscurePassword.value
//                                       ? Icons.visibility_off_outlined
//                                       : Icons.visibility_outlined,
//                                   color: Colors.grey.shade500,
//                                 ),
//                                 onPressed: controller.togglePasswordVisibility,
//                               ),
//                             ),
//                           ),
//                           _loginErrorMessage(scale),
//                           SizedBox(height: 28 * scale),
//                           SizedBox(
//                             width: double.infinity,
//                             height: 56 * scale,
//                             child: ElevatedButton(
//                               onPressed: controller.isLoading.value
//                                   ? null
//                                   : () {
//                                       FocusScope.of(context).unfocus();
//                                       controller.login();
//                                     },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: _brandColor,
//                                 foregroundColor: Colors.white,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                               ),
//                               child: controller.isLoading.value
//                                   ? const SizedBox(
//                                       width: 24,
//                                       height: 24,
//                                       child: CircularProgressIndicator(
//                                         color: Colors.white,
//                                         strokeWidth: 2.5,
//                                       ),
//                                     )
//                                   : Text(
//                                       'Login',
//                                       style: TextStyle(
//                                         fontSize: 16 * scale,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           SizedBox(height: 20 * scale),
//                           TextButton(
//                             onPressed: () {
//                               FocusScope.of(context).unfocus();
//                               Get.to(() => RegisterView());
//                             },
//                             child: RichText(
//                               text: TextSpan(
//                                 style: TextStyle(
//                                   fontSize: 14 * scale,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.grey.shade600,
//                                 ),
//                                 children: [
//                                   const TextSpan(
//                                     text: "Don't Have an Account ? ",
//                                   ),
//                                   TextSpan(
//                                     text: 'Sign Up',
//                                     style: TextStyle(
//                                       color: _brandColor,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               FocusScope.of(context).unfocus();
//                               Get.to(() => ForgotPasswordView());
//                             },
//                             child: RichText(
//                               text: TextSpan(
//                                 style: TextStyle(
//                                   fontSize: 14 * scale,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.grey.shade600,
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text: 'Forget Password?',
//                                     style: TextStyle(
//                                       color: _brandColor,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/tenant/tenant.dart';

// Login screen — matches Figma "Campaign App" login reference.
// Palette kept local to this file, same convention as splash_view.dart,
// so this screen visually belongs with the rest of the pre-auth flow.
class _Palette {
  _Palette._();

  static const purple = Color(0xFF4B0070);
  static const heading = Color(0xFF4A434D);
  static const subtitle = Color(0xFF7B7B7B);
  static const gradientLilac = Color(0xFFF1D9FF);
}

class LoginView extends GetView<AuthController> {
  LoginView({super.key});

  TenantController get tenantController => Get.find<TenantController>();

  static const _brandColor = _Palette.purple;

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
        color: _Palette.heading,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        // Figma spec read as 5% tracking (0.05em), not the literal 50%.
        letterSpacing: 0.6,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Organization dropdown — required by AuthController.login(), which
  // blocks submission until selectedTenantCode is set.
  // ---------------------------------------------------------------------
  Widget _buildOrganizationField(BuildContext context) {
    final tenants = tenantController.tenants;
    final isTenantLoading = tenantController.isLoading.value;
    final selectedCode = controller.selectedTenantCode.value;

    final currentValue = tenants.any((t) => t.code == selectedCode)
        ? selectedCode
        : null;

    return DropdownButtonFormField<String>(
      initialValue: currentValue,
      isExpanded: true,
      icon: isTenantLoading
          ? const Padding(
              padding: EdgeInsets.all(4),
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : const Icon(Icons.keyboard_arrow_down),
      style: const TextStyle(
        fontSize: 15,
        color: _Palette.heading,
        fontWeight: FontWeight.w400,
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(16),
      hint: const Text('Select organization'),
      decoration: _buildFieldDecoration(hint: 'Select organization'),
      items: [
        for (final tenant in tenants)
          DropdownMenuItem(value: tenant.code, child: Text(tenant.name)),
      ],
      onChanged: isTenantLoading
          ? null
          : (value) {
              if (value != null) controller.selectedTenantCode.value = value;
            },
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
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = MediaQuery.sizeOf(context).height;
            final scale = (screenHeight / 812).clamp(0.75, 1.0);

            return DecoratedBox(
              // Lilac → white gradient behind the header content, same
              // approach as splash_view.dart's background.
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_Palette.gradientLilac, Colors.white],
                  stops: [0.0, 0.4],
                ),
              ),
              child: SingleChildScrollView(
                // Always scrollable — this is what brings the focused field
                // into view above the keyboard.
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  // IMPORTANT: minHeight uses the full screen height
                  // (MediaQuery.sizeOf), NOT constraints.maxHeight. With
                  // resizeToAvoidBottomInset: true, constraints.maxHeight
                  // shrinks every time the keyboard opens, which would
                  // recompute the Column's centered position each time and
                  // make the logo visibly jump. Anchoring to the full,
                  // keyboard-independent screen height keeps the centered
                  // layout fixed — the ScrollView (not re-centering) is
                  // what handles bringing the focused field into view.
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
                            const AppLogo(size: 96),
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
                            // Align(
                            //   alignment: Alignment.centerLeft,
                            //   child: _fieldLabel('ORGANIZATION'),
                            // ),
                            // SizedBox(height: 8 * scale),
                            // _buildOrganizationField(context),
                            // SizedBox(height: 18 * scale),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: _fieldLabel('EMAIL'),
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
                                hint: 'Enter Your Password',
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
                                Get.to(() => RegisterView());
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14 * scale,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                  children: [
                                    const TextSpan(
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
                                Get.to(() => ForgotPasswordView());
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14 * scale,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                  children: [
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
