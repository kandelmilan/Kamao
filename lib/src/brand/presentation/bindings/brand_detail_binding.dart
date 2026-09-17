import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/brand.dart';


class BrandDetailBinding extends Bindings {
  BrandDetailBinding({required this.brandId});

  final String brandId;

  @override
  void dependencies() {
    final apiService = Get.find<ApiService>();

    final dataSource = BrandRemoteDataSourceImpl(apiService);
    final repository = BrandRepositoryImpl(dataSource);

    Get.put(
      BrandDetailController(
        GetBrandDetailUseCase(repository),
        ViewBrandUseCase(repository),
        FavouriteBrandUseCase(repository),
        UnfavouriteBrandUseCase(repository),
        brandId: brandId,
      ),
      tag: brandId,
    );
  }
}
