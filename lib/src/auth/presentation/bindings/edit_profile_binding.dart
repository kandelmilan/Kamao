import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/home/data/datasources/app_config_remote_data_source.dart';
import 'package:kamao/src/home/data/repositories/app_config_repository_impl.dart';
import 'package:kamao/src/home/domain/repositories/app_config_repository.dart';
import 'package:kamao/src/home/domain/usecase/get_app_config_usecase.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileRemoteDataSource>()) {
      Get.lazyPut<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<ProfileRepository>()) {
      Get.lazyPut<ProfileRepository>(
        () => ProfileRepositoryImpl(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetCreatorProfileUseCase>()) {
      Get.lazyPut<GetCreatorProfileUseCase>(
        () => GetCreatorProfileUseCase(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<UpdateProfileUseCase>()) {
      Get.lazyPut<UpdateProfileUseCase>(
        () => UpdateProfileUseCase(Get.find()),
      );
    }
    if (!Get.isRegistered<AppConfigRemoteDataSource>()) {
      Get.lazyPut<AppConfigRemoteDataSource>(
        () => AppConfigRemoteDataSourceImpl(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<AppConfigRepository>()) {
      Get.lazyPut<AppConfigRepository>(
        () => AppConfigRepositoryImpl(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetAppConfigUseCase>()) {
      Get.lazyPut<GetAppConfigUseCase>(
        () => GetAppConfigUseCase(Get.find()),
        fenix: true,
      );
    }

    Get.lazyPut<EditProfileController>(
      () => EditProfileController(
        Get.find<GetCreatorProfileUseCase>(),
        Get.find<UpdateProfileUseCase>(),
        Get.find<GetAppConfigUseCase>(),
      ),
    );
  }
}
