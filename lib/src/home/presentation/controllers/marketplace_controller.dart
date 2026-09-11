// import 'package:dartz/dartz.dart';
// import 'package:get/get.dart';
// import 'package:kamao/app/app.dart';
// import 'package:kamao/core/core.dart';
// import 'package:kamao/src/home/domain/entities/app_config_entity.dart';
// import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
// import 'package:kamao/src/home/domain/entities/marketplace_campaign_entity.dart';
// import 'package:kamao/src/home/domain/usecase/campaign/get_campaigns_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/get_app_config_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/marketplace/get_featured_campaigns_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/marketplace/get_new_campaigns_usecase.dart';
// import 'package:kamao/src/home/domain/usecase/marketplace/toggle_favourite_campaign_usecase.dart';
// import 'package:kamao/src/home/presentation/utils/campaign_list/campaign_list_page.dart';

// class MarketplaceController extends GetxController {
//   MarketplaceController({
//     required GetCampaignsUseCase getCampaignsUseCase,
//     required GetFeaturedCampaignsUsecase getFeaturedCampaigns,
//     required GetNewCampaignsUsecase getNewCampaigns,
//     required GetAppConfigUseCase getCategories,
//     required ToggleFavouriteCampaignUseCase toggleFavourite,
//   }) : _getCampaignsUseCase = getCampaignsUseCase,
//        _getFeaturedCampaigns = getFeaturedCampaigns,
//        _getNewCampaigns = getNewCampaigns,
//        _getCategories = getCategories,
//        _toggleFavourite = toggleFavourite;
//   final GetCampaignsUseCase _getCampaignsUseCase;
//   final GetFeaturedCampaignsUsecase _getFeaturedCampaigns;
//   final GetNewCampaignsUsecase _getNewCampaigns;
//   final GetAppConfigUseCase _getCategories;
//   final ToggleFavouriteCampaignUseCase _toggleFavourite;

//   // Featured campaigns
//   final RxList<MarketplaceCampaignEntity> featuredCampaigns =
//       <MarketplaceCampaignEntity>[].obs;
//   final Rx<RxStatus> featuredStatus = RxStatus.loading().obs;

//   // New campaigns
//   final RxList<MarketplaceCampaignEntity> newCampaigns =
//       <MarketplaceCampaignEntity>[].obs;
//   final Rx<RxStatus> newStatus = RxStatus.loading().obs;

//   // App config / categories
//   final Rx<AppConfigEntity?> appConfig = Rx<AppConfigEntity?>(null);
//   final RxList<String> categories = <String>[].obs;
//   final Rx<RxStatus> categoriesStatus = RxStatus.loading().obs;

//   final RxString searchQuery = ''.obs;
//   final RxnString selectedCategory = RxnString();

//   @override
//   void onInit() {
//     super.onInit();
//     loadAll();
//   }

//   Future<void> loadAll() async {
//     await Future.wait([
//       loadFeaturedCampaigns(),
//       loadNewCampaigns(),
//       loadCategories(),
//     ]);
//   }

//   Future<void> loadFeaturedCampaigns({int take = 12}) async {
//     featuredStatus.value = RxStatus.loading();
//     final result = await _getFeaturedCampaigns(
//       FeaturedCampaignsParams(take: take, category: selectedCategory.value),
//     );
//     result.fold(
//       (failure) {
//         featuredStatus.value = RxStatus.error(failure.message);
//       },
//       (data) {
//         featuredCampaigns.assignAll(data);
//         featuredStatus.value = data.isEmpty
//             ? RxStatus.empty()
//             : RxStatus.success();
//       },
//     );
//   }

//   Future<void> loadNewCampaigns({String sort = 'new'}) async {
//     newStatus.value = RxStatus.loading();
//     final result = await _getNewCampaigns(
//       NewCampaignsParams(sort: sort, category: selectedCategory.value),
//     );
//     result.fold(
//       (failure) {
//         newStatus.value = RxStatus.error(failure.message);
//       },
//       (data) {
//         newCampaigns.assignAll(data);
//         newStatus.value = data.isEmpty ? RxStatus.empty() : RxStatus.success();
//       },
//     );
//   }

//   Future<void> loadCategories() async {
//     categoriesStatus.value = RxStatus.loading();
//     final result = await _getCategories(NoParams());
//     result.fold(
//       (failure) {
//         categoriesStatus.value = RxStatus.error(failure.message);
//       },
//       (data) {
//         appConfig.value = data;
//         categories.assignAll(data.brandCategories);
//         categoriesStatus.value = categories.isEmpty
//             ? RxStatus.empty()
//             : RxStatus.success();
//       },
//     );
//   }

//   // Future<void> onCategorySelected(String? category) async {
//   // }
//   Future<void> onCategorySelected(String? category) async {
//     if (category == null) return;

