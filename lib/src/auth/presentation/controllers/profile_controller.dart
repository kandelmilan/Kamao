import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/social_connections/presentation/controllers/social_connections_controller.dart';

class ProfileController extends GetxController {
  ProfileController(
    this._getCreatorProfileUseCase,
    this._uploadAvatarUseCase,
    this._deleteAvatarUseCase,
  );

  final GetCreatorProfileUseCase _getCreatorProfileUseCase;
  final UploadAvatarUseCase _uploadAvatarUseCase;
  final DeleteAvatarUseCase _deleteAvatarUseCase;

  final Rxn<ProfileEntity> profile = Rxn<ProfileEntity>();
  final RxBool isLoading = false.obs;
  final RxBool isAvatarBusy = false.obs;
  final RxnString error = RxnString();
  final currentUser = Rxn<UserEntity>();
  final loginResponse = Rxn<LoginResponseEntity>();

  final _picker = ImagePicker();

  Future<void> loadProfile() async {
    isLoading.value = true;
    error.value = null;

    // Keep `/auth/me` avatar in sync for home + profile headers.
    if (Get.isRegistered<AuthController>()) {
      await Get.find<AuthController>().getMe();
    }

    final result = await _getCreatorProfileUseCase(const NoParams());

    result.fold(
      (failure) => error.value = failure.message,
      (data) {
        profile.value = data;
        if (Get.isRegistered<SocialConnectionsController>()) {
          Get.find<SocialConnectionsController>()
              .applyNeedsSocialConnect(data.needsSocialConnect);
        }
      },
    );

    isLoading.value = false;
  }

  Future<void> refreshProfile() => loadProfile();

  /// Figma profile metrics use the currency code + grouped amount
  /// (e.g. "NPR 12,450.00"), not a localized symbol.
  String _money(double amount, {int decimals = 2}) {
    final insights = profile.value?.insights;
    if (insights == null) return '—';
    final code = insights.currency.toUpperCase();
    final fixed = amount.toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    final formatted =
        decimals > 0 && parts.length > 1 ? '$whole.${parts[1]}' : whole;
    return '$code $formatted';
  }

  String get formattedWalletBalance => profile.value == null
      ? '—'
      : _money(profile.value!.insights.walletBalance);

  String get formattedTotalRewarded => profile.value == null
      ? '—'
      : _money(profile.value!.insights.totalRewarded);

  String get formattedTotalWithdrawn => profile.value == null
      ? '—'
      : _money(profile.value!.insights.totalWithdrawn);

  String get formattedAveragePostReward => profile.value == null
      ? '—'
      : _money(profile.value!.insights.averagePostReward);

  int get totalPostCount {
    final insights = profile.value?.insights;
    if (insights == null) return 0;
    return insights.postsTotal;
  }

  int get rewardedPostCount {
    final insights = profile.value?.insights;
    if (insights == null) return 0;
    return insights.postsRewarded > 0
        ? insights.postsRewarded
        : insights.rewardedPostCount;
  }

  // ---------------------------------------------------------------------
  // Identity / avatar — sourced from `/auth/me` via [AuthController]
  // ---------------------------------------------------------------------

  AuthController? get _auth =>
      Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;

  /// Raw path from `/auth/me` (may be relative).
  String? get avatarPath => _auth?.avatarPath;

  bool get hasAvatar => _auth?.hasAvatar ?? false;

  /// Absolute URL for widgets — always via [resolveImageUrl].
  String? get avatarUrl => _auth?.avatarUrl;

  String get displayName {
    final user = profile.value?.user;
    if (user == null) return '';
    return user.fullName.isNotEmpty ? user.fullName : user.userName;
  }

  String get username => profile.value?.user.userName ?? '';

  /// Current creator level display name from `progress.progress`
  /// (e.g. "Elite"). Empty when profile / progress is not loaded.
  String get levelName => profile.value?.levelName ?? '';

  /// Current creator level code from `progress.progress` (e.g. "elite").
  String get levelCode => profile.value?.levelCode ?? '';

  /// Label next to `@username` — always "Creator" per profile Figma.
  String get roleLabel => 'Creator';

  /// Profile header badge text, e.g. "Elite Creator".
  String get levelBadgeLabel {
    final level = levelName;
    if (level.isEmpty) return '';
    return '$level Creator';
  }

  void openCreatorLevels() {
    Get.toNamed(AppRoutes.creatorLevels);
  }

  int get connectedAccountsCount =>
      profile.value?.connections.where((c) => c.isConnected).length ?? 0;

