import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:kamao/src/home/presentation/controllers/social_accounts_sheet_controller.dart';
import 'package:kamao/src/social_connections/data/repositories/social_connections_repository.dart';

/// Opens the picker. Returns the account the user tapped, or null
/// if they hit Cancel / dismissed the sheet.
Future<ConnectedSocialAccount?> showSelectSocialAccountsSheet(
  BuildContext context,
) async {
  final repository = Get.find<SocialConnectionsRepository>();
  final controller = Get.put(SocialAccountsSheetController(repository));

  final result = await showModalBottomSheet<ConnectedSocialAccount>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => SelectSocialAccountsSheet(controller: controller),
  );

  Get.delete<SocialAccountsSheetController>();
  return result;
}

class SelectSocialAccountsSheet extends StatefulWidget {
  const SelectSocialAccountsSheet({super.key, required this.controller});

  final SocialAccountsSheetController controller;

  @override
  State<SelectSocialAccountsSheet> createState() =>
      _SelectSocialAccountsSheetState();
}

class _SelectSocialAccountsSheetState extends State<SelectSocialAccountsSheet> {
  final ScrollController _scrollController = ScrollController();

  SocialAccountsSheetController get controller => widget.controller;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  IconData _iconFor(String platformId) {
    switch (platformId.toLowerCase()) {
      case 'tiktok':
        return RemixIcons.tiktok_fill;
      case 'instagram':
        return RemixIcons.instagram_line;
      case 'facebook':
        return RemixIcons.facebook_line;
      case 'youtube':
        return RemixIcons.youtube_line;
      default:
        return RemixIcons.global_line;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 672),
        height: 366,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Select Social Accounts',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    height: 32 / 24,
                    letterSpacing: 0,
                    color: Color(0xFF4A434D),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.error.value != null) {
                      return Center(
                        child: Text(
                          controller.error.value!,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }
                    if (controller.accounts.isEmpty) {
                      return const Center(
                        child: Text(
                          'No connected social accounts yet.',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Color(0xFF6E6971),
                          ),
                        ),
                      );
                    }
                    // Scrollbar gives a visible, draggable thumb on the
                    // right edge — makes it obvious the list scrolls,
                    // and lets the user drag it directly instead of
                    // only swiping.
                    return Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      radius: const Radius.circular(8),
                      thickness: 5,
                      child: ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(right: 12),
                        children: [
                          for (final account in controller.accounts) ...[
                            _accountTile(context, account),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    );
                  }),
                ),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 16 / 12,
                        letterSpacing: 0.6,
                        color: Color(0xFF414844),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _accountTile(BuildContext context, ConnectedSocialAccount account) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).pop(account),
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFF0EAF3),
                  child: Icon(
                    _iconFor(account.platformId),
                    color: const Color(0xFF6F338D),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.displayName,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Color(0xFF343434),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _iconFor(account.platformId),
                          size: 12,
                          color: const Color(0xFF4A434D),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          account.platformLabel,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            height: 1.0,
                            letterSpacing: 0.5,
                            color: Color(0xFF4A434D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF6F338D)),
          ],
        ),
      ),
    );
  }
}
