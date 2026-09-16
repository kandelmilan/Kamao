import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import '../../domain/entities/brand_detail_entity.dart';
import 'brand_profile_model.dart';

class BrandDetailModel extends BrandDetailEntity {
  const BrandDetailModel({required super.brand, required super.campaigns});

  factory BrandDetailModel.fromJson(
    Map<String, dynamic> json, {
    required CampaignEntity Function(Map<String, dynamic>) campaignFromJson,
  }) {
    final data = json['data'] as Map<String, dynamic>? ?? const {};
    final brandJson = data['brand'] as Map<String, dynamic>? ?? const {};
    final campaignsJson = data['campaigns'] as List<dynamic>? ?? const [];

    final campaigns = <CampaignEntity>[];
    for (final raw in campaignsJson) {
      if (raw is! Map<String, dynamic>) continue;
      try {
        campaigns.add(campaignFromJson(raw));
      } catch (_) {
        // Skip malformed campaign rows so the brand page still loads.
      }
    }

    return BrandDetailModel(
      brand: BrandProfileModel.fromJson(brandJson),
      campaigns: campaigns,
    );
  }
}
