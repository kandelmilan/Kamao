class PayoutMethodEntity {
  const PayoutMethodEntity({
    required this.destinationType,
    required this.accountName,
    required this.accountNumber,
    required this.updatedAt,
    this.bankName,
  });

  final String destinationType;
  final String accountName;
  final String accountNumber;
  final String? bankName;
  final DateTime updatedAt;
}
