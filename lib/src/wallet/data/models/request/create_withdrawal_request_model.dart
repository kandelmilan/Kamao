class CreateWithdrawalRequestModel {
  const CreateWithdrawalRequestModel({
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

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'destinationType': destinationType,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'currency': currency,
      if (bankName != null && bankName!.trim().isNotEmpty)
        'bankName': bankName!.trim(),
    };
  }
}
