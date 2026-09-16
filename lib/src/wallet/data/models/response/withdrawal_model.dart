import 'package:kamao/src/wallet/domain/entities/response/withdrawal_entity.dart';

class WithdrawalModel {
  const WithdrawalModel({
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

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      destinationType: json['destinationType'] as String,
      accountName: json['accountName'] as String,
      accountNumber: json['accountNumber'] as String,
      bankName: json['bankName'] as String?,
      status: json['status']?.toString() ?? '',
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      adminNote: json['adminNote'] as String?,
      creatorName: json['creatorName'] as String?,
      creatorEmail: json['creatorEmail'] as String?,
    );
  }

  final String id;
  final String userId;
  final double amount;
  final String currency;
  final String destinationType;
  final String accountName;
  final String accountNumber;
  final String? bankName;
  final String status;
  final DateTime requestedAt;
  final DateTime? processedAt;
  final String? adminNote;
  final String? creatorName;
  final String? creatorEmail;

  WithdrawalEntity toEntity() {
    return WithdrawalEntity(
      id: id,
      amount: amount,
      currency: currency,
      destinationType: destinationType,
      accountName: accountName,
      accountNumber: accountNumber,
      bankName: bankName,
      status: WithdrawalStatus.fromApi(status),
      requestedAt: requestedAt,
      processedAt: processedAt,
      adminNote: adminNote,
      creatorName: creatorName,
      creatorEmail: creatorEmail,
    );
  }
}
