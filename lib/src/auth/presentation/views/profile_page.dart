import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';

// Same brand palette as login_view.dart / register_view.dart — kept local
// per-file per that same convention, so Profile visually belongs with the
// rest of the auth flow instead of standing out with the old generic
// Material Card look.
class _Palette {
  _Palette._();

  static const walletGradientStart = Color(0xFF6F338D);
  static const walletGradientMid = Color(0xFF571A78);
  static const walletGradientEnd = Color(0xFF3E0163);
  static const purple = Color(0xFF4B0070);
  static const heading = Color(0xFF353037);
  static const white = Colors.white;
}

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthController controller = Get.find<AuthController>();

  static const _brandColor = _Palette.purple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final topPadding = MediaQuery.of(context).padding.top;
            final screenHeight = MediaQuery.sizeOf(context).height;
            final scale = (screenHeight / 812).clamp(0.6, 1.0);
            final headerHeight = screenHeight * 0.26 + topPadding;

            return Obx(() {
              final user = controller.currentUser.value;

              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _header(context, topPadding, headerHeight, scale),
                    Transform.translate(
                      offset: const Offset(0, -60),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 30 * scale),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: user == null
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 60),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: _brandColor,
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 24 * scale),
                                    _sectionCard(
                                      title: 'Account Information',
                                      icon: Icons.person_outline,
                                      scale: scale,
                                      children: [
                                        _infoTile(
                                          Icons.badge_outlined,
                                          'Username',
                                          user.userName,
                                          scale,
                                        ),
                                        _infoTile(
                                          Icons.business_outlined,
                                          'Tenant ID',
                                          user.tenantId,
                                          scale,
                                        ),
                                        _infoTile(
                                          Icons.admin_panel_settings_outlined,
                                          'Role ID',
                                          user.roleId,
                                          scale,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 18 * scale),
                                    _sectionCard(
                                      title: 'Permissions',
                                      icon: Icons.security_outlined,
                                      scale: scale,
                                      children: [
                                        _permissionsBody(
                                          context,
                                          user.permissions,
                                          scale,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 28 * scale),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 54 * scale,
                                      child: OutlinedButton.icon(
                                        onPressed: () =>
                                            _showLogoutConfirmation(context),
                                        icon: const Icon(
                                          Icons.logout,
                                          color: Colors.red,
                                        ),
                                        label: Text(
                                          'Log out',
                                          style: TextStyle(
                                            fontSize: 16 * scale,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.red,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
            });
          },
        ),
      ),
    );
  }

  // ==========================================================
  // Header — gradient hero with avatar, name, and email. Sits above the
  // white rounded card, same overlap trick used on login/register.
  //
  // No back button here — ProfilePage lives inside the app's bottom-tab
  // IndexedStack (as one of several persistent tab children), not pushed
  // via Get.to(), so there's no "previous screen" to pop back to.
  // ==========================================================
  Widget _header(
    BuildContext context,
    double topPadding,
    double headerHeight,
    double scale,
  ) {
    return SizedBox(
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
                top: 90 + topPadding,
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
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _Palette.white.withOpacity(.05),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Center(
                  child: Obx(() {
                    final user = controller.currentUser.value;
                    final initial = (user != null && user.fullName.isNotEmpty)
                        ? user.fullName[0].toUpperCase()
                        : 'U';

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 42 * scale,
                          backgroundColor: _Palette.white.withOpacity(.15),
                          child: Text(
                            initial,
                            style: TextStyle(
                              fontSize: 34 * scale,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 12 * scale),
                        Text(
                          user?.fullName ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20 * scale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4 * scale),
                        Text(
                          user?.email ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(.75),
                            fontSize: 13.5 * scale,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // Logout confirmation — calls the existing AuthController.logout(),
  // which stops the inactivity tracker, clears stored auth data, and
  // routes back to AppRoutes.login via Get.offAllNamed.
  // ==========================================================
  void _showLogoutConfirmation(BuildContext context) {
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
              controller.logout(); // Perform logout
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  Widget _permissionsBody(
    BuildContext context,
    List<String> permissions,
    double scale,
  ) {
    if (permissions.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8 * scale),
        child: Text(
          'No permissions assigned yet',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${permissions.length} permissions granted',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextButton.icon(
              icon: const Icon(Icons.visibility, size: 18),
              label: const Text('View All'),
              style: TextButton.styleFrom(foregroundColor: _brandColor),
              onPressed: () => _showAllPermissions(context, permissions),
            ),
          ],
        ),
        SizedBox(height: 12 * scale),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: permissions.take(8).map((permission) {
            return Chip(
              label: Text(permission, style: const TextStyle(fontSize: 13)),
              backgroundColor: _brandColor.withOpacity(0.08),
              side: BorderSide.none,
            );
          }).toList(),
        ),
        if (permissions.length > 8)
          Padding(
            padding: EdgeInsets.only(top: 6 * scale),
            child: Text(
              '+ ${permissions.length - 8} more',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
      ],
    );
  }

  // Show all permissions bottom sheet
  void _showAllPermissions(BuildContext context, List<String> permissions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'All Permissions (${permissions.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: permissions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(
                            Icons.verified_user,
                            color: Colors.green,
                          ),
                          title: Text(permissions[index]),
                          dense: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Section Card
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required double scale,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _brandColor, size: 20),
              SizedBox(width: 10 * scale),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.bold,
                  color: _Palette.heading,
                ),
              ),
            ],
          ),
          Divider(height: 24 * scale, color: Colors.grey.shade200),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value, double scale) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8 * scale),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade500),
          SizedBox(width: 14 * scale),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
                fontSize: 13.5 * scale,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.5 * scale,
                color: _Palette.heading,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
