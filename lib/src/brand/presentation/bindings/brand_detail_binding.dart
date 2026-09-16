import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/usecase/favourite_brand_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_brand_detail_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/view_brand_usecase.dart';
import '../../data/datasources/brand_remote_data_source.dart';
import '../../data/repositories/brand_repository_impl.dart';
import '../controllers/brand_detail_controller.dart';

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
