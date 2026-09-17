import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/usecase/get_app_config_usecase.dart';
import 'package:kamao/src/wallet/domain/usecases/create_withdrawal_usecase.dart';
import 'package:kamao/src/wallet/domain/usecases/get_payout_method_usecase.dart';
import 'package:kamao/src/wallet/presentation/controllers/withdraw_controller.dart';
import 'package:kamao/src/wallet/wallet.dart';

class WithdrawBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WalletRemoteDataSource>()) {
      Get.lazyPut<WalletRemoteDataSource>(
        () => WalletRemoteDataSourceImpl(Get.find<ApiService>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<WalletRepository>()) {
      Get.lazyPut<WalletRepository>(
        () => WalletRepositoryImpl(Get.find<WalletRemoteDataSource>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetWalletUseCase>()) {
      Get.lazyPut(
        () => GetWalletUseCase(Get.find<WalletRepository>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetPayoutMethodUseCase>()) {
      Get.lazyPut(
        () => GetPayoutMethodUseCase(Get.find<WalletRepository>()),
        fenix: true,
      );
    }

    Get.lazyPut(
      () => CreateWithdrawalUseCase(Get.find<WalletRepository>()),
      fenix: true,
    );

    // Recreate on every visit so balance + payout fields refresh.
    if (Get.isRegistered<WithdrawController>()) {
      Get.delete<WithdrawController>(force: true);
    }
    Get.put(
      WithdrawController(
        Get.find<GetWalletUseCase>(),
        Get.find<GetPayoutMethodUseCase>(),
        Get.find<CreateWithdrawalUseCase>(),
        getAppConfig: Get.isRegistered<GetAppConfigUseCase>()
            ? Get.find<GetAppConfigUseCase>()
            : null,
      ),
    );
  }
}
