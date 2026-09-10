// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kamao/app/app.dart';
// import 'package:kamao/core/core.dart';
// import 'package:kamao/src/auth/auth.dart';

// class AuthController extends GetxController {
//   AuthController(
//     this._loginUserUsecase,
//     this._refreshTokenUsecase,
//     this._getMeUsecase,
//     this._forgotPasswordUseCase,
//   );

//   final LoginUserUsecase _loginUserUsecase;
//   final RefreshTokenUseCase _refreshTokenUsecase;
//   final GetMeUseCase _getMeUsecase;
//   final ForgotPasswordUseCase _forgotPasswordUseCase;
//   // Text Controllers

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final tenantCodeController = TextEditingController();

//   // Observable States

//   final isLoading = false.obs;
//   final obscurePassword = true.obs;
//   final RxString selectedTenantCode = ''.obs;
//   final loginResponse = Rxn<LoginResponseEntity>();
//   final currentUser = Rxn<UserEntity>();

//   // Backend login error, shown inline under the password field instead of
//   // a snackbar. Null when there's nothing to show.
//   final RxnString loginErrorMessage = RxnString();
//   // AuthController
//   bool get isLoggedIn => currentUser.value != null;
//   //==========================================================
//   // login
//   //==========================================================
//   Future<void> login() async {
//     // Dismiss the keyboard right away so any resulting layout resize
//     // (header/body height depends on the keyboard-adjusted screen height)
//     // happens instantly on tap — not later, after the error response
//     // lands, which is what made the screen appear to "jump" or
//     // navigate away and back.
//     FocusManager.instance.primaryFocus?.unfocus();

//     loginErrorMessage.value = null;

//     if (selectedTenantCode.value.isEmpty) {
//       Get.snackbar('Organization', 'Please select an organization.');
//       return;
//     }

//     isLoading.value = true;

//     final request = LoginRequestEntity(
//       email: emailController.text.trim(),
//       password: passwordController.text.trim(),
//       tenantCode: selectedTenantCode.value,
//     );

//     final result = await _loginUserUsecase(Params(data: request));

//     await result.fold(
//       (failure) async {
//         // Inline instead of a snackbar — surfaced under the password field.
//         loginErrorMessage.value = failure.message;
//         // Wrong credentials shouldn't leave a stale password sitting in
//         // the field — clear it so the next attempt starts fresh. Email
//         // and the selected organization are left as-is since those were
//         // probably correct.
//         // passwordController.clear();
//       },
//       (response) async {
//         loginResponse.value = response;

//         final storage = Get.find<AuthStorageService>();
//         await storage.saveLoginSession(
//           accessToken: response.data.accessToken,
//           refreshToken: response.data.refreshToken,
//           userId: response.data.userId,
//           tenantId: response.data.tenantId,
//           sessionId: response.data.sessionId,
//           roleId: response.data.roleId,
//         );

//         await getMe();
//         Get.find<InactivityService>().initialize();
//         // Wipe the form now that we're navigating away from it — nothing
//         // left behind if the user ever lands back on this screen (e.g.
//         // after a future logout).
//         clearFields();
//         await Get.offAllNamed(AppRoutes.mainNav);
//       },
//     );

//     isLoading.value = false;
//   }

//   //==========================================================
//   // refersh token
//   //==========================================================
//   Future<void> refreshToken(String refreshToken) async {
//     final request = RefreshTokenRequestEntity(refreshToken: refreshToken);

//     final result = await _refreshTokenUsecase(Params(data: request));

//     result.fold(
//       (failure) {
//         Get.snackbar('Login Failed', failure.message);
//       },
//       (response) async {
//         loginResponse.value = response;

//         final storage = Get.find<AuthStorageService>();

//         await storage.saveLoginSession(
//           accessToken: response.data.accessToken,
//           refreshToken: response.data.refreshToken,
//           userId: response.data.userId,
//           tenantId: response.data.tenantId,
//           sessionId: response.data.sessionId,
//           roleId: response.data.roleId,
//         );
//         await getMe();

//         Get.find<InactivityService>().initialize();

//         await Get.offAllNamed(AppRoutes.mainNav);
//       },
//     );
//   }

//   // Future<void> loadData() async {
//   //   // Dashboard API
//   //   // Profile API
//   //   // Notifications API
//   //   // etc.
//   // }

//   //==========================================================
//   // Get Profile
//   //==========================================================

//   Future<void> getMe() async {
//     final result = await _getMeUsecase(const NoParams());

