import 'package:kamao/core/utils/image_url_resolver.dart';

enum SubmissionListKind { pending, approved }

class SubmissionEntity {
  const SubmissionEntity({
    required this.id,
    required this.campaignId,
    required this.campaignCode,
    required this.campaignName,
    required this.brandName,
    required this.status,
    required this.platform,
    required this.contentUrl,
    this.externalPostId,
    this.caption,
    this.reviewComment,
    this.submittedAt,
    this.createdAt,
    this.performanceStartedAt,
    this.performanceEndsAt,
    this.finalViews,
    this.finalLikes,
    this.finalEngagement,
    this.calculatedReward,
    this.rewardBreakdown,
    this.paidAt,
    this.payoutAmount,
    this.thumbnailUrl,
    this.proofUrl,
  });

  final String id;
  final String campaignId;
  final String campaignCode;
  final String campaignName;
  final String brandName;
  final String status;
  final String platform;
  final String contentUrl;
  final String? externalPostId;
  final String? caption;
  final String? reviewComment;
  final DateTime? submittedAt;
  final DateTime? createdAt;
  final DateTime? performanceStartedAt;
  final DateTime? performanceEndsAt;
  final int? finalViews;
  final int? finalLikes;
  final int? finalEngagement;
  final num? calculatedReward;
  final String? rewardBreakdown;
  final DateTime? paidAt;
  final num? payoutAmount;
  final String? thumbnailUrl;
  final String? proofUrl;

  String? get thumbnailImageUrl => resolveImageUrl(thumbnailUrl);

  num? get displayReward => payoutAmount ?? calculatedReward;

  bool get isApprovedTabStatus {
    final s = status.toLowerCase();
    return s.contains('approved') ||
        s.contains('performance') ||
        s.contains('reward') ||
        s.contains('paid');
  }
}
