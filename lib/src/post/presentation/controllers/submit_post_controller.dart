import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';
import 'package:kamao/src/main_nav/main_nav.dart';
import 'package:kamao/src/post/domain/entities/social_media_entity.dart';
import 'package:kamao/src/post/domain/entities/submit_post_params.dart';
import 'package:kamao/src/post/domain/usecase/get_social_media_usecase.dart';
import 'package:kamao/src/post/domain/usecase/submit_post_usecase.dart';

class SubmitPostController extends GetxController {
  SubmitPostController(
    this._getCampaignDetailUseCase,
    this._getSocialMediaUseCase,
    this._submitPostUseCase,
    this.campaignId, {
    this.initialPlatformId,
  });

  final GetCampaignDetailUseCase _getCampaignDetailUseCase;
  final GetSocialMediaUseCase _getSocialMediaUseCase;
  final SubmitPostUseCase _submitPostUseCase;
  final String campaignId;
  final String? initialPlatformId;

  final Rxn<CampaignDetailEntity> campaign = Rxn<CampaignDetailEntity>();
  final RxList<SocialMediaItemEntity> mediaPosts = <SocialMediaItemEntity>[].obs;
  final RxnString selectedPostId = RxnString();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMedia = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxnString error = RxnString();
  final RxnString mediaWarning = RxnString();

  final contentUrlController = TextEditingController();
  final urlFieldFocusNode = FocusNode();
  final RxnString receiptPath = RxnString();
  final RxnString selectedPlatform = RxnString();

  final _picker = ImagePicker();

  bool get receiptRequired =>
      campaign.value?.purchaseProofRequired ?? false;

  String get hashtagLabel {
    final directives = campaign.value?.directives ?? const [];
    for (final d in directives) {
      final type = d.directiveType.toLowerCase();
      if (type.contains('hashtag') && d.valueText.trim().isNotEmpty) {
        final tag = d.valueText.trim();
        return tag.startsWith('#') ? tag : '#$tag';
      }
    }
    return '#aayurise';
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void onClose() {
    contentUrlController.dispose();
    urlFieldFocusNode.dispose();
    super.onClose();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;

    // Prefer showing Select Post images ASAP when platform is already known.
    final preferred = initialPlatformId?.trim();
    if (preferred != null && preferred.isNotEmpty) {
      selectedPlatform.value = preferred;
      // Fire without awaiting so thumbnails can paint while detail loads.
      // ignore: unawaited_futures
      loadMedia();
    }

    final detailResult = await _getCampaignDetailUseCase(
      CampaignIdParams(campaignId),
    );

    await detailResult.fold(
      (failure) async {
        error.value = failure.message;
      },
      (detail) async {
        campaign.value = detail;
        final current = selectedPlatform.value?.trim();
        if (current == null || current.isEmpty) {
          if (detail.displayPlatforms.isNotEmpty) {
            selectedPlatform.value = detail.displayPlatforms.first;
            await loadMedia();
          } else if (detail.platforms.isNotEmpty) {
            selectedPlatform.value = detail.platforms.first;
            await loadMedia();
          }
        } else if (mediaPosts.isEmpty && !isLoadingMedia.value) {
          await loadMedia();
        }
      },
    );

    isLoading.value = false;
  }

  Future<void> loadMedia() async {
    final platform = selectedPlatform.value?.trim() ?? '';
    if (platform.isEmpty) {
      mediaPosts.clear();
      return;
    }

    isLoadingMedia.value = true;
    mediaWarning.value = null;

    final result = await _getSocialMediaUseCase(
      GetSocialMediaParams(platform: platform),
    );

    result.fold(
      (failure) {
        mediaPosts.clear();
        if (error.value == null) {
          Get.snackbar("Couldn't load posts", failure.message);
        }
      },
      (media) {
        mediaPosts.assignAll(media.items);
        mediaWarning.value = media.warning;
        if (!media.connected && media.warning != null) {
          Get.snackbar('Account not connected', media.warning!);
        }
      },
    );

    isLoadingMedia.value = false;
  }

  void selectPost(SocialMediaItemEntity post) {
    if (selectedPostId.value == post.id) {
      clearSelectedPost();
      return;
    }
    selectedPostId.value = post.id;
    contentUrlController.clear();
    if (post.platform.trim().isNotEmpty) {
      selectedPlatform.value = post.platform;
    }
  }

  void clearSelectedPost() {
    selectedPostId.value = null;
  }

  Future<void> selectPlatform(String platform) async {
    if (selectedPlatform.value?.toLowerCase() == platform.toLowerCase()) {
      return;
    }
    selectedPlatform.value = platform;
    clearSelectedPost();
    contentUrlController.clear();
    await loadMedia();
  }

  Future<void> pickReceipt() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;
    receiptPath.value = file.path;
  }

  void clearReceipt() {
    receiptPath.value = null;
  }

  SocialMediaItemEntity? get _selectedPost {
    final id = selectedPostId.value;
    if (id == null) return null;
    for (final post in mediaPosts) {
      if (post.id == id) return post;
    }
    return null;
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;

    final platform = selectedPlatform.value?.trim() ?? '';
    if (platform.isEmpty) {
      Get.snackbar('Missing platform', 'Select a platform to post on.');
      return;
    }

    final selected = _selectedPost;
    final contentUrl = selected != null
        ? selected.permalink.trim()
        : contentUrlController.text.trim();

    if (contentUrl.isEmpty &&
        (selected?.externalPostId == null ||
            selected!.externalPostId.trim().isEmpty)) {
      Get.snackbar(
        'Missing content',
        'Select a post or paste a post URL.',
      );
      return;
    }

    if (receiptRequired &&
        (receiptPath.value == null || receiptPath.value!.isEmpty)) {
      Get.snackbar('Receipt required', 'Upload a receipt photo to continue.');
      return;
    }

    isSubmitting.value = true;

    final thumb =
        selected?.thumbnailImageUrl?.trim() ??
        selected?.thumbnailUrl?.trim() ??
        '';

    final params = SubmitPostParams(
      campaignId: campaignId,
      platform: platform.toLowerCase(),
      contentUrl: contentUrl,
      externalPostId: selected?.externalPostId.trim() ?? '',
      caption: selected?.caption?.trim() ?? '',
      thumbnailUrl: thumb,
      // JSON `/submissions` when null; multipart `/submissions/form` when set.
      receiptPath: receiptPath.value,
    );

    final result = await _submitPostUseCase(params);

    result.fold(
      (failure) => Get.snackbar("Couldn't submit", failure.message),
      (_) {
        Get.snackbar('Submitted', 'Your post was sent for review.');
        _navigateToHome();
      },
    );

    isSubmitting.value = false;
  }

  void _navigateToHome() {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(MainNavTab.home);
      Get.until(
        (route) =>
            route.settings.name == AppRoutes.mainNav || route.isFirst,
      );
      return;
    }

    Get.offAllNamed(AppRoutes.mainNav);
  }
}
