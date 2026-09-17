import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';

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
    Get.lazyPut<UploadAvatarUseCase>(
      () => UploadAvatarUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteAvatarUseCase>(
      () => DeleteAvatarUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<GetCreatorProfileUseCase>(),
        Get.find<UploadAvatarUseCase>(),
        Get.find<DeleteAvatarUseCase>(),
      ),
      fenix: true,
    );
  }
}
