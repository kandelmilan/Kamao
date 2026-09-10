import 'package:kamao/src/home/domain/entities/campaign/favourite_campaign_entity.dart';
import 'campaign_model.dart';

class FavouriteCampaignModel extends FavouriteCampaignEntity {
  FavouriteCampaignModel({
    required super.campaign,
    required super.favouritedAt,
  });

  factory FavouriteCampaignModel.fromJson(Map<String, dynamic> json) {
    return FavouriteCampaignModel(
      campaign: CampaignModel.fromJson(
        json['campaign'] as Map<String, dynamic>,
      ),
      favouritedAt: DateTime.parse(json['favouritedAt'] as String),
    );
  }
}
