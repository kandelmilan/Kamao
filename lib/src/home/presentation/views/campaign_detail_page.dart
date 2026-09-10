import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/home/presentation/controllers/campaign_detail_controller.dart';
import 'package:kamao/src/home/presentation/widgets/campaign_checklist_card.dart';
import 'package:kamao/src/home/presentation/widgets/campaign_detail_header.dart';
import 'package:kamao/src/home/presentation/widgets/select_social_accounts_sheet.dart';
import 'package:remixicon/remixicon.dart';

class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CampaignDetailController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Obx(() {
        if (controller.isLoading.value && controller.campaign.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null &&
            controller.campaign.value == null) {
          return Center(child: Text(controller.error.value!));
        }
        final c = controller.campaign.value;
        if (c == null) return const SizedBox.shrink();

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Obx(
                    () => CampaignDetailHeader(
                      campaign: c,
                      isFavourite: c.isFavourite,
                      isTogglingFavourite: controller.isTogglingFavourite.value,
                      onBack: () => Get.back(),
                      onShare: () {
                        // TODO: share
                      },
                      onBookmark: controller.toggleFavourite,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Running By
                      _card(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 48,
                                height: 48,
                                color: const Color(0xFFFF6A00),
                                child: () {
                                  final logoUrl = resolveImageUrl(
                                    c.brandLogoUrl,
                                  );
                                  return logoUrl != null
                                      ? Image.network(
                                          logoUrl,
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: Text(
                                            c.brandName.isNotEmpty
                                                ? c.brandName[0].toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                }(),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Running By',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Color(0xFF4A434D),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    c.brandName,
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      height: 1.0,
                                      color: Color(0xFF353037),
                                    ),
                                  ),
                                  if (c.brandCategory != null &&
                                      c.brandCategory!.isNotEmpty)
                                    Text(
                                      c.brandCategory!,
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Color(0xFF4A434D),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        height: 1.0,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Campaign Goal
                      _sectionCard(
                        'Campaign Goal',
                        Text(
                          c.campaignGoal,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            height: 21 / 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF4A434D),
                          ),
                        ),
                      ),

                      // What you need to do
                      if (c.checklistItems.isNotEmpty)
                        CampaignChecklistCard(items: c.checklistItems),

                      // Post Limits
                      _sectionCard(
                        'Post Limits',
                        Row(
                          children: [
                            Expanded(
                              child: _limitBox(
                                '7 - day Period',
                                'Upto 2 posts',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _limitBox(
                                '12 - Month Period',
                                'Upto 18 posts',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Other Info
                      _sectionCard(
                        'Other Info',
                        Row(
                          children: [
                            Expanded(
                              child: _limitBox(
                                'START DATE',
                                _formatDate(c.startDateLocal),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _limitBox(
                                'PURCHASE PROOF',
                                c.purchaseProofRequired
                                    ? 'Required'
                                    : 'Not required',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // About
                      if (c.platforms.isNotEmpty)
                        _sectionCard(
                          'About',
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final platform in c.platforms)
                                _aboutChip(
                                  _platformIconFor(platform),
                                  platform,
                                ),
                            ],
                          ),
                        ),
                    ]),
                  ),
                ),
              ],
            ),

            // FAB
            // Positioned(
            //   right: 20,
            //   bottom: 28,
            //   child: Obx(
            //     () => FloatingActionButton(
            //       backgroundColor: const Color(0xFF6F338D),
            //       elevation: 4,
            //       shape: const CircleBorder(),
            //       onPressed: controller.isJoining.value || c.alreadyJoined
            //           ? null
            //           : () => _onFabPressed(context, controller),
            //       child: controller.isJoining.value
            //           ? const SizedBox(
            //               width: 22,
            //               height: 22,
            //               child: CircularProgressIndicator(
            //                 strokeWidth: 2.5,
            //                 color: Colors.white,
            //               ),
            //             )
            //           : Icon(
            //               c.alreadyJoined ? RemixIcons.add_fill : Icons.add,
            //               color: Colors.white,
            //               size: 28,
            //             ),
            //     ),
            //   ),
            // ),
            Positioned(
              right: 20,
              bottom: 28,
              child: Builder(
                builder: (_) {
                  debugPrint(
                    'FAB state: isJoining=${controller.isJoining.value} '
                    'alreadyJoined=${c.alreadyJoined}',
                  );
                  return Obx(
                    () => FloatingActionButton(
                      backgroundColor: const Color(0xFF6F338D),
                      elevation: 4,
                      shape: const CircleBorder(),
                      onPressed: controller.isJoining.value
                          // || c.alreadyJoined
                          ? null
                          : () => _onFabPressed(context, controller),
                      child: controller.isJoining.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              c.alreadyJoined ? RemixIcons.add_fill : Icons.add,
                              color: Colors.white,
                              size: 28,
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  // ---------- FAB flow ----------
  Future<void> _onFabPressed(
    BuildContext context,
    CampaignDetailController controller,
  ) async {
    final selected = await showSelectSocialAccountsSheet(context);
    if (selected == null) return;

    await controller.join(platformId: selected.platformId);
  }
  // ---------- Helpers ----------

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('d MMM, yyyy').format(date);
  }

  IconData _platformIconFor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return RemixIcons.instagram_line;
      case 'tiktok':
        return RemixIcons.tiktok_fill;
      case 'facebook':
        return RemixIcons.facebook_line;
      case 'youtube':
        return RemixIcons.youtube_line;
      default:
        return RemixIcons.global_line;
    }
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionCard(String title, Widget child) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.0,
              color: Color(0xFF353037),
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _limitBox(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              color: Color(0xFF6E6971),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              height: 1.0,
              color: Color(0xFF4A434D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutChip(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF6B7280)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}