//     Get.to(
//       () => CampaignListPage(
//         title: category,
//         take: 12,
//         enableSearch: false, // GetCampaignsUseCase has no search param
//         fetcher: ({required int page, required int take, String? search}) {
//           if (page > 0) {
//             return Future.value(const Right<Failure, List<CampaignEntity>>([]));
//           }
//           return _getCampaignsUseCase(
//             CampaignFilterParams(take: take, category: category),
//           );
//         },
//         emptyMessage: 'No campaigns found in $category',
//         onCampaignTap: (campaign) =>
//             Get.toNamed(AppRoutes.campaignDetail, arguments: campaign.id),
//       ),
//     );
//   }

//   Future<void> toggleFavourite(String campaignId) async {
//     final result = await _toggleFavourite(CampaignIdParams(campaignId));
//     result.fold(
//       (failure) => Get.snackbar('Error', failure.message),
//       (isFavourite) => _updateFavouriteState(campaignId, isFavourite),
//     );
//   }

//   void _updateFavouriteState(String campaignId, bool isFavourite) {
//     final fIndex = featuredCampaigns.indexWhere((c) => c.id == campaignId);
//     if (fIndex != -1) {
//       featuredCampaigns[fIndex] = _copyWithFavourite(
//         featuredCampaigns[fIndex],
//         isFavourite,
//       );
//     }
//     final nIndex = newCampaigns.indexWhere((c) => c.id == campaignId);
//     if (nIndex != -1) {
//       newCampaigns[nIndex] = _copyWithFavourite(
//         newCampaigns[nIndex],
//         isFavourite,
//       );
//     }
//   }

//   MarketplaceCampaignEntity _copyWithFavourite(
//     MarketplaceCampaignEntity entity,
//     bool isFavourite,
//   ) {
//     return (entity as dynamic).copyWith(isFavourite: isFavourite);
//   }
// }
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/home/domain/entities/app_config_entity.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/marketplace_campaign_entity.dart';
import 'package:kamao/src/home/domain/repositories/marketplace_repository.dart';
import 'package:kamao/src/home/domain/usecase/campaign/get_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/get_app_config_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_featured_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_new_campaigns_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/toggle_favourite_campaign_usecase.dart';
import 'package:kamao/src/home/presentation/utils/campaign_list/campaign_list_page.dart';
import 'package:kamao/src/home/presentation/utils/featured_campaigns_list/featured_campaigns_list.dart';

class MarketplaceController extends GetxController {
  MarketplaceController({
    required GetCampaignsUseCase getCampaignsUseCase,
    required GetFeaturedCampaignsUsecase getFeaturedCampaigns,
    required GetNewCampaignsUsecase getNewCampaigns,
    required GetAppConfigUseCase getCategories,
    required ToggleFavouriteCampaignUseCase toggleFavourite,
  }) : _getCampaignsUseCase = getCampaignsUseCase,
       _getFeaturedCampaigns = getFeaturedCampaigns,
       _getNewCampaigns = getNewCampaigns,
       _getCategories = getCategories,
       _toggleFavourite = toggleFavourite;
  final GetCampaignsUseCase _getCampaignsUseCase;
  final GetFeaturedCampaignsUsecase _getFeaturedCampaigns;
  final GetNewCampaignsUsecase _getNewCampaigns;
  final GetAppConfigUseCase _getCategories;
  final ToggleFavouriteCampaignUseCase _toggleFavourite;

  // Featured campaigns
  final RxList<MarketplaceCampaignEntity> featuredCampaigns =
      <MarketplaceCampaignEntity>[].obs;
  final Rx<RxStatus> featuredStatus = RxStatus.loading().obs;

  // New campaigns
  final RxList<MarketplaceCampaignEntity> newCampaigns =
      <MarketplaceCampaignEntity>[].obs;
  final Rx<RxStatus> newStatus = RxStatus.loading().obs;

