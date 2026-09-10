import 'campaign_entity.dart';

class RecentCampaignEntity {
  const RecentCampaignEntity({
    required this.campaign,
    required this.lastViewedAt,
  });

  final CampaignEntity campaign;
  final DateTime lastViewedAt;

  RecentCampaignEntity copyWith({CampaignEntity? campaign}) {
    return RecentCampaignEntity(
      campaign: campaign ?? this.campaign,
      lastViewedAt: lastViewedAt,
    );
  }
}
