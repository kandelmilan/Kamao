import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/wallet/domain/entities/response/payout_method_entity.dart';
import 'package:kamao/src/wallet/domain/entities/response/withdrawal_entity.dart';
import 'package:kamao/src/wallet/wallet.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletSummaryEntity>> getWallet();
  Future<Either<Failure, List<WithdrawalEntity>>> getWithdrawals();
  Future<Either<Failure, PayoutMethodEntity>> getPayoutMethod();
}
