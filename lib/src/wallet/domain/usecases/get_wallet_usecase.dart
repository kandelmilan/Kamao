import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/wallet/wallet.dart';

class GetWalletUseCase extends UseCase<WalletSummaryEntity, NoParams> {
  GetWalletUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, WalletSummaryEntity>> call(NoParams params) {
    return _repository.getWallet();
  }
}
