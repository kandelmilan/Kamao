import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

class AuthController extends GetxController {
  AuthController(
    this._loginUserUsecase,
    this._refreshTokenUsecase,
    this._getMeUsecase,
    this._forgotPasswordUseCase,
  );

  final LoginUserUsecase _loginUserUsecase;
  final RefreshTokenUseCase _refreshTokenUsecase;
  final GetMeUseCase _getMeUsecase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  // Text Controllers

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final tenantCodeController = TextEditingController();

  // Observable States

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final RxString selectedTenantCode = ''.obs;
  final loginResponse = Rxn<LoginResponseEntity>();
  final currentUser = Rxn<UserEntity>();

  // Backend login error, shown inline under the password field instead of
  // a snackbar. Null when there's nothing to show.
  final RxnString loginErrorMessage = RxnString();

  //==========================================================
  // login
  //==========================================================
  Future<void> login() async {
    // Dismiss the keyboard right away so any resulting layout resize
    // (header/body height depends on the keyboard-adjusted screen height)
    // happens instantly on tap — not later, after the error response
    // lands, which is what made the screen appear to "jump" or
    // navigate away and back.
    FocusManager.instance.primaryFocus?.unfocus();

    loginErrorMessage.value = null;

    if (selectedTenantCode.value.isEmpty) {
      Get.snackbar('Organization', 'Please select an organization.');
      return;
    }

    isLoading.value = true;

    final request = LoginRequestEntity(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      tenantCode: selectedTenantCode.value,
    );

    final result = await _loginUserUsecase(Params(data: request));

    await result.fold(
      (failure) async {
        // Inline instead of a snackbar — surfaced under the password field.
        loginErrorMessage.value = failure.message;
        // Wrong credentials shouldn't leave a stale password sitting in
        // the field — clear it so the next attempt starts fresh. Email
        // and the selected organization are left as-is since those were
        // probably correct.
        // passwordController.clear();
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
        // Wipe the form now that we're navigating away from it — nothing
        // left behind if the user ever lands back on this screen (e.g.
        // after a future logout).
        clearFields();
        await Get.offAllNamed(AppRoutes.mainNav);
      },
    );

    isLoading.value = false;
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

  //==========================================================
  // Clear Fields
  //==========================================================

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    tenantCodeController.clear();
    selectedTenantCode.value = '';
    loginErrorMessage.value = null;
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
    tenantCodeController.dispose();

    super.onClose();
  }
}
