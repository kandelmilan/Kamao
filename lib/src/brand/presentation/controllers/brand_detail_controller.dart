import 'package:get/get.dart';
import 'package:kamao/src/brand/domain/usecase/get_brand_detail_usecase.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import '../../domain/entities/brand_detail_entity.dart';

class BrandDetailController extends GetxController {
  BrandDetailController(this._getBrandDetail, {required this.brandId});

  final GetBrandDetailUseCase _getBrandDetail;
  final String brandId;

  final isLoading = false.obs;
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
      // TODO: adjust `failure.message` if your Failure base class
      // exposes the error text under a different name.
      (failure) => error.value = failure.message,
      (detail) => brandDetail.value = detail,
    );
    isLoading.value = false;
  }

  Future<void> refresh() => loadBrandDetail();

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
    // TODO: wire to whatever HomeController.openCampaign already
    // does, e.g.:
    // Get.toNamed(Routes.campaignDetail, arguments: campaign);
  }
}
