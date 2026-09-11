import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/wallet/domain/entities/response/withdrawal_entity.dart';
import 'package:kamao/src/wallet/wallet.dart';

class GetWithdrawalsUseCase extends UseCase<List<WithdrawalEntity>, NoParams> {
  GetWithdrawalsUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, List<WithdrawalEntity>>> call(NoParams params) {
    return _repository.getWithdrawals();
  }
}