  // App config / categories
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
      loadFeaturedCampaigns(),
      loadNewCampaigns(),
      loadCategories(),
    ]);
  }

  Future<void> loadFeaturedCampaigns({int take = 12}) async {
    featuredStatus.value = RxStatus.loading();
    final result = await _getFeaturedCampaigns(
      FeaturedCampaignsParams(take: take, category: selectedCategory.value),
    );
    result.fold(
      (failure) {
        featuredStatus.value = RxStatus.error(failure.message);
      },
      (data) {
        featuredCampaigns.assignAll(data);
        featuredStatus.value = data.isEmpty
            ? RxStatus.empty()
            : RxStatus.success();
      },
    );
  }

  Future<void> loadNewCampaigns({String sort = 'new'}) async {
    newStatus.value = RxStatus.loading();
    final result = await _getNewCampaigns(
      NewCampaignsParams(sort: sort, category: selectedCategory.value),
    );
    result.fold(
      (failure) {
        newStatus.value = RxStatus.error(failure.message);
      },
      (data) {
        newCampaigns.assignAll(data);
        newStatus.value = data.isEmpty ? RxStatus.empty() : RxStatus.success();
      },
    );
  }

  Future<void> loadCategories() async {
    categoriesStatus.value = RxStatus.loading();
    final result = await _getCategories(NoParams());
    result.fold(
      (failure) {
        categoriesStatus.value = RxStatus.error(failure.message);
      },
      (data) {
        appConfig.value = data;
        categories.assignAll(data.brandCategories);
        categoriesStatus.value = categories.isEmpty
            ? RxStatus.empty()
            : RxStatus.success();
      },
    );
  }

  Future<void> onCategorySelected(String? category) async {
    if (category == null) return;

    Get.to(
      () => CampaignListPage<CampaignEntity>(
        title: category,
        take: 12,
        enableSearch: true,
        idOf: (c) => c.id,
        nameOf: (c) => c.brandName,
        logoUrlOf: (c) => resolveImageUrl(c.brandLogoUrl),
        fetcher: ({required int page, required int take, String? search}) {
          if (page > 1) {
            return Future.value(const Right<Failure, List<CampaignEntity>>([]));
          }
          return _getCampaignsUseCase(
            CampaignFilterParams(take: take, category: category),
          );
        },
        emptyMessage: 'No campaigns found in $category',
        onCampaignTap: (campaign) =>
            Get.toNamed(AppRoutes.campaignDetail, arguments: campaign.id),
      ),
    );
  }

  Future<void> onSeeAllFeatured() async {
    final marketplaceRepository = Get.find<MarketplaceRepository>();

    Get.to(
      () => FeaturedCampaignsPage<MarketplaceCampaignEntity>(
        title: 'Featured Campaigns',
        fetcher: ({required page, required take, search}) =>
            marketplaceRepository.getFeaturedCampaigns(take: take),
        nameOf: (c) => c.brandName,
        subtitleOf: (c) => c.objective,
        coverUrlOf: (c) => resolveImageUrl(c.brandCoverUrl),
        onCampaignTap: (c) =>
            Get.toNamed(AppRoutes.campaignDetail, arguments: c.id),
      ),
    );
  }

  Future<void> onSeeAllNew() async {
    Get.to(
      () => CampaignListPage<MarketplaceCampaignEntity>(
        title: 'New Campaigns',
        take: 20,
        enableSearch: true,
        idOf: (c) => c.id,
        nameOf: (c) => c.brandName,
        logoUrlOf: (c) => resolveImageUrl(c.brandLogoUrl),
        fetcher: ({required int page, required int take, String? search}) {
          if (page > 1) {
            return Future.value(
              const Right<Failure, List<MarketplaceCampaignEntity>>([]),
            );
          }
          return _getNewCampaigns(
            NewCampaignsParams(sort: 'new', category: selectedCategory.value),
          );
        },
        emptyMessage: 'No new campaigns found',
        onCampaignTap: (campaign) =>
            Get.toNamed(AppRoutes.campaignDetail, arguments: campaign.id),
      ),
    );
  }

  void seeAllCampaigns() {
    Get.to(
      () => CampaignListPage<CampaignEntity>(
        title: 'All Campaigns',
        idOf: (c) => c.id,
        nameOf: (c) => c.brandName,
        logoUrlOf: (c) => resolveImageUrl(c.brandLogoUrl),
        enableSearch: true, // CampaignFilterParams has no search param
        fetcher: ({required int page, required int take, String? search}) {
          if (page > 1) {
            return Future.value(const Right<Failure, List<CampaignEntity>>([]));
          }
          return _getCampaignsUseCase(
            CampaignFilterParams(take: take, category: null),
          );
        },
        onCampaignTap: (campaign) =>
            Get.toNamed(AppRoutes.campaignDetail, arguments: campaign.id),
      ),
    );
  }

  Future<void> toggleFavourite(String campaignId) async {
    final result = await _toggleFavourite(CampaignIdParams(campaignId));
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (isFavourite) => _updateFavouriteState(campaignId, isFavourite),
    );
  }

  void _updateFavouriteState(String campaignId, bool isFavourite) {
    final fIndex = featuredCampaigns.indexWhere((c) => c.id == campaignId);
    if (fIndex != -1) {
      featuredCampaigns[fIndex] = _copyWithFavourite(
        featuredCampaigns[fIndex],
        isFavourite,
      );
    }
    final nIndex = newCampaigns.indexWhere((c) => c.id == campaignId);
    if (nIndex != -1) {
      newCampaigns[nIndex] = _copyWithFavourite(
        newCampaigns[nIndex],
        isFavourite,
      );
    }
  }

  MarketplaceCampaignEntity _copyWithFavourite(
    MarketplaceCampaignEntity entity,
    bool isFavourite,
  ) {
    return (entity as dynamic).copyWith(isFavourite: isFavourite);
  }
}
