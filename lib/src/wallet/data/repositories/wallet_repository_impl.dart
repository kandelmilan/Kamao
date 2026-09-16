import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/wallet/data/models/request/create_withdrawal_request_model.dart';
import 'package:kamao/src/wallet/domain/entities/response/payout_method_entity.dart';
import 'package:kamao/src/wallet/domain/entities/response/withdrawal_entity.dart';
import 'package:kamao/src/wallet/wallet.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl(this._remoteDataSource);

  final WalletRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, WalletSummaryEntity>> getWallet() async {
    final result = await _remoteDataSource.getWallet();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!.toEntity()),
    );
  }

  @override
  Future<Either<Failure, List<WithdrawalEntity>>> getWithdrawals() async {
    final result = await _remoteDataSource.getWithdrawals();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(
        (response.data ?? []).map((model) => model.toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, PayoutMethodEntity>> getPayoutMethod() async {
    final result = await _remoteDataSource.getPayoutMethod();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!.toEntity()),
    );
  }

  @override
  Future<Either<Failure, String>> createWithdrawal({
    required double amount,
    required String destinationType,
    required String accountName,
    required String accountNumber,
    required String currency,
    String? bankName,
  }) async {
    final result = await _remoteDataSource.createWithdrawal(
      CreateWithdrawalRequestModel(
        amount: amount,
        destinationType: destinationType,
        accountName: accountName,
        accountNumber: accountNumber,
        currency: currency,
        bankName: bankName,
      ),
    );

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data ?? ''),
    );
  }
}
