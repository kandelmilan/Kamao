import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/auth/domain/entities/response/profile_entity.dart';
import 'package:kamao/src/auth/domain/usecases/get_creator_profile_usecase.dart';
import 'package:kamao/src/social_connections/presentation/controllers/social_connections_controller.dart';

class ProfileController extends GetxController {
  ProfileController(this._getCreatorProfileUseCase);

  final GetCreatorProfileUseCase _getCreatorProfileUseCase;

  final Rxn<ProfileEntity> profile = Rxn<ProfileEntity>();
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final currentUser = Rxn<UserEntity>();
  final loginResponse = Rxn<LoginResponseEntity>();
  Future<void> loadProfile() async {
    isLoading.value = true;
    error.value = null;

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
  // Identity / avatar
  //
  // NOTE: ProfileEntity's `user` doesn't have an avatar/photo field in
  // what's been shared, so there's currently no real image to load.
  // `hasAvatar` is always false and the UI should fall back to the
  // initials/icon placeholder. Once the backend exposes something like
  // `user.avatarUrl`, wire it in here (and flip `hasAvatar` to check
  // that it's non-empty) — no other call sites should need to change.
  // ---------------------------------------------------------------------
  bool get hasAvatar => false;

  String get avatarUrl => '';

  String get displayName {
    final user = profile.value?.user;
    if (user == null) return '';
    return user.fullName.isNotEmpty ? user.fullName : user.userName;
  }

  String get username => profile.value?.user.userName ?? '';

  /// Role/badge label shown next to the username. Hardcoded since
  /// ProfileEntity has no role field yet — centralize it here so the
  /// view doesn't hardcode it too.
  String get roleLabel => 'Creator';

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
  // Routes are placeholders — wire these up to your actual named routes
  // or bottom-sheet flows.
  // ---------------------------------------------------------------------
  void editAvatar() {
    // TODO: open image picker / avatar upload flow.
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
    // TODO: Get.toNamed(Routes.editProfile);
  }

  void openChangePassword() {
    // TODO: Get.toNamed(Routes.changePassword);
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
