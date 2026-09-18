import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/brand.dart';
import 'package:kamao/src/home/data/datasources/marketplace_remote_data_source.dart';
import 'package:kamao/src/home/data/repositories/marketplace_repository_impl.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';

class BrandDetailBinding extends Bindings {
  BrandDetailBinding({required this.brandId});

  final String brandId;

  @override
  void dependencies() {
    final apiService = Get.find<ApiService>();

    final dataSource = BrandRemoteDataSourceImpl(apiService);
    final repository = BrandRepositoryImpl(dataSource);
    final marketplaceRepository = MarketplaceRepositoryImpl(
      MarketplaceRemoteDataSourceImpl(apiService),
    );

    Get.put(
      BrandDetailController(
        GetBrandDetailUseCase(repository),
        ViewBrandUseCase(repository),
        FavouriteBrandUseCase(repository),
        UnfavouriteBrandUseCase(repository),
        GetCampaignDetailUseCase(marketplaceRepository),
        brandId: brandId,
      ),
      tag: brandId,
    );
  }
}
