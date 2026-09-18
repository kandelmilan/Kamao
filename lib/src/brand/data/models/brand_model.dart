import 'package:kamao/core/utils/campaign_platforms.dart';

import '../../domain/entities/brand_entity.dart';

class BrandModel extends BrandEntity {
  const BrandModel({
    required super.id,
    required super.code,
    required super.name,
    super.logoUrl,
    super.coverImageUrl,
    super.categoryName,
    super.bio,
    required super.maxRewardAmount,
    required super.receiptRequired,
    required super.currency,
    required super.liveCampaignCount,
    required super.rewardedPostCount,
    super.isFavourite,
    super.platforms,
    super.contentTypes,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      categoryName: json['categoryName'] as String?,
      bio: json['bio'] as String?,
      maxRewardAmount: (json['maxRewardAmount'] as num?) ?? 0,
      receiptRequired: json['receiptRequired'] as bool? ?? false,
      currency: json['currency'] as String? ?? '',
      liveCampaignCount: (json['liveCampaignCount'] as num?)?.toInt() ?? 0,
      rewardedPostCount: (json['rewardedPostCount'] as num?)?.toInt() ?? 0,
      isFavourite: json['isFavourite'] as bool? ?? false,
      platforms: _parseStringList(json['platforms']),
      contentTypes: _parseContentTypes(json),
    );
  }

  static List<String> _parseContentTypes(Map<String, dynamic> json) {
    final direct = _parseStringList(
      json['contentTypes'] ?? json['contentType'],
    );
    if (direct.isNotEmpty) return direct;

    final directives = json['directives'];
    if (directives is! List) return const [];
    return contentTypesFromDirectives(
      directives.whereType<Map>().map(
            (e) => (
              directiveType: e['directiveType']?.toString() ?? '',
              valueText: e['valueText']?.toString() ?? '',
            ),
          ),
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return const [];
    if (value is String) {
      return value
          .split(RegExp(r'[/|,;]+'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    if (value is List) {
      return value
          .map((e) => e.toString().trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return const [];
  }
}
