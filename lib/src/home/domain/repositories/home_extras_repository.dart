import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/campaign/favourite_campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/rewarded_post_entity.dart';
import '../entities/home_category_entity.dart';

/// "Extras" here means the Home-tab content that isn't the wallet —
/// popular brands, featured brands, categories. Kept separate from
/// WalletRepository since it's a distinct API surface
/// (/creator/home/*) with its own lifecycle, even though both feed
/// the same HomeController.
abstract class HomeExtrasRepository {
  Future<Either<Failure, List<HomeCategoryEntity>>> getHomeCategories();
  Future<Either<Failure, List<RewardedPostEntity>>> getRecentlyRewarded({
    int take = 12,
  });
  Future<Either<Failure, List<CampaignEntity>>> getCampaigns({
    int take = 12,
    String? category,
  });
  Future<Either<Failure, List<CampaignEntity>>> getPopularCampaigns({
    int take = 12,
  });
  Future<Either<Failure, List<FavouriteCampaignEntity>>> getFavouriteCampaigns({
    int take = 24,
  });
}
