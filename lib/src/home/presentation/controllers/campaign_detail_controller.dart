import 'package:get/get.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/join_campaign_usecase.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/toggle_favourite_campaign_usecase.dart';
import 'package:kamao/src/home/presentation/controllers/home_controller.dart';

class CampaignDetailController extends GetxController {
  CampaignDetailController(
    this._getCampaignDetailUseCase,
    this._joinCampaignUseCase,
    this._toggleFavouriteCampaignUseCase,
    this.campaignId,
  );

  final GetCampaignDetailUseCase _getCampaignDetailUseCase;
  final JoinCampaignUseCase _joinCampaignUseCase;
  final ToggleFavouriteCampaignUseCase _toggleFavouriteCampaignUseCase;
  final String campaignId;

  final Rxn<CampaignDetailEntity> campaign = Rxn<CampaignDetailEntity>();
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

    result.fold(
      (failure) => error.value = failure.message,
      (detail) => campaign.value = detail,
    );

    isLoading.value = false;
  }

  Future<void> join({String? platformId}) async {
    final current = campaign.value;
    if (current == null || current.alreadyJoined || isJoining.value) return;

    isJoining.value = true;

    final result = await _joinCampaignUseCase(JoinCampaignParams(campaignId));

    result.fold((failure) => Get.snackbar('Couldn\'t join', failure.message), (
      joined,
    ) {
      if (joined) {
        campaign.value = current.copyWith(alreadyJoined: true);
        _syncHomeJoinedState();
      }
    });

    isJoining.value = false;
  }

  Future<void> toggleFavourite() async {
    final current = campaign.value;
    if (current == null || isTogglingFavourite.value) return;

    isTogglingFavourite.value = true;

    final result = await _toggleFavouriteCampaignUseCase(
      CampaignIdParams(campaignId),
    );

    result.fold(
      (failure) => Get.snackbar("Couldn't update favourite", failure.message),
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