//     result.fold(
//       (failure) {
//         Get.snackbar('Error', failure.message);
//       },
//       (user) {
//         currentUser.value = user;
//       },
//     );
//   }

//   Future<void> forgotPassword() async {
//     if (selectedTenantCode.value.isEmpty) {
//       Get.snackbar('Organization', 'Please select an organization.');
//       return;
//     }

//     isLoading.value = true;

//     final request = ForgotPasswordRequestEntity(
//       tenantCode: selectedTenantCode.value,
//       email: emailController.text.trim(),
//     );

//     final result = await _forgotPasswordUseCase(Params(data: request));

//     result.fold(
//       (failure) {
//         Get.snackbar("Forgot Password Failed", failure.message);
//       },
//       (response) {
//         Get.snackbar(
//           "Success",
//           response.message.isEmpty
//               ? "Reset instructions sent"
//               : response.message,
//         );
//       },
//     );

//     isLoading.value = false;
//   }
//   //==========================================================
//   // logout
//   //==========================================================

//   Future<void> logout() async {
//     final storage = Get.find<AuthStorageService>();

//     // Stop inactivity tracking
//     Get.find<InactivityService>().stop();

//     await storage.clearAuthData();

//     currentUser.value = null;
//     loginResponse.value = null;

//     Get.offAllNamed(AppRoutes.login);
//   }
//   //==========================================================
//   // Toggle Password
//   //==========================================================

//   void togglePasswordVisibility() {
//     obscurePassword.value = !obscurePassword.value;
//   }

//   //==========================================================
//   // Clear Fields
//   //==========================================================

//   void clearFields() {
//     emailController.clear();
//     passwordController.clear();
//     tenantCodeController.clear();
//     selectedTenantCode.value = '';
//     loginErrorMessage.value = null;
//   }

//   @override
//   void onInit() {
//     super.onInit();

//     // loadData();
//   }

//   //==========================================================
//   // Dispose
//   //==========================================================

//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     tenantCodeController.dispose();

//     super.onClose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

class AuthController extends GetxController {
  AuthController(
    this._loginUserUsecase,
    this._registerUserUsecase,
    this._refreshTokenUsecase,
    this._getMeUsecase,
    this._forgotPasswordUseCase,
  );

  final LoginUserUsecase _loginUserUsecase;
  final RegisterUserUsecase _registerUserUsecase;
  final RefreshTokenUseCase _refreshTokenUsecase;
  final GetMeUseCase _getMeUsecase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  // Text Controllers

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final tenantCodeController = TextEditingController();

  // Register-only text controllers. Kept separate from the login ones above
  // so switching between the two screens never leaves stale text behind.
  final fullNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable States

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final RxString selectedTenantCode = ''.obs;
  final loginResponse = Rxn<LoginResponseEntity>();
  final currentUser = Rxn<UserEntity>();

  // Backend login error, shown inline under the password field instead of
  // a snackbar. Null when there's nothing to show.
  final RxnString loginErrorMessage = RxnString();

  // Register-only observable state, mirroring the login ones above.
  final isRegistering = false.obs;
  final obscureRegisterPassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final RxString selectedAccountType = ''.obs;
  final RxBool acceptedMinimumAge = true.obs;
  final registerResponse = Rxn<RegisterResponseEntity>();
  final RxnString registerErrorMessage = RxnString();

  // AuthController
  bool get isLoggedIn => currentUser.value != null;
  //==========================================================
  // login
  //==========================================================
  // Future<void> login() async {
  //   // Dismiss the keyboard right away so any resulting layout resize
  //   // (header/body height depends on the keyboard-adjusted screen height)
  //   // happens instantly on tap — not later, after the error response
  //   // lands, which is what made the screen appear to "jump" or
  //   // navigate away and back.
  //   FocusManager.instance.primaryFocus?.unfocus();

  //   loginErrorMessage.value = null;

  //   if (selectedTenantCode.value.isEmpty) {
  //     Get.snackbar('Organization', 'Please select an organization.');
  //     return;
  //   }

  //   isLoading.value = true;

  //   final request = LoginRequestEntity(
  //     email: emailController.text.trim(),
  //     password: passwordController.text.trim(),
  //     tenantCode: selectedTenantCode.value,
  //   );

  //   final result = await _loginUserUsecase(Params(data: request));

