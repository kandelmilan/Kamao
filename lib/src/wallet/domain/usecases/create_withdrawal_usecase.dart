import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/wallet/wallet.dart';

class CreateWithdrawalParams {
  const CreateWithdrawalParams({
    required this.amount,
    required this.destinationType,
    required this.accountName,
    required this.accountNumber,
    required this.currency,
    this.bankName,
  });

  final double amount;
  final String destinationType;
  final String accountName;
  final String accountNumber;
  final String currency;
  final String? bankName;
}

class CreateWithdrawalUseCase
    extends UseCase<String, CreateWithdrawalParams> {
  CreateWithdrawalUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, String>> call(CreateWithdrawalParams params) {
    return _repository.createWithdrawal(
      amount: params.amount,
      destinationType: params.destinationType,
      accountName: params.accountName,
      accountNumber: params.accountNumber,
      currency: params.currency,
      bankName: params.bankName,
    );
  }
}
