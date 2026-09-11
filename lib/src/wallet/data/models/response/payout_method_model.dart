import 'package:kamao/src/wallet/domain/entities/response/payout_method_entity.dart';

class PayoutMethodModel {
  const PayoutMethodModel({
    required this.destinationType,
    required this.accountName,
    required this.accountNumber,
    required this.updatedAt,
    this.bankName,
  });

  factory PayoutMethodModel.fromJson(Map<String, dynamic> json) {
    return PayoutMethodModel(
      destinationType: json['destinationType'] as String,
      accountName: json['accountName'] as String,
      accountNumber: json['accountNumber'] as String,
      bankName: json['bankName'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final String destinationType;
  final String accountName;
  final String accountNumber;
  final String? bankName;
  final DateTime updatedAt;

  PayoutMethodEntity toEntity() {
    return PayoutMethodEntity(
      destinationType: destinationType,
      accountName: accountName,
      accountNumber: accountNumber,
      bankName: bankName,
      updatedAt: updatedAt,
    );
  }
}
