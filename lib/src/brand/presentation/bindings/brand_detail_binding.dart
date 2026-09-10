import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/usecase/get_brand_detail_usecase.dart';
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
    final useCase = GetBrandDetailUseCase(repository);

    Get.put(BrandDetailController(useCase, brandId: brandId), tag: brandId);
  }
}
