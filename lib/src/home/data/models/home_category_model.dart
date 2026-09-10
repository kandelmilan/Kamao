import '../../domain/entities/home_category_entity.dart';

class HomeCategoryModel extends HomeCategoryEntity {
  const HomeCategoryModel({
    required super.name,
    required super.brandCount,
    required super.liveCampaignCount,
    super.coverImageUrl,
    super.logoUrl,
  });

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModel(
      name: json['name'] as String? ?? '',
      brandCount: (json['brandCount'] as num?)?.toInt() ?? 0,
      liveCampaignCount: (json['liveCampaignCount'] as num?)?.toInt() ?? 0,
      coverImageUrl: json['coverImageUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
    );
  }
}
