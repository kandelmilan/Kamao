import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/domain/entities/response/profile_entity.dart';
import 'package:kamao/src/auth/domain/usecases/get_creator_progress_guide_usecase.dart';

class CreatorLevelsController extends GetxController {
  CreatorLevelsController(this._getProgressGuideUseCase);

  final GetCreatorProgressGuideUseCase _getProgressGuideUseCase;

  final Rxn<ProfileProgressEntity> guide = Rxn<ProfileProgressEntity>();
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  ProfileProgressStatsEntity? get progress => guide.value?.current;

  List<ProfileLevelEntity> get levels => guide.value?.levels ?? const [];

  List<ProfileBadgeEntity> get catalogBadges =>
      guide.value?.badges ?? const [];

  List<ProfileBadgeEntity> get awardedBadges =>
      progress?.badges ?? const [];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;

    final result = await _getProgressGuideUseCase(const NoParams());
    result.fold(
      (failure) => error.value = failure.message,
      (data) => guide.value = data,
    );

    isLoading.value = false;
  }

  Future<void> refresh() => load();
}