  bool get needsSocialConnect =>
      profile.value?.needsSocialConnect ??
      (Get.isRegistered<SocialConnectionsController>()
          ? Get.find<SocialConnectionsController>().needsSocialConnect.value
          : false);

  ProfileConnectionEntity? connectionFor(String platform) =>
      profile.value?.connectionFor(platform);

  // ---------------------------------------------------------------------
  // Actions / navigation hooks used by the profile screen's rows.
  // ---------------------------------------------------------------------
  Future<void> editAvatar() async {
    if (isAvatarBusy.value) return;

    final action = await Get.bottomSheet<_AvatarAction>(
      SafeArea(
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose photo'),
                onTap: () => Get.back(result: _AvatarAction.upload),
              ),
              if (hasAvatar)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFE11D48),
                  ),
                  title: const Text(
                    'Remove photo',
                    style: TextStyle(color: Color(0xFFE11D48)),
                  ),
                  onTap: () => Get.back(result: _AvatarAction.remove),
                ),
              ListTile(
                title: const Text('Cancel', textAlign: TextAlign.center),
                onTap: () => Get.back(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );

    if (action == _AvatarAction.upload) {
      await _pickAndUploadAvatar();
    } else if (action == _AvatarAction.remove) {
      await _removeAvatar();
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
      maxWidth: 2048,
      maxHeight: 2048,
    );
    if (picked == null) return;

    final croppedPath = await Get.to<String>(
      () => AvatarCropConfirmView(imagePath: picked.path),
    );
    if (croppedPath == null || croppedPath.isEmpty) return;

    isAvatarBusy.value = true;
    final result =
        await _uploadAvatarUseCase(UploadAvatarParams(croppedPath));
    result.fold(
      (failure) => Get.snackbar("Couldn't update photo", failure.message),
      (user) {
        _applyAvatarFromUser(user);
        Get.snackbar('Photo updated', 'Your profile photo has been saved.');
      },
    );
    isAvatarBusy.value = false;
  }

  Future<void> _removeAvatar() async {
    isAvatarBusy.value = true;
    final result = await _deleteAvatarUseCase(const NoParams());
    result.fold(
      (failure) => Get.snackbar("Couldn't remove photo", failure.message),
      (user) {
        _applyAvatarFromUser(user);
        Get.snackbar('Photo removed', 'Your profile photo has been removed.');
      },
    );
    isAvatarBusy.value = false;
  }

  void _applyAvatarFromUser(UserEntity user) {
    // `/auth/me/avatar` returns the same shape as `/auth/me` — treat it as me.
    _auth?.applyMeUser(user, bumpAvatarCache: true);

    final current = profile.value;
    if (current != null) {
      profile.value = current.copyWith(
        user: current.user.copyWith(
          avatarUrl: user.avatarUrl,
          clearAvatarUrl: user.avatarUrl == null || user.avatarUrl!.isEmpty,
        ),
      );
    }
  }

  void openSocialAccounts() {
    final context = Get.context;
    if (context == null) return;
    final social = Get.find<SocialConnectionsController>();
    social.loadConnectionStatuses();
    social.openSheet(context);
  }

  void openWallet() {
    Get.toNamed(AppRoutes.wallet);
  }

  void openEditProfile() {
    Get.toNamed(AppRoutes.editProfile);
  }

  void openChangePassword() {
    Get.toNamed(AppRoutes.changePassword);
  }

  void openHelpSupport() {
    Get.toNamed(AppRoutes.helpSupport);
  }

  Future<void> openPrivacyPolicy() async {
    final ok = await AppLegalLinks.openPrivacyPolicy();
    if (!ok) {
      Get.snackbar("Couldn't open", 'Unable to open Privacy Policy.');
    }
  }

  Future<void> openTermsAndConditions() async {
    final ok = await AppLegalLinks.openTermsAndConditions();
    if (!ok) {
      Get.snackbar("Couldn't open", 'Unable to open Terms & Conditions.');
    }
  }

  void openSettings() {
    // TODO: Get.toNamed(Routes.settings);
  }

  Future<void> logout() async {
    final storage = Get.find<AuthStorageService>();

    // Stop inactivity tracking
    Get.find<InactivityService>().stop();

    await storage.clearAuthData();

    currentUser.value = null;
    loginResponse.value = null;

    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<SocialConnectionsController>()) {
      Get.find<SocialConnectionsController>().onConnectionsChanged =
          refreshProfile;
    }
    loadProfile();
  }
}

enum _AvatarAction { upload, remove }
