import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/data/models/campaign/recent_campaign_model.dart';
import 'package:kamao/src/home/data/models/campaign/campaign_detail_model.dart';
import 'package:kamao/src/home/data/models/marketplace_campaign_model.dart';

abstract class MarketplaceRemoteDataSource {
  Future<List<RecentCampaignModel>> getRecentCampaigns({int take = 12});
  Future<bool> joinCampaign(String campaignId);
  Future<CampaignDetailModel> getCampaignDetail(String campaignId);
  Future<bool> toggleFavouriteCampaign(String campaignId);
  Future<bool> viewCampaign(String campaignId);
  Future<List<MarketplaceCampaignModel>> getFeaturedCampaigns({
    int take = 12,
    String? category,
  });
  Future<List<MarketplaceCampaignModel>> getMarketplaceCampaigns({
    String sort = 'new',
    String? category,
  });
}

class MarketplaceRemoteDataSourceImpl implements MarketplaceRemoteDataSource {
  MarketplaceRemoteDataSourceImpl(this._apiService);
  final ApiService _apiService;

  @override
  Future<List<RecentCampaignModel>> getRecentCampaigns({int take = 12}) async {
    final response = await _apiService.get(
      ApiEndpoints.marketplaceRecent,
      queryParameters: {'take': take},
    );
    final data = (response.data['data'] as List<dynamic>?) ?? const [];
    return data
        .map((e) => RecentCampaignModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> joinCampaign(String campaignId) async {
    final response = await _apiService.post(
      ApiEndpoints.marketplaceJoin(campaignId),
    );
    return response.data['data'] as bool? ?? false;
  }

  @override
  Future<CampaignDetailModel> getCampaignDetail(String campaignId) async {
    final response = await _apiService.get(
      ApiEndpoints.marketplaceDetail(campaignId),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return CampaignDetailModel.fromJson(data);
  }

  @override
  Future<bool> toggleFavouriteCampaign(String campaignId) async {
    final response = await _apiService.put(
      ApiEndpoints.marketplaceFavourite(campaignId),
    );
    return response.data['data'] as bool? ?? false;
  }

  @override
  Future<bool> viewCampaign(String campaignId) async {
    final response = await _apiService.post(
      ApiEndpoints.marketplaceView(campaignId),
    );
    return response.data['data'] as bool? ?? false;
  }

  @override
  Future<List<MarketplaceCampaignModel>> getFeaturedCampaigns({
    int take = 12,
    String? category,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.marketplaceFeatured,
      queryParameters: {
        'take': take,
        if (category != null) 'category': category,
      },
    );
    final data = (response.data['data'] as List<dynamic>?) ?? const [];
    return data
        .map(
          (e) => MarketplaceCampaignModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<MarketplaceCampaignModel>> getMarketplaceCampaigns({
    String sort = 'new',
    String? category,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.marketplaceList,
      queryParameters: {
        'sort': sort,
        if (category != null) 'category': category,
      },
    );
    final data = (response.data['data'] as List<dynamic>?) ?? const [];
    return data
        .map(
          (e) => MarketplaceCampaignModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
