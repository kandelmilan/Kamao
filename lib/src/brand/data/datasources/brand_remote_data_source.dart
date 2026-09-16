import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/data/models/brand_model.dart';
import 'package:kamao/src/home/data/models/campaign/campaign_model.dart';
import '../models/brand_detail_model.dart';

abstract class BrandRemoteDataSource {
  Future<BrandDetailModel> getBrandDetail(String brandId);

  Future<List<BrandModel>> getBrands({
    int take = 48,
    String? category,
    String? sort,
  });

  Future<List<BrandModel>> getPopularBrands({int take = 12});
  Future<List<BrandModel>> getFeaturedBrands({int take = 12});
  Future<List<BrandModel>> getRecentBrands({int take = 12});
  Future<List<BrandModel>> getFavouriteBrands({int take = 48});

  Future<bool> viewBrand(String brandId);
  Future<bool> favouriteBrand(String brandId);
  Future<bool> unfavouriteBrand(String brandId);
}

class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  BrandRemoteDataSourceImpl(this._apiService);
  final ApiService _apiService;

  List<BrandModel> _parseList(dynamic responseData) {
    final data = (responseData['data'] as List<dynamic>?) ?? const [];
    return data.map((e) {
      final map = e as Map<String, dynamic>;
      // Recent (and similar) endpoints wrap as { brand, lastViewedAt }.
      final brandJson = map['brand'] is Map<String, dynamic>
          ? map['brand'] as Map<String, dynamic>
          : map;
      return BrandModel.fromJson(brandJson);
    }).toList();
  }

  bool _parseBool(dynamic responseData) {
    final data = responseData is Map ? responseData['data'] : null;
    if (data is bool) return data;
    return false;
  }

  @override
  Future<BrandDetailModel> getBrandDetail(String brandId) async {
    final response = await _apiService.get(ApiEndpoints.brandDetail(brandId));
    return BrandDetailModel.fromJson(
      response.data as Map<String, dynamic>,
      campaignFromJson: CampaignModel.fromJson,
    );
  }

  @override
  Future<List<BrandModel>> getBrands({
    int take = 48,
    String? category,
    String? sort,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.brands,
      queryParameters: {
        'take': take,
        if (category != null && category.isNotEmpty) 'category': category,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
      },
    );
    return _parseList(response.data);
  }

  @override
  Future<List<BrandModel>> getPopularBrands({int take = 12}) async {
    final response = await _apiService.get(
      ApiEndpoints.brandsPopular,
      queryParameters: {'take': take},
    );
    return _parseList(response.data);
  }

  @override
  Future<List<BrandModel>> getFeaturedBrands({int take = 12}) async {
    final response = await _apiService.get(
      ApiEndpoints.brandsFeatured,
      queryParameters: {'take': take},
    );
    return _parseList(response.data);
  }

  @override
  Future<List<BrandModel>> getRecentBrands({int take = 12}) async {
    final response = await _apiService.get(
      ApiEndpoints.brandsRecent,
      queryParameters: {'take': take},
    );
    return _parseList(response.data);
  }

  @override
  Future<List<BrandModel>> getFavouriteBrands({int take = 48}) async {
    final response = await _apiService.get(
      ApiEndpoints.brandsFavourites,
      queryParameters: {'take': take},
    );
    return _parseList(response.data);
  }

  @override
  Future<bool> viewBrand(String brandId) async {
    final response = await _apiService.post(
      ApiEndpoints.brandView(brandId),
      data: '',
    );
    return _parseBool(response.data);
  }

  @override
  Future<bool> favouriteBrand(String brandId) async {
    final response = await _apiService.post(
      ApiEndpoints.brandFavourite(brandId),
      data: '',
    );
    return _parseBool(response.data);
  }

  @override
  Future<bool> unfavouriteBrand(String brandId) async {
    final response = await _apiService.post(
      ApiEndpoints.brandUnfavourite(brandId),
      data: '',
    );
    return _parseBool(response.data);
  }
}