  //   await result.fold(
  //     (failure) async {
  //       // Inline instead of a snackbar — surfaced under the password field.
  //       loginErrorMessage.value = failure.message;
  //       // Wrong credentials shouldn't leave a stale password sitting in
  //       // the field — clear it so the next attempt starts fresh. Email
  //       // and the selected organization are left as-is since those were
  //       // probably correct.
  //       // passwordController.clear();
  //     },
  //     (response) async {
  //       loginResponse.value = response;

  //       final storage = Get.find<AuthStorageService>();
  //       await storage.saveLoginSession(
  //         accessToken: response.data.accessToken,
  //         refreshToken: response.data.refreshToken,
  //         userId: response.data.userId,
  //         tenantId: response.data.tenantId,
  //         sessionId: response.data.sessionId,
  //         roleId: response.data.roleId,
  //       );

  //       await getMe();
  //       Get.find<InactivityService>().initialize();
  //       // Wipe the form now that we're navigating away from it — nothing
  //       // left behind if the user ever lands back on this screen (e.g.
  //       // after a future logout).
  //       clearFields();
  //       await Get.offAllNamed(AppRoutes.mainNav);
  //     },
  //   );

  //   isLoading.value = false;
  // }

  //==========================================================
  // register
  //==========================================================
  // Future<void> register() async {
  //   // Same reasoning as login(): drop the keyboard first so the
  //   // keyboard-driven layout resize doesn't fight with the error message
  //   // that's about to appear.
  //   FocusManager.instance.primaryFocus?.unfocus();

  //   registerErrorMessage.value = null;

  //   if (selectedTenantCode.value.isEmpty) {
  //     Get.snackbar('Organization', 'Please select an organization.');
  //     return;
  //   }

  //   if (fullNameController.text.trim().isEmpty) {
  //     Get.snackbar('Full Name', 'Please enter your full name.');
  //     return;
  //   }

  //   // if (selectedAccountType.value.isEmpty) {
  //   //   Get.snackbar('Account Type', 'Please select an account type.');
  //   //   return;
  //   // }

  //   if (registerPasswordController.text != confirmPasswordController.text) {
  //     // Client-side only — the API itself doesn't take a confirmation
  //     // field, so this never leaves the device.
  //     registerErrorMessage.value = 'Passwords do not match.';
  //     return;
  //   }

  //   if (!acceptedMinimumAge.value) {
  //     Get.snackbar(
  //       'Age Confirmation',
  //       'Please confirm you meet the minimum age requirement.',
  //     );
  //     return;
  //   }

  //   isRegistering.value = true;

  //   final request = RegisterRequestEntity(
  //     // tenantCode: selectedTenantCode.value,
  //     fullName: fullNameController.text.trim(),
  //     email: registerEmailController.text.trim(),
  //     password: registerPasswordController.text.trim(),
  //     // accountType: selectedAccountType.value,
  //     acceptedMinimumAge: acceptedMinimumAge.value,
  //   );

  //   final result = await _registerUserUsecase(Params(data: request));

  //   result.fold(
  //     (failure) {
  //       registerErrorMessage.value = failure.message;
  //     },
  //     (response) {
  //       registerResponse.value = response;

  //       // Deliberately NOT persisting the returned tokens or auto-logging
  //       // in here, even though the API returns a full access/refresh
  //       // token pair just like login does. Product wants a fresh, empty
  //       // Login screen after registering — not to be dropped straight
  //       // into the app. Both forms are cleared so nothing lingers if the
  //       // user navigates back to either screen later.
  //       clearFields();
  //       clearRegisterFields();

  //       Get.snackbar(
  //         'Account Created',
  //         'Your account has been created. Please sign in.',
  //       );

  //       Get.offAllNamed(AppRoutes.login);
  //     },
  //   );

  //   isRegistering.value = false;
  // }

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    loginErrorMessage.value = null;

    isLoading.value = true;

    final request = LoginRequestEntity(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      // tenantCode defaults to 'Demo'
    );

    final result = await _loginUserUsecase(Params(data: request));

    await result.fold(
      (failure) async {
        loginErrorMessage.value = failure.message;
      },
      (response) async {
        loginResponse.value = response;

        final storage = Get.find<AuthStorageService>();
        await storage.saveLoginSession(
          accessToken: response.data.accessToken,
          refreshToken: response.data.refreshToken,
          userId: response.data.userId,
          tenantId: response.data.tenantId,
          sessionId: response.data.sessionId,
          roleId: response.data.roleId,
        );

        await getMe();
        Get.find<InactivityService>().initialize();
        clearFields();
        await Get.offAllNamed(AppRoutes.mainNav);
      },
    );

