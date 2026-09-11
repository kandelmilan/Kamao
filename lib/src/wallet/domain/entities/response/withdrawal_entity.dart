enum WithdrawalStatus {
  paid,
  pending,
  processing,
  rejected,
  unknown;

  static WithdrawalStatus fromApi(String? value) {
    switch (value?.toLowerCase()) {
      case 'paid':
        return WithdrawalStatus.paid;
      case 'pending':
        return WithdrawalStatus.pending;
      case 'processing':
        return WithdrawalStatus.processing;
      case 'rejected':
        return WithdrawalStatus.rejected;
      default:
        return WithdrawalStatus.unknown;
    }
  }
}

class WithdrawalEntity {
  const WithdrawalEntity({
    required this.id,
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
  final double amount;
  final String currency;

  /// e.g. "Khalti", "Esewa", "BankTransfer" — drives which icon/color
  /// the row uses (green circular-e for Esewa, red paper-plane for
  /// Khalti, plain red dot for bank transfer, per the design).
  final String destinationType;

  final String accountName;
  final String accountNumber;
  final String? bankName;

  final WithdrawalStatus status;

  final DateTime requestedAt;
  final DateTime? processedAt;

  /// Populated for rejected withdrawals — shown as the small red
  /// caption under the row ("Account name mismatched" in the design).
  final String? adminNote;

  final String? creatorName;
  final String? creatorEmail;
}
