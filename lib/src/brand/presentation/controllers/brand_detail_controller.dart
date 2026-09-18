import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/utils/campaign_platform_enricher.dart';
import 'package:kamao/src/brand/domain/usecase/favourite_brand_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/get_brand_detail_usecase.dart';
import 'package:kamao/src/brand/domain/usecase/view_brand_usecase.dart';
import 'package:kamao/src/brand/presentation/controllers/brands_controller.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';
import 'package:kamao/src/home/presentation/controllers/home_controller.dart';
import '../../domain/entities/brand_detail_entity.dart';

class BrandDetailController extends GetxController {
  BrandDetailController(
    this._getBrandDetail,
    this._viewBrand,
    this._favouriteBrand,
    this._unfavouriteBrand,
    this._getCampaignDetail, {
    required this.brandId,
  });

  final GetBrandDetailUseCase _getBrandDetail;
  final ViewBrandUseCase _viewBrand;
  final FavouriteBrandUseCase _favouriteBrand;
  final UnfavouriteBrandUseCase _unfavouriteBrand;
  final GetCampaignDetailUseCase _getCampaignDetail;
  final String brandId;

  final isLoading = false.obs;
  final isTogglingFavourite = false.obs;
  final Rxn<String> error = Rxn<String>();
  final Rxn<BrandDetailEntity> brandDetail = Rxn<BrandDetailEntity>();

  @override
  void onInit() {
    super.onInit();
    loadBrandDetail();
  }

  Future<void> loadBrandDetail() async {
    isLoading.value = true;
    error.value = null;
    final result = await _getBrandDetail(IdParams(brandId));
    result.fold(
      (failure) => error.value = failure.message,
      (detail) {
        brandDetail.value = detail;
        _recordView();
        // ignore: unawaited_futures
        _enrichCampaignPlatforms(detail);
      },
    );
    isLoading.value = false;
  }

  Future<void> _enrichCampaignPlatforms(BrandDetailEntity detail) async {
    final enriched = await enrichCampaignPlatforms(
      campaigns: detail.campaigns,
      getDetail: _getCampaignDetail,
    );
    if (brandDetail.value?.brand.id != detail.brand.id) return;
    brandDetail.value = detail.copyWith(campaigns: enriched);
  }

  Future<void> refresh() => loadBrandDetail();

  /// Fire-and-forget — pushes this brand into recent without blocking UI.
  Future<void> _recordView() async {
    final result = await _viewBrand(IdParams(brandId));
    result.fold((_) {}, (_) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().loadRecentBrands();
      }
    });
  }

  Future<void> toggleFavourite() async {
    final current = brandDetail.value;
    if (current == null || isTogglingFavourite.value) return;

    isTogglingFavourite.value = true;
    final currentlyFavourite = current.brand.isFavourite;
    final result = currentlyFavourite
        ? await _unfavouriteBrand(IdParams(brandId))
        : await _favouriteBrand(IdParams(brandId));

    result.fold(
      (failure) => Get.snackbar("Couldn't update favourite", failure.message),
      (isFavourite) {
        brandDetail.value = current.copyWith(
          brand: current.brand.copyWith(isFavourite: isFavourite),
        );
        _syncFavouriteLists();
      },
    );
    isTogglingFavourite.value = false;
  }

  void _syncFavouriteLists() {
    if (Get.isRegistered<BrandsController>()) {
      Get.find<BrandsController>().loadFavouriteBrands();
    }
  }

  String get formattedMaxReward {
    final brand = brandDetail.value?.brand;
    if (brand == null) return '';
    return '${brand.currency} ${_formatAmount(brand.maxRewardAmount)}';
  }

  String _formatAmount(num value) {
    final s = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      if (i != 0 && posFromEnd % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  void openCampaign(CampaignEntity campaign) {
    Get.toNamed(AppRoutes.campaignDetail, arguments: campaign.id);
  }

  /// True when this campaign appears in the home popular-campaigns list.
  bool isPopularCampaign(String campaignId) {
    if (!Get.isRegistered<HomeController>()) return false;
    return Get.find<HomeController>().popularCampaigns.any(
      (c) => c.id == campaignId,
    );
  }
}
