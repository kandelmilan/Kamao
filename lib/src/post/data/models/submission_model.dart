import '../../domain/entities/submission_entity.dart';

class SubmissionModel extends SubmissionEntity {
  const SubmissionModel({
    required super.id,
    required super.campaignId,
    required super.campaignCode,
    required super.campaignName,
    required super.brandName,
    required super.status,
    required super.platform,
    required super.contentUrl,
    super.externalPostId,
    super.caption,
    super.reviewComment,
    super.submittedAt,
    super.createdAt,
    super.performanceStartedAt,
    super.performanceEndsAt,
    super.finalViews,
    super.finalLikes,
    super.finalEngagement,
    super.calculatedReward,
    super.rewardBreakdown,
    super.paidAt,
    super.payoutAmount,
    super.thumbnailUrl,
    super.proofUrl,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] as String? ?? '',
      campaignId: json['campaignId'] as String? ?? '',
      campaignCode: json['campaignCode'] as String? ?? '',
      campaignName: json['campaignName'] as String? ?? '',
      brandName: json['brandName'] as String? ?? '',
      status: json['status'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      contentUrl: json['contentUrl'] as String? ?? '',
      externalPostId: json['externalPostId'] as String?,
      caption: json['caption'] as String?,
      reviewComment: json['reviewComment'] as String?,
      submittedAt: _parseDate(json['submittedAt']),
      createdAt: _parseDate(json['createdAt']),
      performanceStartedAt: _parseDate(json['performanceStartedAt']),
      performanceEndsAt: _parseDate(json['performanceEndsAt']),
      finalViews: (json['finalViews'] as num?)?.toInt(),
      finalLikes: (json['finalLikes'] as num?)?.toInt(),
      finalEngagement: (json['finalEngagement'] as num?)?.toInt(),
      calculatedReward: json['calculatedReward'] as num?,
      rewardBreakdown: json['rewardBreakdown'] as String?,
      paidAt: _parseDate(json['paidAt']),
      payoutAmount: json['payoutAmount'] as num?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      proofUrl: json['proofUrl'] as String?,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
