import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/campaign/recent_campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:kamao/src/home/domain/entities/marketplace_campaign_entity.dart';

abstract class MarketplaceRepository {
  Future<Either<Failure, List<RecentCampaignEntity>>> getRecentCampaigns({
    int take = 12,
  });

  Future<Either<Failure, bool>> joinCampaign(String campaignId);

  Future<Either<Failure, CampaignDetailEntity>> getCampaignDetail(
    String campaignId,
  );
  Future<Either<Failure, bool>> favouriteCampaign(String campaignId);
  Future<Either<Failure, bool>> unfavouriteCampaign(String campaignId);
  Future<Either<Failure, bool>> viewCampaign(String campaignId);

  Future<Either<Failure, List<MarketplaceCampaignEntity>>>
  getFeaturedCampaigns({int take = 12, String? category});
  Future<Either<Failure, List<MarketplaceCampaignEntity>>>
  getMarketplaceCampaigns({String sort = 'new', String? category});
}
