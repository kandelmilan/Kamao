import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:kamao/src/post/domain/entities/social_media_entity.dart';
import 'package:kamao/src/post/presentation/controllers/submit_post_controller.dart';
import 'package:remixicon/remixicon.dart';

// ── Figma tokens (brands-page / submit post) ─────────────────────────
abstract final class _SubmitPostTokens {
  static const sectionTitle = Color(0xFF4A434D);
  static const campaignTitle = Color(0xFF353037);
  static const bodyText = Color(0xFF4A434D);
  static const rewardGreen = Color(0xFF557F52);
  static const mutedLabel = Color(0xFF6E6971);
  static const cardBg = Color(0xFFF4FAE8);
  static const cardBorder = Color(0xFFDAE9D7);
  static const dashedBg = Color(0xFFF7FAF6);
  static const dashedBorder = Color(0xFFEDEDFC);
  static const postCardBorder = Color(0xFFEDECED);
  static const platformTagBorder = Color(0xFFC7C5C8);
  static const checkGreen = Color(0xFF557F52);
  static const submitGreen = Color(0xFF2E4A2F);
  static const linkBlue = Color(0xFF2F6FED);
  static const plusPurple = Color(0xFF6F338D);
  static const gradientEnd = Color(0xFFF6FBED);

  static const double horizontalPad = 20;
  static const double dashedRadius = 9;
  static const double uploadRadius = 22.77;
  static const double dashLength = 2.28;
  static const double dashGap = 2.28;
}

class SubmitPostView extends StatelessWidget {
  const SubmitPostView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmitPostController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.0, 0.89, 1.0126],
            colors: [
              Colors.white,
              Colors.white,
              _SubmitPostTokens.gradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.campaign.value == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.onboardingGreen,
                ),
              );
            }

            if (controller.error.value != null &&
                controller.campaign.value == null) {
              return _ErrorState(
                message: controller.error.value!,
                onRetry: controller.load,
              );
            }

            final campaign = controller.campaign.value;

            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 20, 0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => Get.back(),
                                icon: const Icon(
                                  RemixIcons.arrow_left_s_line,
                                  size: 28,
                                  color: AppColors.ink,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Submit Post',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Text(
                            'Add your content to get rewarded',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.bodyGrey,
                            ),
                          ),
                        ),
                      ),
                      if (campaign != null)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: _SubmitPostTokens.horizontalPad,
                            ),
                            child: _CampaignBriefCard(
                              campaign: campaign,
                              controller: controller,
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            _SubmitPostTokens.horizontalPad,
                            28,
                            _SubmitPostTokens.horizontalPad,
                            0,
                          ),
                          child: _PostsSection(controller: controller),
                        ),
                      ),
                      if (controller.receiptRequired)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              _SubmitPostTokens.horizontalPad,
                              28,
                              _SubmitPostTokens.horizontalPad,
                              0,
                            ),
                            child: _ReceiptSection(controller: controller),
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 120)),
                    ],
                  ),
                ),
                _SubmitBar(controller: controller),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.subtext),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: AppColors.onboardingGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1,
        color: _SubmitPostTokens.sectionTitle,
      ),
    );
  }
}

class _CampaignBriefCard extends StatelessWidget {
  const _CampaignBriefCard({
    required this.campaign,
    required this.controller,
  });

  final CampaignDetailEntity campaign;
  final SubmitPostController controller;

  String get _rewardAmount {
    var label = campaign.earnRangeLabel.trim();
    if (label.isEmpty && campaign.creatorMaxReward > 0) {
      final currency =
          campaign.currency.isNotEmpty ? campaign.currency : 'Rs';
      label = '$currency ${campaign.creatorMaxReward.toStringAsFixed(0)}';
    }
    label = label
        .replaceFirst(RegExp(r'^(up\s*to\s*)', caseSensitive: false), '')
        .replaceFirst(
          RegExp(r'\s*per\s+creator.*$', caseSensitive: false),
          '',
        )
        .trim();
    return label.isEmpty ? '—' : label;
  }

