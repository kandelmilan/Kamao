enum WithdrawalStatus {
  paid,
  pending,
  processing,
  rejected,
  unknown;

  /// Maps backend status strings. New requests are often returned as
  /// values other than exactly "Pending" (e.g. Requested / Submitted),
  /// so we accept common aliases and fall back to [pending] for empty
  /// values rather than showing "Unknown".
  static WithdrawalStatus fromApi(String? value) {
    final raw = value?.trim().toLowerCase() ?? '';
    if (raw.isEmpty) return WithdrawalStatus.pending;

    switch (raw) {
      case 'paid':
      case 'success':
      case 'successful':
      case 'completed':
      case 'complete':
      case 'done':
        return WithdrawalStatus.paid;
      case 'pending':
      case 'requested':
      case 'submitted':
      case 'queued':
      case 'open':
      case 'new':
      case 'created':
      case 'awaiting':
      case 'approved':
        return WithdrawalStatus.pending;
      case 'processing':
      case 'inprogress':
      case 'in_progress':
      case 'in-progress':
        return WithdrawalStatus.processing;
      case 'rejected':
      case 'failed':
      case 'failure':
      case 'cancelled':
      case 'canceled':
      case 'declined':
        return WithdrawalStatus.rejected;
    }

    if (raw.contains('paid') ||
        raw.contains('success') ||
        raw.contains('complete')) {
      return WithdrawalStatus.paid;
    }
    if (raw.contains('reject') ||
        raw.contains('fail') ||
        raw.contains('cancel') ||
        raw.contains('decline')) {
      return WithdrawalStatus.rejected;
    }
    if (raw.contains('process')) {
      return WithdrawalStatus.processing;
    }
    if (raw.contains('pend') ||
        raw.contains('request') ||
        raw.contains('submit') ||
        raw.contains('queue') ||
        raw.contains('approv')) {
      return WithdrawalStatus.pending;
    }

    // Prefer Pending over Unknown for anything we don't recognize —
    // newly created withdrawals are awaiting staff action.
    return WithdrawalStatus.pending;
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
