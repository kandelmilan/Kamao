import 'package:kamao/src/wallet/wallet.dart';

class WalletModel {
  const WalletModel({
    required this.id,
    required this.userId,
    required this.currency,
    required this.balance,
  });

  final String id;
  final String userId;
  final String currency;
  final double balance;

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
    );
  }

  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      userId: userId,
      currency: currency,
      balance: balance,
    );
  }
}

class WalletLedgerEntryModel {
  const WalletLedgerEntryModel({
    required this.id,
    required this.entryType,
    required this.amount,
    required this.balanceAfter,
    required this.currency,
    required this.narration,
    required this.createdAt,
    this.campaignId,
    this.submissionId,
  });

  final String id;
  final String entryType;
  final double amount;
  final double balanceAfter;
  final String currency;
  final String narration;
  final DateTime createdAt;
  final String? campaignId;
  final String? submissionId;

  factory WalletLedgerEntryModel.fromJson(Map<String, dynamic> json) {
    return WalletLedgerEntryModel(
      id: json['id']?.toString() ?? '',
      entryType: json['entryType']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      balanceAfter: (json['balanceAfter'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString() ?? '',
      narration: json['narration']?.toString() ?? '',
      // API returns no timezone suffix — DateTime.parse treats that as
      // local time, not UTC. Flag with backend if these are meant to
      // be UTC.
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      campaignId: json['campaignId']?.toString(),
      submissionId: json['submissionId']?.toString(),
    );
  }

  WalletLedgerEntryEntity toEntity() {
    return WalletLedgerEntryEntity(
      id: id,
      entryType: WalletLedgerEntryType.fromApi(entryType),
      amount: amount,
      balanceAfter: balanceAfter,
      currency: currency,
      narration: narration,
      createdAt: createdAt,
      campaignId: campaignId,
      submissionId: submissionId,
    );
  }
}

class WalletWithdrawalModel {
  const WalletWithdrawalModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.destinationType,
    required this.accountName,
    required this.accountNumber,
    required this.status,
    required this.requestedAt,
    this.bankName,
    this.processedAt,
    this.adminNote,
    this.creatorName,
    this.creatorEmail,
  });

  final String id;
  final String userId;
  final double amount;
  final String currency;
  final String destinationType;
  final String accountName;
  final String accountNumber;
  final String status;
  final DateTime requestedAt;
  final String? bankName;
  final DateTime? processedAt;
  final String? adminNote;
  final String? creatorName;
  final String? creatorEmail;

  factory WalletWithdrawalModel.fromJson(Map<String, dynamic> json) {
    return WalletWithdrawalModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString() ?? '',
      destinationType: json['destinationType']?.toString() ?? '',
      accountName: json['accountName']?.toString() ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      requestedAt:
          DateTime.tryParse(json['requestedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      bankName: json['bankName']?.toString(),
      processedAt: json['processedAt'] != null
          ? DateTime.tryParse(json['processedAt'].toString())
          : null,
      adminNote: json['adminNote']?.toString(),
      creatorName: json['creatorName']?.toString(),
      creatorEmail: json['creatorEmail']?.toString(),
    );
  }

  WalletWithdrawalEntity toEntity() {
    return WalletWithdrawalEntity(
      id: id,
      userId: userId,
      amount: amount,
      currency: currency,
      destinationType: destinationType,
      accountName: accountName,
      accountNumber: accountNumber,
      status: WithdrawalStatus.fromApi(status),
      requestedAt: requestedAt,
      bankName: bankName,
      processedAt: processedAt,
      adminNote: adminNote,
      creatorName: creatorName,
      creatorEmail: creatorEmail,
    );
  }
}

class WalletSummaryModel {
  const WalletSummaryModel({
    required this.wallets,
    required this.ledger,
    required this.withdrawals,
    required this.withdrawalHint,
  });

  final List<WalletModel> wallets;
  final List<WalletLedgerEntryModel> ledger;
  final List<WalletWithdrawalModel> withdrawals;
  final String withdrawalHint;

  factory WalletSummaryModel.fromJson(Map<String, dynamic> json) {
    return WalletSummaryModel(
      wallets: (json['wallets'] as List<dynamic>? ?? [])
          .map((e) => WalletModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      ledger: (json['ledger'] as List<dynamic>? ?? [])
          .map(
            (e) => WalletLedgerEntryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      withdrawals: (json['withdrawals'] as List<dynamic>? ?? [])
          .map((e) => WalletWithdrawalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      withdrawalHint: json['withdrawalHint']?.toString() ?? '',
    );
  }

  WalletSummaryEntity toEntity() {
    return WalletSummaryEntity(
      wallets: wallets.map((e) => e.toEntity()).toList(),
      ledger: ledger.map((e) => e.toEntity()).toList(),
      withdrawals: withdrawals.map((e) => e.toEntity()).toList(),
      withdrawalHint: withdrawalHint,
    );
  }
}
