import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/wallet/domain/entities/response/payout_method_entity.dart';
import 'package:kamao/src/wallet/wallet.dart';

class GetPayoutMethodUseCase extends UseCase<PayoutMethodEntity, NoParams> {
  GetPayoutMethodUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, PayoutMethodEntity>> call(NoParams params) {
    return _repository.getPayoutMethod();
  }
}
