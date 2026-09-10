import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/auth/presentation/controllers/profile_controller.dart';
import 'package:remixicon/remixicon.dart';

/// ---------------------------------------------------------------------
/// Design tokens that aren't already part of AppColors. Pulled straight
/// from the spec — if AppColors grows matching entries later, swap these
/// out for AppColors.xxx to keep a single source of truth.
/// ---------------------------------------------------------------------
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const _headerGradientStart = Color(0xFF6F338D);
  static const _headerGradientEnd = Color(0xFF3E0163);

  static const _usernameText = Color(0xE5E9D5FF); // #E9D5FF @ 90% (E5)
  static const _dotOverlay = Color(0xB2D8B4FE); // #D8B4FE @ 70% (B2)
  static const _creatorBadgeBg = Color(0x33D8B4FE);
  static const _creatorBadgeText = Color(0xFFF3E8FF);

  static const _metricValue = Color(0xFF4B0070);
  static const _metricLabel = Color(0xFF6E6971);
  static const _metricDivider = Color(0xFFEFD4FF);

  static const _cardBorder = Color(0xFFF1F5F9);
  static const _cardShadow1 = Color(0x08000000);
  static const _cardShadow2 = Color(0x0D270337);

  static const _rowIconBg = Color(0xFFFCF7FF);
  static const _rowIconColor = Color(0xFF4B0070);
  static const _rowTitle = Color(0xFF4A434D);
  static const _rowSubtitle = Color(0xFF6E6971);

  static const _logoutRed = Color(0xFFE11D48);
  static const _logoutChevron = Color(0xFFF48FA1);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: AppColors.background,
        // No SafeArea here — the header gradient needs to run all the
        // way behind the status bar. Safe-area insets are applied
        // individually below: inside the header (top) and around the
        // scrollable content beneath it (bottom).
        child: RefreshIndicator(
          onRefresh: controller.refreshProfile,
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.profile.value == null) {
              return const SafeArea(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.error.value != null &&
                controller.profile.value == null) {
              return SafeArea(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: TextButton(
                        onPressed: controller.loadProfile,
                        child: const Text(
                          "Couldn't load profile — tap to retry",
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final profile = controller.profile.value;
            if (profile == null) return const SizedBox.shrink();

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _headerWithMetrics(context, controller),
                const SizedBox(height: 144),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _accountsAndWalletCard(controller),
                        const SizedBox(height: 16),
                        _settingsCard(controller),
                        const SizedBox(height: 16),
                        _logoutButton(context, controller),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ---------- Header (purple radial-gradient frame) + floating metrics ----------

  Widget _headerWithMetrics(
    BuildContext context,
    ProfileController controller,
  ) {
    final user = controller.profile.value!.user;
    final topInset = MediaQuery.of(context).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: topInset + 32, bottom: 56),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            gradient: RadialGradient(
              center: Alignment(-0.59, 0.23),
              radius: 1.05,
              colors: [_headerGradientStart, _headerGradientEnd],
            ),
          ),
          child: Column(
            children: [
              _avatar(user, controller),
              const SizedBox(height: 12),
              Text(
                controller.displayName,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.6,
                  height: 32 / 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              _usernameRow(controller),
            ],
          ),
        ),

        // Floating metrics card, overlapping the header's bottom edge
        Positioned(
          left: 20,
          right: 20,
          bottom: -120,
          child: _metricsCard(controller),
        ),
      ],
    );
  }

  Widget _avatar(dynamic user, ProfileController controller) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              color: const Color(0xFFEDE6F1),
              image: controller.hasAvatar
                  ? DecorationImage(
                      image: NetworkImage(controller.avatarUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            // No profile photo available yet (see
            // ProfileController.hasAvatar) — fall back to a simple
            // initial/icon placeholder instead of a broken image.
            child: !controller.hasAvatar
                ? Text(
                    user.fullName.isNotEmpty
                        ? user.fullName[0].toUpperCase()
                        : (user.userName.isNotEmpty
                              ? user.userName[0].toUpperCase()
                              : '?'),
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: GestureDetector(
              onTap: controller.editAvatar,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF59E0B),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  RemixIcons.pencil_fill,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _usernameRow(ProfileController controller) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '@${controller.username}',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            letterSpacing: 0.3,
            height: 16 / 12,
            color: _usernameText,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: _dotOverlay,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          // decoration: BoxDecoration(
          //   color: _creatorBadgeBg,
          //   borderRadius: BorderRadius.circular(20),
          // ),
          child: Text(
            controller.roleLabel,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              letterSpacing: 0.3,
              height: 16 / 12,
              color: _creatorBadgeText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _metricsCard(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(1), // gradient border thickness
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment(-0.53, -0.93), // ~159.33deg
          end: Alignment(0.53, 0.93),
          colors: [Colors.white, Color(0xFFEFD4FF)],
          stops: [0.0722, 0.749],
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _metricItem(
                    controller.formattedTotalRewarded,
                    'Total Rewarded',
                  ),
                ),
                Container(width: 1, height: 36, color: _metricDivider),
                Expanded(
                  child: _metricItem(
                    controller.formattedAveragePostReward,
                    'Average Rewarded',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _metricItem(
                    '${controller.totalPostCount}',
                    'Total Posts',
                  ),
                ),
                Container(width: 1, height: 36, color: _metricDivider),
                Expanded(
                  child: _metricItem(
                    '${controller.rewardedPostCount}',
                    'Rewarded Posts',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _metricValue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: _metricLabel,
          ),
        ),
      ],
    );
  }

  // ---------- Group 1 — Social Accounts + Wallet ----------

  Widget _accountsAndWalletCard(ProfileController controller) {
    final connectedCount = controller.connectedAccountsCount;

    return _card(
      child: Column(
        children: [
          _settingsRow(
            icon: RemixIcons.links_line,
            title: 'Social Accounts',
            subtitle: '$connectedCount connected',
            onTap: controller.openSocialAccounts,
          ),
          Container(height: 1, color: _cardBorder),
          _settingsRow(
            icon: RemixIcons.wallet_3_fill,
            title: 'Wallet',
            subtitle: controller.formattedWalletBalance,
            onTap: controller.openWallet,
          ),
        ],
      ),
    );
  }

  // ---------- Group 2 — Edit Profile / Change Password / Settings ----------
  // (Logout lives on its own, below — see _logoutButton.)

  Widget _settingsCard(ProfileController controller) {
    return _card(
      child: Column(
        children: [
          _settingsRow(
            icon: RemixIcons.pencil_line,
            title: 'Edit Profile',
            onTap: controller.openEditProfile,
          ),
          Container(height: 1, color: _cardBorder),
          _settingsRow(
            icon: RemixIcons.key_2_line,
            title: 'Change Password',
            onTap: controller.openChangePassword,
          ),
          Container(height: 1, color: _cardBorder),
          _settingsRow(
            icon: RemixIcons.settings_3_line,
            title: 'Settings',
            onTap: controller.openSettings,
          ),
        ],
      ),
    );
  }

  // ---------- Logout — standalone row card + confirmation dialog ----------

  Widget _logoutButton(BuildContext context, ProfileController controller) {
    return _card(
      child: _settingsRow(
        icon: RemixIcons.logout_circle_r_line,
        title: 'Logout',
        titleColor: _logoutRed,
        chevronColor: _logoutChevron,
        onTap: () => _showLogoutConfirmation(context, controller),
      ),
    );
  }

  void _showLogoutConfirmation(
    BuildContext context,
    ProfileController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              controller.logout(); // Controller owns the actual logout flow
            },
            style: TextButton.styleFrom(foregroundColor: _logoutRed),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  // ---------- Shared helpers ----------

  Widget _card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _cardBorder, width: 1),
        boxShadow: const [
          BoxShadow(color: _cardShadow1, blurRadius: 4, offset: Offset(0, 1)),
          BoxShadow(color: _cardShadow2, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }

  /// Shared row used by both cards: icon chip, title (+ optional
  /// subtitle), trailing chevron.
  Widget _settingsRow({
    required IconData icon,
    required String title,
    String? subtitle,
    Color titleColor = _rowTitle,
    Color iconColor = _rowIconColor,
    Color chevronColor = _rowSubtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _rowIconBg,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 19.94 / 14,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 18 / 12,
                        color: _rowSubtitle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(RemixIcons.arrow_right_s_line, size: 20, color: chevronColor),
          ],
        ),
      ),
    );
  }
}
