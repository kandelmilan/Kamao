import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/core/utils/campaign_platform_enricher.dart';
import 'package:kamao/src/brand/brand.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/join_campaign_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/toggle_favourite_campaign_usecase.dart';
import 'package:kamao/src/home/presentation/controllers/home_controller.dart';

class CampaignDetailController extends GetxController {
  CampaignDetailController({
    required GetCampaignDetailUseCase getCampaignDetailUseCase,
    required JoinCampaignUseCase joinCampaignUseCase,
    required ToggleFavouriteCampaignUseCase toggleFavouriteCampaignUseCase,
    required GetBrandDetailUseCase getBrandDetailUseCase,
    required this.campaignId,
  }) : _getCampaignDetailUseCase = getCampaignDetailUseCase,
       _joinCampaignUseCase = joinCampaignUseCase,
       _toggleFavouriteCampaignUseCase = toggleFavouriteCampaignUseCase,
       _getBrandDetailUseCase = getBrandDetailUseCase;

  final GetCampaignDetailUseCase _getCampaignDetailUseCase;
  final JoinCampaignUseCase _joinCampaignUseCase;
  final ToggleFavouriteCampaignUseCase _toggleFavouriteCampaignUseCase;
  final GetBrandDetailUseCase _getBrandDetailUseCase;
  final String campaignId;

  final Rxn<CampaignDetailEntity> campaign = Rxn<CampaignDetailEntity>();
  final Rxn<BrandProfileEntity> brand = Rxn<BrandProfileEntity>();
  final RxBool isLoading = false.obs;
  final RxBool isJoining = false.obs;
  final RxBool isTogglingFavourite = false.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  Future<void> loadDetail() async {
    isLoading.value = true;
    error.value = null;

    final result = await _getCampaignDetailUseCase(
      CampaignIdParams(campaignId),
    );

    result.fold((failure) => error.value = failure.message, (detail) {
      campaign.value = detail;
      CampaignPlatformCache.putFromDetail(detail);
      _loadBrand(detail.brandId);
    });

    isLoading.value = false;
  }

  Future<void> _loadBrand(String brandId) async {
    if (brandId.isEmpty) return;
    final result = await _getBrandDetailUseCase(IdParams(brandId));
    result.fold((_) {}, (detail) => brand.value = detail.brand);
  }

  Future<bool> join({String? platformId}) async {
    final current = campaign.value;
    if (current == null || current.alreadyJoined || isJoining.value) {
      return current?.alreadyJoined ?? false;
    }

    isJoining.value = true;
    var success = false;

    final result = await _joinCampaignUseCase(JoinCampaignParams(campaignId));

    result.fold(
      (failure) => Get.snackbar(
        "Couldn't join",
        failure.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: const Color(0xFF353037),
        margin: const EdgeInsets.all(16),
      ),
      (joined) {
        if (joined) {
          campaign.value = current.copyWith(alreadyJoined: true);
          _syncHomeJoinedState();
          success = true;
        }
      },
    );

    isJoining.value = false;
    return success;
  }

  Future<void> toggleFavourite() async {
    final current = campaign.value;
    if (current == null || isTogglingFavourite.value) return;

    isTogglingFavourite.value = true;

    final result = await _toggleFavouriteCampaignUseCase(
      ToggleFavouriteCampaignParams(
        campaignId: campaignId,
        currentlyFavourite: current.isFavourite,
      ),
    );

    result.fold(
      (failure) => Get.snackbar(
        "Couldn't update favourite",
        failure.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: const Color(0xFF353037),
        margin: const EdgeInsets.all(16),
      ),
      (isFavourite) {
        campaign.value = current.copyWith(isFavourite: isFavourite);
        _syncHomeFavouriteState(isFavourite);
      },
    );

    isTogglingFavourite.value = false;
  }

  void _syncHomeFavouriteState(bool isFavourite) {
    if (!Get.isRegistered<HomeController>()) return;
    Get.find<HomeController>().applyFavouriteState(campaignId, isFavourite);
  }

  void _syncHomeJoinedState() {
    if (!Get.isRegistered<HomeController>()) return;
    Get.find<HomeController>().markCampaignJoinedExternally(campaignId);
  }
}
