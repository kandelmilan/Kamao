import 'package:get/get.dart';
import 'package:kamao/src/brand/data/datasources/brand_remote_data_source.dart';
import 'package:kamao/src/brand/data/repositories/brand_repository_impl.dart';
import 'package:kamao/src/brand/domain/repositories/brand_repository.dart';
import 'package:kamao/src/brand/domain/usecase/get_brands_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_favourite_brands_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_featured_brands_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_popular_brands_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_recent_brands_usecase.dart';
import 'package:kamao/src/brand/presentation/controllers/brands_controller.dart';
import 'package:kamao/src/home/home.dart';


class BrandsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrandRemoteDataSource>(
      () => BrandRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<BrandRepository>(
      () => BrandRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut(() => GetBrandsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetFeaturedBrandsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetPopularBrandsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetRecentBrandsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetFavouriteBrandsUseCase(Get.find()), fenix: true);

    if (!Get.isRegistered<AppConfigRemoteDataSource>()) {
      Get.lazyPut<AppConfigRemoteDataSource>(
        () => AppConfigRemoteDataSourceImpl(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<AppConfigRepository>()) {
      Get.lazyPut<AppConfigRepository>(
        () => AppConfigRepositoryImpl(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetAppConfigUseCase>()) {
      Get.lazyPut(() => GetAppConfigUseCase(Get.find()), fenix: true);
    }

    Get.lazyPut(
      () => BrandsController(
        getBrands: Get.find(),
        getFeaturedBrands: Get.find(),
        getPopularBrands: Get.find(),
        getRecentBrands: Get.find(),
        getFavouriteBrands: Get.find(),
        getCategories: Get.find(),
      ),
    );
  }
}
