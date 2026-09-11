import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/data/datasources/profile_remote_datasource.dart';
import 'package:kamao/src/auth/data/repositories/profile_repository_impl.dart';
import 'package:kamao/src/auth/domain/repositories/profile_repository.dart';
import 'package:kamao/src/auth/domain/usecases/get_creator_profile_usecase.dart';
import 'package:kamao/src/auth/presentation/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(Get.find<ProfileRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<GetCreatorProfileUseCase>(
      () => GetCreatorProfileUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find<GetCreatorProfileUseCase>()),
      fenix: true,
    );
  }
}
