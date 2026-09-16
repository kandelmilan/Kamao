import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/main_nav/presentation/controllers/main_nav_controller.dart';
import 'package:kamao/src/post/domain/entities/submission_entity.dart';
import 'package:kamao/src/post/domain/usecase/get_approved_submissions_usecase.dart';
import 'package:kamao/src/post/domain/usecase/get_pending_submissions_usecase.dart';
import 'package:kamao/src/social_connections/domain/entities/social_platform_type.dart';
import 'package:url_launcher/url_launcher.dart';

enum PostsTab { pending, approved }

class PostsController extends GetxController {
  PostsController({
    required GetPendingSubmissionsUseCase getPending,
    required GetApprovedSubmissionsUseCase getApproved,
  }) : _getPending = getPending,
       _getApproved = getApproved;

  final GetPendingSubmissionsUseCase _getPending;
  final GetApprovedSubmissionsUseCase _getApproved;

  static final _metaDate = DateFormat('d MMM yyyy');
  static final _submittedDate = DateFormat('yyyy-MM-dd HH:mm');
  static final _rewardEnds = DateFormat('M/d/yyyy h:mm a');
  static final _amount = NumberFormat('#,##0');

  final selectedTab = PostsTab.pending.obs;

  /// Accordion: only one card expanded at a time.
  final RxnString expandedId = RxnString();

  final RxList<SubmissionEntity> pending = <SubmissionEntity>[].obs;
  final RxList<SubmissionEntity> approved = <SubmissionEntity>[].obs;

  final Rx<RxStatus> pendingStatus = RxStatus.loading().obs;
  final Rx<RxStatus> approvedStatus = RxStatus.loading().obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  void selectTab(PostsTab tab) {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;
    _expandFirstOf(tab == PostsTab.pending ? pending : approved);
  }

  void toggleExpanded(String id) {
    if (expandedId.value == id) {
      expandedId.value = null;
    } else {
      expandedId.value = id;
    }
  }

  bool isExpanded(String id) => expandedId.value == id;

  Future<void> loadAll() async {
    await Future.wait([loadPending(), loadApproved()]);
  }

  Future<void> loadPending() async {
    pendingStatus.value = RxStatus.loading();
    final result = await _getPending(const NoParams());
    result.fold(
      (failure) {
        pendingStatus.value = RxStatus.error(failure.message);
        _syncBadge(0);
      },
      (data) {
        pending.assignAll(data);
        pendingStatus.value = data.isEmpty
            ? RxStatus.empty()
            : RxStatus.success();
        _syncBadge(data.length);
        if (selectedTab.value == PostsTab.pending) {
          _expandFirstOf(data);
        }
      },
    );
  }

  Future<void> loadApproved() async {
    approvedStatus.value = RxStatus.loading();
    final result = await _getApproved(const NoParams());
    result.fold(
      (failure) => approvedStatus.value = RxStatus.error(failure.message),
      (data) {
        approved.assignAll(data);
        approvedStatus.value = data.isEmpty
            ? RxStatus.empty()
            : RxStatus.success();
        if (selectedTab.value == PostsTab.approved) {
          _expandFirstOf(data);
        }
      },
    );
  }

  void _expandFirstOf(List<SubmissionEntity> items) {
    expandedId.value = items.isEmpty ? null : items.first.id;
  }

  void _syncBadge(int count) {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().postsBadgeCount.value = count;
    }
  }

  String platformLabel(String platform) {
    return SocialPlatformType.tryParse(platform)?.displayName ??
        (platform.isEmpty ? '—' : platform);
  }

  String contentTypeLabel(SubmissionEntity item) {
    final url = item.contentUrl.toLowerCase();
    final platform = platformLabel(item.platform);
    if (url.contains('/reel/') ||
        url.contains('/video/') ||
        url.contains('tiktok.com')) {
      return '$platform Video';
    }
    if (url.contains('/p/') ||
        url.contains('permalink') ||
        url.contains('/photo')) {
      return '$platform Post';
    }
    return platform;
  }

  String brandLabel(SubmissionEntity item) {
    final brand = item.brandName.trim();
    return brand.isEmpty ? 'Brand' : brand;
  }

  String metaDateLabel(SubmissionEntity item) {
    final date = item.submittedAt ?? item.createdAt;
    if (date == null) return '';
    return _metaDate.format(date.toLocal()).toUpperCase();
  }

  String statusLabel(SubmissionEntity item) {
    final raw = item.status.trim();
    if (raw.isEmpty) return '—';
    return raw
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (m) => '${m[1]} ${m[2]}',
        )
        .replaceAll('_', ' ');
  }

  String submittedLabel(SubmissionEntity item) {
    final date = item.submittedAt ?? item.createdAt;
    if (date == null) return '—';
    return _submittedDate.format(date.toLocal());
  }

  String rewardEndsLabel(SubmissionEntity item) {
    final ends = item.performanceEndsAt;
    if (ends == null) return '—';
    return 'Ends ${_rewardEnds.format(ends.toLocal())}';
  }

  String? rewardLabel(SubmissionEntity item) {
    final amount = item.displayReward;
    if (amount == null) return null;
    return 'NPR ${_amount.format(amount)}';
  }

  Future<void> openContent(SubmissionEntity item) async {
    final raw = item.contentUrl.trim();
    if (raw.isEmpty) {
      Get.snackbar('Unavailable', 'No post link for this submission.');
      return;
    }
    final uri = Uri.tryParse(raw);
    if (uri == null) {
      Get.snackbar('Invalid link', 'Could not open this post URL.');
      return;
    }
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      Get.snackbar('Unable to open', 'Could not open the post link.');
    }
  }
}
