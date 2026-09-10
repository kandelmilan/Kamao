import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/data/models/brand_model.dart';
import 'package:kamao/src/home/data/models/campaign/campaign_model.dart';
import '../models/brand_detail_model.dart';

/// Talks to the API only — no Either/Failure wrapping here, that's
/// the repository's job. Throws on any transport/parsing error and
/// lets the repository translate that into a Failure.
abstract class BrandRemoteDataSource {
  Future<BrandDetailModel> getBrandDetail(String brandId);
  Future<List<BrandModel>> getPopularBrands({int take = 12});
  Future<List<BrandModel>> getFeaturedBrands({int take = 12});
}

class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  BrandRemoteDataSourceImpl(this._apiService);
  final ApiService _apiService;

  @override
  Future<BrandDetailModel> getBrandDetail(String brandId) async {
    final response = await _apiService.get('/creator/brands/$brandId');
    return BrandDetailModel.fromJson(
      response.data as Map<String, dynamic>,
      campaignFromJson: CampaignModel.fromJson,
    );
  }

  @override
  Future<List<BrandModel>> getPopularBrands({int take = 12}) async {
    final response = await _apiService.get(
      ApiEndpoints.homePopularBrands,
      queryParameters: {'take': take},
    );
    final data = (response.data['data'] as List<dynamic>?) ?? const [];
    return data
        .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<BrandModel>> getFeaturedBrands({int take = 12}) async {
    final response = await _apiService.get(
      ApiEndpoints.homeFeaturedBrands,
      queryParameters: {'take': take},
    );
    final data = (response.data['data'] as List<dynamic>?) ?? const [];
    return data
        .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