    isLoading.value = false;
  }

  Future<void> register() async {
    FocusManager.instance.primaryFocus?.unfocus();

    registerErrorMessage.value = null;

    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar('Full Name', 'Please enter your full name.');
      return;
    }

    if (registerPasswordController.text != confirmPasswordController.text) {
      registerErrorMessage.value = 'Passwords do not match.';
      return;
    }

    if (!acceptedMinimumAge.value) {
      Get.snackbar(
        'Age Confirmation',
        'Please confirm you meet the minimum age requirement.',
      );
      return;
    }

    isRegistering.value = true;

    final request = RegisterRequestEntity(
      // tenantCode defaults to 'Demo', accountType defaults to 'Creator'
      fullName: fullNameController.text.trim(),
      email: registerEmailController.text.trim(),
      password: registerPasswordController.text.trim(),
      acceptedMinimumAge: acceptedMinimumAge.value,
    );

    final result = await _registerUserUsecase(Params(data: request));

    result.fold(
      (failure) {
        registerErrorMessage.value = failure.message;
      },
      (response) {
        registerResponse.value = response;
        clearFields();
        clearRegisterFields();

        Get.snackbar(
          'Account Created',
          'Your account has been created. Please sign in.',
        );

        Get.offAllNamed(AppRoutes.login);
      },
    );

    isRegistering.value = false;
  }

  //==========================================================
  // refersh token
  //==========================================================
  Future<void> refreshToken(String refreshToken) async {
    final request = RefreshTokenRequestEntity(refreshToken: refreshToken);

    final result = await _refreshTokenUsecase(Params(data: request));

    result.fold(
      (failure) {
        Get.snackbar('Login Failed', failure.message);
      },
      (response) async {
        loginResponse.value = response;

        final storage = Get.find<AuthStorageService>();

        await storage.saveLoginSession(
          accessToken: response.data.accessToken,
          refreshToken: response.data.refreshToken,
          userId: response.data.userId,
          tenantId: response.data.tenantId,
          sessionId: response.data.sessionId,
          roleId: response.data.roleId,
        );
        await getMe();

        Get.find<InactivityService>().initialize();

        await Get.offAllNamed(AppRoutes.mainNav);
      },
    );
  }

  // Future<void> loadData() async {
  //   // Dashboard API
  //   // Profile API
  //   // Notifications API
  //   // etc.
  // }

  //==========================================================
  // Get Profile
  //==========================================================

  Future<void> getMe() async {
    final result = await _getMeUsecase(const NoParams());

    result.fold(
      (failure) {
        Get.snackbar('Error', failure.message);
      },
      (user) {
        currentUser.value = user;
      },
    );
  }

  Future<void> forgotPassword() async {
    if (selectedTenantCode.value.isEmpty) {
      Get.snackbar('Organization', 'Please select an organization.');
      return;
    }

    isLoading.value = true;

    final request = ForgotPasswordRequestEntity(
      tenantCode: selectedTenantCode.value,
      email: emailController.text.trim(),
    );

    final result = await _forgotPasswordUseCase(Params(data: request));

    result.fold(
      (failure) {
        Get.snackbar("Forgot Password Failed", failure.message);
      },
      (response) {
        Get.snackbar(
          "Success",
          response.message.isEmpty
              ? "Reset instructions sent"
              : response.message,
        );
      },
    );

    isLoading.value = false;
  }
  //==========================================================
  // logout
  //==========================================================

  Future<void> logout() async {
    final storage = Get.find<AuthStorageService>();

    // Stop inactivity tracking
    Get.find<InactivityService>().stop();

    await storage.clearAuthData();

    currentUser.value = null;
    loginResponse.value = null;

    Get.offAllNamed(AppRoutes.login);
  }
  
  
  //==========================================================
  // Toggle Password
  //==========================================================

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRegisterPasswordVisibility() {
    obscureRegisterPassword.value = !obscureRegisterPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  //==========================================================
  // Clear Fields
  //==========================================================

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    // tenantCodeController.clear();
    // selectedTenantCode.value = '';
    loginErrorMessage.value = null;
  }

  void clearRegisterFields() {
    fullNameController.clear();
    registerEmailController.clear();
    registerPasswordController.clear();
    confirmPasswordController.clear();
    // selectedAccountType.value = '';
    acceptedMinimumAge.value = false;
    registerErrorMessage.value = null;
  }

  @override
  void onInit() {
    super.onInit();

    // loadData();
  }

  //==========================================================
  // Dispose
  //==========================================================

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    // tenantCodeController.dispose();
    fullNameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
