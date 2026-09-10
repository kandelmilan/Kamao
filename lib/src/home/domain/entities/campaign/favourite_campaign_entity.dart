import 'campaign_entity.dart';

/// Wraps a [CampaignEntity] with the timestamp the creator favourited
/// it — as returned by /creator/home/favourite-campaigns.
class FavouriteCampaignEntity {
  const FavouriteCampaignEntity({
    required this.campaign,
    required this.favouritedAt,
  });

  final CampaignEntity campaign;
  final DateTime favouritedAt;

  FavouriteCampaignEntity copyWith({CampaignEntity? campaign}) {
    return FavouriteCampaignEntity(
      campaign: campaign ?? this.campaign,
      favouritedAt: favouritedAt,
    );
  }
}
