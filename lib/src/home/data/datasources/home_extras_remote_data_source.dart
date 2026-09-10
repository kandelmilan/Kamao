import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/data/models/campaign/campaign_model.dart';
import 'package:kamao/src/home/data/models/campaign/favourite_campaign_model.dart';
import '../models/home_category_model.dart';
import '../models/rewarded_post_model.dart';

abstract class HomeExtrasRemoteDataSource {
  Future<List<HomeCategoryModel>> getHomeCategories();
  Future<List<RewardedPostModel>> getRecentlyRewarded({int take = 12});
  Future<List<CampaignModel>> getCampaigns({int take = 12, String? category});
  Future<List<CampaignModel>> getPopularCampaigns({int take = 12});
  Future<List<FavouriteCampaignModel>> getFavouriteCampaigns({int take = 24});
}

class HomeExtrasRemoteDataSourceImpl implements HomeExtrasRemoteDataSource {
  HomeExtrasRemoteDataSourceImpl(this._apiService);
  final ApiService _apiService;
  @override
  Future<List<HomeCategoryModel>> getHomeCategories() async {
    final response = await _apiService.get(ApiEndpoints.homeCategories);
    final data = (response.data['data'] as List<dynamic>?) ?? const [];
    return data
        .map((e) => HomeCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<RewardedPostModel>> getRecentlyRewarded({int take = 12}) async {
    final response = await _apiService.get(
      ApiEndpoints.homeRecentlyRewarded,
      queryParameters: {'take': take},
    );
    final data = (response.data['data'] as List<dynamic>?) ?? const [];
    return data
        .map((e) => RewardedPostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CampaignModel>> getCampaigns({
    int take = 12,
    String? category,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.homeCampaigns,
      queryParameters: {
        'take': take,
        if (category != null && category.isNotEmpty) 'category': category,
      },
    );
    final data = (response.data['data'] as List<dynamic>?) ?? const [];
    return data
        .map((e) => CampaignModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CampaignModel>> getPopularCampaigns({int take = 12}) async {
    final response = await _apiService.get(
      ApiEndpoints.homePopularCampaigns,
      queryParameters: {'take': take},
    );
    final data = (response.data['data'] as List<dynamic>?) ?? const [];
    return data
        .map((e) => CampaignModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<FavouriteCampaignModel>> getFavouriteCampaigns({
    int take = 24,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.homeFavouriteCampaigns,
      queryParameters: {'take': take},
    );
    final data = (response.data['data'] as List<dynamic>?) ?? const [];
    return data
        .map((e) => FavouriteCampaignModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
