import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/post/data/datasources/post_remote_data_source.dart';
import 'package:kamao/src/post/data/repositories/post_repository_impl.dart';
import 'package:kamao/src/post/domain/repositories/post_repository.dart';
import 'package:kamao/src/post/domain/usecase/get_approved_submissions_usecase.dart';
import 'package:kamao/src/post/domain/usecase/get_pending_submissions_usecase.dart';
import 'package:kamao/src/post/presentation/controllers/posts_controller.dart';

class PostsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PostRemoteDataSource>()) {
      Get.lazyPut<PostRemoteDataSource>(
        () => PostRemoteDataSourceImpl(Get.find<ApiService>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<PostRepository>()) {
      Get.lazyPut<PostRepository>(
        () => PostRepositoryImpl(Get.find()),
        fenix: true,
      );
    }

    Get.lazyPut(() => GetPendingSubmissionsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetApprovedSubmissionsUseCase(Get.find()), fenix: true);

    Get.lazyPut(
      () => PostsController(
        getPending: Get.find(),
        getApproved: Get.find(),
      ),
    );
  }
}
