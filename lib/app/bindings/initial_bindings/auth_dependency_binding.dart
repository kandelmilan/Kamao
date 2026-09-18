// import 'package:get/get.dart';
// import 'package:kamao/src/auth/auth.dart';

// class AuthDependencyBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<AuthRemoteDataSource>(
//       () => AuthRemoteDataSourceImpl(Get.find()),
//       fenix: true,
//     );

//     Get.lazyPut<AuthRepository>(
//       () => AuthRepositoryImpl(Get.find()),
//       fenix: true,
//     );

//     Get.lazyPut<LoginUserUsecase>(
//       () => LoginUserUsecase(Get.find()),
//       fenix: true,
//     );

//     Get.lazyPut<RefreshTokenUseCase>(
//       () => RefreshTokenUseCase(Get.find()),
//       fenix: true,
//     );

//     Get.lazyPut<GetMeUseCase>(() => GetMeUseCase(Get.find()), fenix: true);

//     Get.lazyPut<ForgotPasswordUseCase>(
//       () => ForgotPasswordUseCase(Get.find()),
//       fenix: true,
//     );

//     Get.put<AuthController>(
//       AuthController(Get.find(), Get.find(), Get.find(), Get.find()),
//       permanent: true,
//     );
//   }
// }
import 'package:get/get.dart';
import 'package:kamao/src/auth/auth.dart';

class AuthDependencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find()),
      fenix: true,
    );

    Get.lazyPut<LoginUserUsecase>(
      () => LoginUserUsecase(Get.find()),
      fenix: true,
    );

    Get.lazyPut<RegisterUserUsecase>(
      () => RegisterUserUsecase(Get.find()),
      fenix: true,
    );

    Get.lazyPut<RefreshTokenUseCase>(
      () => RefreshTokenUseCase(Get.find()),
      fenix: true,
    );

    Get.lazyPut<GetMeUseCase>(() => GetMeUseCase(Get.find()), fenix: true);

    Get.lazyPut<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(Get.find()),
      fenix: true,
    );

    Get.lazyPut<ChangePasswordUseCase>(
      () => ChangePasswordUseCase(Get.find()),
      fenix: true,
    );

    Get.put<AuthController>(
      AuthController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      ),
      permanent: true,
    );
  }
}
