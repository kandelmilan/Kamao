import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import 'package:kamao/src/brand/domain/repositories/brand_repository.dart';
import 'package:kamao/src/brand/domain/usecase/get_brands_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_favourite_brands_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_featured_brands_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_popular_brands_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_recent_brands_usecase.dart';
import 'package:kamao/src/brand/presentation/utils/brand_list_page.dart';
import 'package:kamao/src/brand/presentation/widgets/brand_square_item.dart';
import 'package:kamao/src/home/domain/entities/app_config_entity.dart';
import 'package:kamao/src/home/domain/usecase/get_app_config_usecase.dart';

class BrandsController extends GetxController {
  BrandsController({
    required GetBrandsUseCase getBrands,
    required GetFeaturedBrandsUseCase getFeaturedBrands,
    required GetPopularBrandsUseCase getPopularBrands,
    required GetRecentBrandsUseCase getRecentBrands,
    required GetFavouriteBrandsUseCase getFavouriteBrands,
    required GetAppConfigUseCase getCategories,
  }) : _getBrands = getBrands,
       _getFeaturedBrands = getFeaturedBrands,
       _getPopularBrands = getPopularBrands,
       _getRecentBrands = getRecentBrands,
       _getFavouriteBrands = getFavouriteBrands,
       _getCategories = getCategories;

  final GetBrandsUseCase _getBrands;
  final GetFeaturedBrandsUseCase _getFeaturedBrands;
  final GetPopularBrandsUseCase _getPopularBrands;
  final GetRecentBrandsUseCase _getRecentBrands;
  final GetFavouriteBrandsUseCase _getFavouriteBrands;
  final GetAppConfigUseCase _getCategories;

  final RxList<BrandEntity> featuredBrands = <BrandEntity>[].obs;
  final Rx<RxStatus> featuredStatus = RxStatus.loading().obs;

  final RxList<BrandEntity> newBrands = <BrandEntity>[].obs;
  final Rx<RxStatus> newStatus = RxStatus.loading().obs;

  final RxList<BrandEntity> popularBrands = <BrandEntity>[].obs;
  final Rx<RxStatus> popularStatus = RxStatus.loading().obs;

  final RxList<BrandEntity> recentBrands = <BrandEntity>[].obs;
  final Rx<RxStatus> recentStatus = RxStatus.loading().obs;

  final RxList<BrandEntity> favouriteBrands = <BrandEntity>[].obs;
  final Rx<RxStatus> favouriteStatus = RxStatus.loading().obs;

  final Rx<AppConfigEntity?> appConfig = Rx<AppConfigEntity?>(null);
  final RxList<String> categories = <String>[].obs;
  final Rx<RxStatus> categoriesStatus = RxStatus.loading().obs;

  final RxString searchQuery = ''.obs;
  final RxnString selectedCategory = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    await Future.wait([
      loadFeaturedBrands(),
      loadNewBrands(),
      loadCategories(),
    ]);
  }

  Future<void> loadFeaturedBrands({int take = 12}) async {
    featuredStatus.value = RxStatus.loading();
    final result = await _getFeaturedBrands(TakeParams(take: take));
    result.fold(
      (failure) => featuredStatus.value = RxStatus.error(failure.message),
      (data) {
        featuredBrands.assignAll(data);
        featuredStatus.value = data.isEmpty
            ? RxStatus.empty()
            : RxStatus.success();
      },
    );
  }

  Future<void> loadNewBrands() async {
    newStatus.value = RxStatus.loading();
    final result = await _getBrands(
      BrandQueryParams(
        take: 24,
        category: selectedCategory.value,
        sort: 'new',
      ),
    );
    result.fold(
      (failure) => newStatus.value = RxStatus.error(failure.message),
      (data) {
        newBrands.assignAll(data);
        newStatus.value = data.isEmpty ? RxStatus.empty() : RxStatus.success();
      },
    );
  }

  Future<void> loadPopularBrands({int take = 12}) async {
    popularStatus.value = RxStatus.loading();
    final result = await _getPopularBrands(TakeParams(take: take));
    result.fold(
      (failure) => popularStatus.value = RxStatus.error(failure.message),
      (data) {
        popularBrands.assignAll(data);
        popularStatus.value = data.isEmpty
            ? RxStatus.empty()
            : RxStatus.success();
      },
    );
  }

  Future<void> loadRecentBrands({int take = 12}) async {
    recentStatus.value = RxStatus.loading();
    final result = await _getRecentBrands(TakeParams(take: take));
    result.fold(
      (failure) => recentStatus.value = RxStatus.error(failure.message),
      (data) {
        recentBrands.assignAll(data);
        recentStatus.value = data.isEmpty
            ? RxStatus.empty()
            : RxStatus.success();
      },
    );
  }

  Future<void> loadFavouriteBrands({int take = 48}) async {
    favouriteStatus.value = RxStatus.loading();
    final result = await _getFavouriteBrands(TakeParams(take: take));
    result.fold(
      (failure) => favouriteStatus.value = RxStatus.error(failure.message),
      (data) {
        favouriteBrands.assignAll(data);
        favouriteStatus.value = data.isEmpty
            ? RxStatus.empty()
            : RxStatus.success();
      },
    );
  }

  Future<void> loadCategories() async {
    categoriesStatus.value = RxStatus.loading();
    final result = await _getCategories(NoParams());
    result.fold(
      (failure) => categoriesStatus.value = RxStatus.error(failure.message),
      (data) {
        appConfig.value = data;
        categories.assignAll(data.brandCategories);
        categoriesStatus.value = categories.isEmpty
            ? RxStatus.empty()
            : RxStatus.success();
      },
    );
  }

  void openBrand(BrandEntity brand) => openBrandDetail(brand.id);

  void onSeeAllFeatured() {
    _openList(
      title: 'Featured Brands',
      fetcher: ({required int take}) =>
          _getFeaturedBrands(TakeParams(take: take)),
    );
  }

  void onSeeAllNew() {
    _openList(
      title: 'New Brands',
      fetcher: ({required int take}) => _getBrands(
        BrandQueryParams(
          take: take,
          category: selectedCategory.value,
          sort: 'new',
        ),
      ),
    );
  }

  void onSeeAllPopular() {
    _openList(
      title: 'Popular Brands',
      fetcher: ({required int take}) =>
          _getPopularBrands(TakeParams(take: take)),
    );
  }

  void onSeeAllRecent() {
    _openList(
      title: 'Recent Brands',
      fetcher: ({required int take}) =>
          _getRecentBrands(TakeParams(take: take)),
    );
  }

  void onSeeAllFavourites() {
    _openList(
      title: 'Favourite Brands',
      fetcher: ({required int take}) =>
          _getFavouriteBrands(TakeParams(take: take)),
    );
  }

  void onCategorySelected(String? category) {
    if (category == null) return;
    _openList(
      title: category,
      fetcher: ({required int take}) => _getBrands(
        BrandQueryParams(take: take, category: category),
      ),
    );
  }

  void seeAllBrands() {
    _openList(
      title: 'All Brands',
      fetcher: ({required int take}) =>
          _getBrands(BrandQueryParams(take: take)),
    );
  }

  void _openList({
    required String title,
    required Future<Either<Failure, List<BrandEntity>>> Function({
      required int take,
    })
    fetcher,
  }) {
    Get.to(
      () => BrandListPage(
        title: title,
        fetcher: fetcher,
        onBrandTap: openBrand,
      ),
    );
  }
}
