// import 'package:dartz/dartz.dart';
// import 'package:kamao/core/core.dart';
// import 'package:kamao/src/wallet/wallet.dart';

// abstract class WalletRemoteDataSource {
//   Future<Either<Failure, ApiResponse<WalletSummaryModel>>> getWallet();
// }

// class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
//   const WalletRemoteDataSourceImpl(this._apiService);

//   final ApiService _apiService;

//   @override
//   Future<Either<Failure, ApiResponse<WalletSummaryModel>>> getWallet() {
//     return ApiResponseHandler.handleResponse<WalletSummaryModel>(
//       () => _apiService.get(ApiEndpoints.wallet),
//       (data) => WalletSummaryModel.fromJson(data as Map<String, dynamic>),
//     );
//   }
// }
import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/wallet/data/models/response/payout_method_model.dart';
import 'package:kamao/src/wallet/data/models/response/withdrawal_model.dart';
import 'package:kamao/src/wallet/wallet.dart';

abstract class WalletRemoteDataSource {
  Future<Either<Failure, ApiResponse<WalletSummaryModel>>> getWallet();

  Future<Either<Failure, ApiResponse<List<WithdrawalModel>>>> getWithdrawals();

  Future<Either<Failure, ApiResponse<PayoutMethodModel>>> getPayoutMethod();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  const WalletRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Either<Failure, ApiResponse<WalletSummaryModel>>> getWallet() {
    return ApiResponseHandler.handleResponse<WalletSummaryModel>(
      () => _apiService.get(ApiEndpoints.wallet),
      (data) => WalletSummaryModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<List<WithdrawalModel>>>> getWithdrawals() {
    // NOTE: swap this for whatever your ApiResponseHandler's array-shaped
    // helper is actually called (e.g. handleListResponse) if it differs
    // from handleResponse's single-item mapper — the withdrawals endpoint
    // returns `data` as a JSON array, not a single object.
    return ApiResponseHandler.handleResponse<List<WithdrawalModel>>(
      () => _apiService.get(ApiEndpoints.walletWithdrawals),
      (data) => (data as List)
          .map((item) => WithdrawalModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<PayoutMethodModel>>> getPayoutMethod() {
    return ApiResponseHandler.handleResponse<PayoutMethodModel>(
      () => _apiService.get(ApiEndpoints.walletPayoutMethod),
      (data) => PayoutMethodModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
