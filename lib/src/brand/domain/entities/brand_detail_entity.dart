import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'brand_profile_entity.dart';

class BrandDetailEntity {
  const BrandDetailEntity({required this.brand, required this.campaigns});

  final BrandProfileEntity brand;
  final List<CampaignEntity> campaigns;

  BrandDetailEntity copyWith({
    BrandProfileEntity? brand,
    List<CampaignEntity>? campaigns,
  }) {
    return BrandDetailEntity(
      brand: brand ?? this.brand,
      campaigns: campaigns ?? this.campaigns,
    );
  }
}
