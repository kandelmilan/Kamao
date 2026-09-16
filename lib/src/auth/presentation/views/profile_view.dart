import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/auth/presentation/controllers/profile_controller.dart';
import 'package:remixicon/remixicon.dart';

/// Profile tab — Figma Campaign App node 725:4267.
/// Soft green header + floating metrics card + settings groups.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const _headerBg = Color(0xFFF5FAEA);
  static const _headerCurve = Color(0xFFF7FBEE);

  static const _usernameText = Color(0xFF6E6971);
  static const _dot = Color(0xFFB6BDAD);

  static const _metricValue = Color(0xFF426340);
  static const _metricLabel = Color(0xFF6E6971);
  static const _metricDivider = Color(0xFFEDECED);

  static const _cardBorder = Color(0xFFF2F5F9);
  static const _cardShadow1 = Color(0x08000000);
  static const _cardShadow2 = Color(0x0A273B26);

  static const _rowIconBg = Color(0xFFE8F0E5);
  static const _rowIconColor = Color(0xFF4C5749);
  static const _rowTitle = Color(0xFF4A434D);
  static const _rowSubtitle = Color(0xFF6E6971);

  static const _editBadge = Color(0xFF4C5749);

  static const _logoutRed = Color(0xFFE11D48);
  static const _logoutChevron = Color(0xFFF48FA1);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: AppColors.homeBg,
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

  // ---------- Header (soft green) + floating metrics ----------

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
          padding: EdgeInsets.only(top: topInset + 28, bottom: 56),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_headerCurve, _headerBg],
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
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.6,
                  height: 32 / 24,
                  color: AppColors.cardTitle,
                ),
              ),
              const SizedBox(height: 4),
              _usernameRow(controller),
            ],
          ),
        ),
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
              border: Border.all(color: AppColors.white, width: 3),
              color: const Color(0xFFE8F0E5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              image: controller.hasAvatar
                  ? DecorationImage(
                      image: NetworkImage(controller.avatarUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            alignment: Alignment.center,
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
                      color: _rowIconColor,
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _editBadge,
                  border: Border.all(color: AppColors.white, width: 2),
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
            color: _dot,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          controller.roleLabel,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            letterSpacing: 0.3,
            height: 16 / 12,
            color: _usernameText,
          ),
        ),
      ],
    );
  }

  Widget _metricsCard(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE6F0E4)),
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
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
            const SizedBox(height: 28),
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
          textAlign: TextAlign.center,
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
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
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
            subtitle: controller.needsSocialConnect
                ? 'Connect Instagram, Facebook or TikTok'
                : '$connectedCount connected',
            onTap: controller.openSocialAccounts,
          ),
          Container(height: 1, color: _cardBorder),
          _settingsRow(
            icon: RemixIcons.wallet_3_fill,
            title: 'Wallet',
            subtitle: '${controller.formattedWalletBalance} available',
            onTap: controller.openWallet,
          ),
        ],
      ),
    );
  }

  // ---------- Group 2 — Edit Profile / Change Password / Settings ----------

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
            icon: RemixIcons.lock_password_line,
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

  // ---------- Logout ----------

  Widget _logoutButton(BuildContext context, ProfileController controller) {
    return _card(
      child: _settingsRow(
        icon: RemixIcons.logout_circle_r_line,
        title: 'Logout',
        titleColor: _logoutRed,
        iconColor: _logoutRed,
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
              Navigator.pop(context);
              controller.logout();
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
        color: AppColors.white,
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
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: titleColor == _logoutRed
                    ? const Color(0x14E11D48)
                    : _rowIconBg,
                borderRadius: BorderRadius.circular(8),
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
