import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import '../../domain/entities/brand_detail_entity.dart';
import 'brand_profile_model.dart';

class BrandDetailModel extends BrandDetailEntity {
  const BrandDetailModel({required super.brand, required super.campaigns});

  /// [campaignFromJson] is injected on purpose: the campaigns array
  /// on this endpoint is shaped like every other campaign list in the
  /// app, so this should just call your existing
  /// `CampaignModel.fromJson` — pass that in from the repository impl
  /// instead of this file guessing at its fields.
  factory BrandDetailModel.fromJson(
    Map<String, dynamic> json, {
    required CampaignEntity Function(Map<String, dynamic>) campaignFromJson,
  }) {
    final data = json['data'] as Map<String, dynamic>;
    return BrandDetailModel(
      brand: BrandProfileModel.fromJson(data['brand'] as Map<String, dynamic>),
      campaigns: (data['campaigns'] as List<dynamic>? ?? [])
          .map((c) => campaignFromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
