import 'package:kamao/src/home/domain/entities/campaign/recent_campaign_entity.dart';
import 'campaign_model.dart';

class RecentCampaignModel extends RecentCampaignEntity {
  RecentCampaignModel({required super.campaign, required super.lastViewedAt});

  factory RecentCampaignModel.fromJson(Map<String, dynamic> json) {
    return RecentCampaignModel(
      campaign: CampaignModel.fromJson(
        json['campaign'] as Map<String, dynamic>,
      ),
      lastViewedAt: DateTime.parse(json['lastViewedAt'] as String),
    );
  }
}