  String get _description {
    final narrative = campaign.brief.narrative?.trim();
    if (narrative != null && narrative.isNotEmpty) return narrative;
    if (campaign.objective.trim().isNotEmpty) return campaign.objective;
    return 'Campaign description here';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Campaign brief'),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: BoxDecoration(
            color: _SubmitPostTokens.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _SubmitPostTokens.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      campaign.name.isNotEmpty
                          ? campaign.name
                          : campaign.brandName,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        height: 32 / 20,
                        color: _SubmitPostTokens.campaignTitle,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.snackbar(
                        'Campaign brief',
                        _description,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Icon(
                      RemixIcons.information_line,
                      size: 18,
                      color: _SubmitPostTokens.bodyText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  color: _SubmitPostTokens.bodyText,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Earn upto $_rewardAmount',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      color: _SubmitPostTokens.rewardGreen,
                    ),
                  ),
                  Text(
                    campaign.purchaseProofRequired
                        ? 'Receipt required'
                        : 'Receipt not required',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      color: _SubmitPostTokens.rewardGreen,
                    ),
                  ),
                ],
              ),
              if (campaign.platforms.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Post on :',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        color: _SubmitPostTokens.bodyText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: campaign.platforms.map((p) {
                          return Obx(() {
                            final selected =
                                (controller.selectedPlatform.value ?? '')
                                    .toLowerCase() ==
                                p.toLowerCase();
                            return _PlatformChip(
                              label: p,
                              selected: selected,
                              onTap: () {
                                controller.selectPlatform(p);
                              },
                            );
                          });
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PlatformChip extends StatelessWidget {
  const _PlatformChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    final lower = label.toLowerCase();
    if (lower.contains('tiktok')) return RemixIcons.tiktok_line;
    if (lower.contains('facebook')) return RemixIcons.facebook_fill;
    if (lower.contains('youtube')) return RemixIcons.youtube_line;
    return RemixIcons.instagram_line;
  }

  String get _displayLabel {
    final lower = label.toLowerCase();
    if (lower.contains('instagram')) return 'Instagram';
    if (lower.contains('tiktok')) return 'Tiktok';
    if (lower.contains('facebook')) return 'Facebook';
    if (lower.contains('youtube')) return 'Youtube';
    return label.isEmpty
        ? label
        : label[0].toUpperCase() + label.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected
                ? _SubmitPostTokens.rewardGreen
                : _SubmitPostTokens.platformTagBorder,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 10, color: _SubmitPostTokens.mutedLabel),
            const SizedBox(width: 4),
            Text(
              _displayLabel,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1,
                letterSpacing: 0.5,
                color: _SubmitPostTokens.mutedLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostsSection extends StatelessWidget {
  const _PostsSection({required this.controller});

  final SubmitPostController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final posts = controller.mediaPosts;
      final loadingMedia = controller.isLoadingMedia.value;
      final tag = controller.hashtagLabel;
      const bodyStyle = TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12.98,
        fontWeight: FontWeight.w400,
        height: 19.47 / 12.98,
        letterSpacing: 0.41,
        color: _SubmitPostTokens.bodyText,
      );
      const tagStyle = TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12.98,
        fontWeight: FontWeight.w500,
        height: 19.47 / 12.98,
        letterSpacing: 0.41,
        color: _SubmitPostTokens.bodyText,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Select Post'),
          const SizedBox(height: 12),
          if (loadingMedia)
            SizedBox(
              height: _PostThumb.cardHeight,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.onboardingGreen,
                  strokeWidth: 2,
                ),
              ),
            )
          else if (posts.isNotEmpty)
            SizedBox(
              height: _PostThumb.cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: posts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  final selected =
                      controller.selectedPostId.value == post.id;
                  return _PostThumb(
                    post: post,
                    selected: selected,
                    onTap: () => controller.selectPost(post),
                  );
                },
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No matching posts yet. Paste a URL below or refresh after posting.',
                style: bodyStyle,
              ),
            ),
          // URL paste: always when no posts; when posts exist, only if none selected.
          if (!loadingMedia &&
              (posts.isEmpty || controller.selectedPostId.value == null)) ...[
            const SizedBox(height: 16),
            const _PastePostUrlField(),
          ],
          const SizedBox(height: 18),
          Text(
            'Your posts with $tag',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1,
              color: _SubmitPostTokens.sectionTitle,
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: bodyStyle,
              children: [
                const TextSpan(
                  text:
                      'Only connected-account posts whose caption (or first '
                      'comments) includes ',
                ),
                TextSpan(text: tag, style: tagStyle),
                const TextSpan(
                  text:
                      ' are shown. Type the tag in the caption — Instagram '
                      'stickers are not sent to AayuRise. Refresh a minute '
                      'after posting.',
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _PastePostUrlField extends StatelessWidget {
  const _PastePostUrlField();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmitPostController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              "Can't find content ? Paste Post URL ",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1,
                color: _SubmitPostTokens.bodyText,
              ),
            ),
            GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(
                controller.urlFieldFocusNode,
              ),
              child: const Text(
                'here',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  color: _SubmitPostTokens.linkBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text(
              ' .',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1,
                color: _SubmitPostTokens.bodyText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _DashedBox(
          height: 43,
          radius: _SubmitPostTokens.dashedRadius,
          child: TextField(
            controller: controller.contentUrlController,
            focusNode: controller.urlFieldFocusNode,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _SubmitPostTokens.bodyText,
            ),
            decoration: const InputDecoration(
              hintText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _PostThumb extends StatelessWidget {
  const _PostThumb({
    required this.post,
    required this.selected,
    required this.onTap,
  });

  final SocialMediaItemEntity post;
  final bool selected;
  final VoidCallback onTap;

  static const cardWidth = 113.0;
  static const cardHeight = 128.0;
  static const _footerHeight = 28.0;

  IconData get _platformIcon {
    final lower = post.platform.toLowerCase();
    if (lower.contains('tiktok')) return RemixIcons.tiktok_fill;
    if (lower.contains('facebook')) return RemixIcons.facebook_fill;
    return RemixIcons.instagram_fill;
  }

  @override
  Widget build(BuildContext context) {
    final thumb = post.thumbnailImageUrl;
    final published = post.publishedAt ?? DateTime.now();
    final date = DateFormat('d MMM yyyy').format(published.toLocal());

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _SubmitPostTokens.postCardBorder,
              width: 0.5,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x26000000),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _MediaThumbnail(url: thumb)),
                    Container(
                      height: _footerHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: _SubmitPostTokens.postCardBorder,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            _platformIcon,
                            size: 10,
                            color: _SubmitPostTokens.mutedLabel,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              date.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                height: 1,
                                letterSpacing: 0.5,
                                color: _SubmitPostTokens.mutedLabel,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (selected)
                  const Positioned(
                    top: 6,
                    right: 6,
                    child: _PostSelectedBadge(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Loads social-media CDN thumbnails with browser headers (Instagram/TikTok
/// often block bare [Image.network] requests).
class _MediaThumbnail extends StatefulWidget {
  const _MediaThumbnail({required this.url});

  final String? url;

  @override
  State<_MediaThumbnail> createState() => _MediaThumbnailState();
}

class _MediaThumbnailState extends State<_MediaThumbnail> {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      responseType: ResponseType.bytes,
      headers: const {
        'User-Agent':
            'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) '
            'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 '
            'Mobile/15E148 Safari/604.1',
        'Accept': 'image/avif,image/webp,image/apng,image/*,*/*;q=0.8',
      },
      validateStatus: (code) => code != null && code >= 200 && code < 400,
    ),
  );

  static final Map<String, Uint8List> _cache = {};

  Uint8List? _bytes;
  bool _failed = false;
  Object? _loadToken;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _MediaThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _bytes = null;
      _failed = false;
      _load();
    }
  }

  Future<void> _load() async {
    final url = widget.url?.trim();
    if (url == null || url.isEmpty) {
      setState(() => _failed = true);
      return;
    }

    final cached = _cache[url];
    if (cached != null) {
      setState(() {
        _bytes = cached;
        _failed = false;
      });
      return;
    }

    final token = Object();
    _loadToken = token;

    try {
      final response = await _dio.get<List<int>>(url);
      final raw = response.data;
      if (raw == null || raw.isEmpty) {
        throw StateError('empty image body');
      }
      final bytes = Uint8List.fromList(raw);
      _cache[url] = bytes;
      if (!mounted || _loadToken != token) return;
      setState(() {
        _bytes = bytes;
        _failed = false;
      });
    } catch (_) {
      if (!mounted || _loadToken != token) return;
      setState(() {
        _bytes = null;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bytes != null) {
      return Image.memory(
        _bytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        gaplessPlayback: true,
      );
    }
    if (_failed) {
      return const ColoredBox(
        color: Color(0xFFE8E8EA),
        child: Center(
          child: Icon(
            RemixIcons.image_line,
            color: _SubmitPostTokens.mutedLabel,
          ),
        ),
      );
    }
    return const ColoredBox(
      color: Color(0xFFE8E8EA),
      child: Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.onboardingGreen,
          ),
        ),
      ),
    );
  }
}

/// Green tick badge shown on the top-right of a selected post card.
class _PostSelectedBadge extends StatelessWidget {
  const _PostSelectedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: _SubmitPostTokens.checkGreen,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(
        RemixIcons.check_fill,
        size: 10,
        color: Colors.white,
      ),
    );
  }
}

class _ReceiptSection extends StatelessWidget {
  const _ReceiptSection({required this.controller});

  final SubmitPostController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final path = controller.receiptPath.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Upload Receipt'),
          const SizedBox(height: 12),
          _DashedBox(
            height: 136,
            radius: _SubmitPostTokens.uploadRadius,
            child: path != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(path),
                          height: 72,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: controller.clearReceipt,
                        child: const Text(
                          'Remove',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        RemixIcons.upload_cloud_2_line,
                        size: 32,
                        color: _SubmitPostTokens.rewardGreen,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Upload Receipt',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _SubmitPostTokens.bodyText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: controller.pickReceipt,
                        child: CustomPaint(
                          painter: const _DashedRRectPainter(
                            color: _SubmitPostTokens.platformTagBorder,
                            radius: 10,
                            dash: _SubmitPostTokens.dashLength,
                            gap: _SubmitPostTokens.dashGap,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '+ ',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: _SubmitPostTokens.plusPurple,
                                  ),
                                ),
                                Text(
                                  'Choose photo',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _SubmitPostTokens.bodyText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      );
    });
  }
}

class _DashedBox extends StatelessWidget {
  const _DashedBox({
    required this.height,
    required this.radius,
    required this.child,
  });

  final double height;
  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _DashedRRectPainter(
          color: _SubmitPostTokens.dashedBorder,
          radius: radius,
          dash: _SubmitPostTokens.dashLength,
          gap: _SubmitPostTokens.dashGap,
          strokeWidth: 1.14,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: ColoredBox(
            color: _SubmitPostTokens.dashedBg,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SubmitBar extends StatelessWidget {
  const _SubmitBar({required this.controller});

  final SubmitPostController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        _SubmitPostTokens.horizontalPad,
        12,
        _SubmitPostTokens.horizontalPad,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        final submitting = controller.isSubmitting.value;
        return SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: submitting ? null : controller.submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: _SubmitPostTokens.submitGreen,
              disabledBackgroundColor:
                  _SubmitPostTokens.submitGreen.withValues(alpha: 0.6),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: submitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Submit for review',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        );
      }),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.radius,
    this.dash = _SubmitPostTokens.dashLength,
    this.gap = _SubmitPostTokens.dashGap,
    this.strokeWidth = 1.14,
  });

  final Color color;
  final double radius;
  final double dash;
  final double gap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.dash != dash ||
      oldDelegate.gap != gap ||
      oldDelegate.strokeWidth != strokeWidth;
}
