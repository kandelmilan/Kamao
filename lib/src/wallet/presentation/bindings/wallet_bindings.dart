import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/wallet/domain/usecases/get_payout_method_usecase.dart';
import 'package:kamao/src/wallet/domain/usecases/get_withdrawals_usecase.dart';
import 'package:kamao/src/wallet/presentation/controllers/wallet_controller.dart';
import 'package:kamao/src/wallet/wallet.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletRemoteDataSource>(
      () => WalletRemoteDataSourceImpl(Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<WalletRepository>(
      () => WalletRepositoryImpl(Get.find<WalletRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut(
      () => GetWalletUseCase(Get.find<WalletRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetWithdrawalsUseCase(Get.find<WalletRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetPayoutMethodUseCase(Get.find<WalletRepository>()),
      fenix: true,
    );

    Get.lazyPut(
      () => WalletController(
        Get.find<GetWalletUseCase>(),
        Get.find<GetWithdrawalsUseCase>(),
        Get.find<GetPayoutMethodUseCase>(),
      ),
      fenix: true,
    );
  }
}
