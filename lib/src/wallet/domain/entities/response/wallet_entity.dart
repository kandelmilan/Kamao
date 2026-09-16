enum WalletLedgerEntryType {
  rewardPayout,
  withdrawal,
  withdrawalReversal,
  unknown;

  static WalletLedgerEntryType fromApi(String value) {
    switch (value) {
      case 'RewardPayout':
        return WalletLedgerEntryType.rewardPayout;
      case 'Withdrawal':
        return WalletLedgerEntryType.withdrawal;
      case 'WithdrawalReversal':
        return WalletLedgerEntryType.withdrawalReversal;
      default:
        return WalletLedgerEntryType.unknown;
    }
  }
}

enum WithdrawalStatus {
  pending,
  paid,
  rejected,
  processing,
  unknown;

  static WithdrawalStatus fromApi(String value) {
    // Keep in sync with withdrawal_entity.dart — same aliases.
    final raw = value.trim().toLowerCase();
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

    return WithdrawalStatus.pending;
  }
}

class WalletLedgerEntryEntity {
  const WalletLedgerEntryEntity({
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
  final WalletLedgerEntryType entryType;
  final double amount;
  final double balanceAfter;
  final String currency;
  final String narration;
  final DateTime createdAt;
  final String? campaignId;
  final String? submissionId;
}

class WalletWithdrawalEntity {
  const WalletWithdrawalEntity({
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
  final String destinationType; // e.g. "Khalti" — no other values seen yet
  final String accountName;
  final String accountNumber;
  final WithdrawalStatus status;
  final DateTime requestedAt;
  final String? bankName;
  final DateTime? processedAt;
  final String? adminNote;
  final String? creatorName;
  final String? creatorEmail;
}

class WalletEntity {
  const WalletEntity({
    required this.id,
    required this.userId,
    required this.currency,
    required this.balance,
  });

  final String id;
  final String userId;
  final String currency;
  final double balance;
}

/// Wraps the full `/creator/wallet` payload.
class WalletSummaryEntity {
  const WalletSummaryEntity({
    required this.wallets,
    required this.ledger,
    required this.withdrawals,
    required this.withdrawalHint,
  });

  final List<WalletEntity> wallets;
  final List<WalletLedgerEntryEntity> ledger;
  final List<WalletWithdrawalEntity> withdrawals;
  final String withdrawalHint;

  /// The wallet the Home screen cares about today. Prefers an NPR
  /// wallet (the only currency the app currently supports); falls back
  /// to the first wallet returned, or null if the list is empty.
  WalletEntity? get primaryWallet {
    if (wallets.isEmpty) return null;
    for (final wallet in wallets) {
      if (wallet.currency.toUpperCase() == 'NPR') return wallet;
    }
    return wallets.first;
  }

  /// Withdrawal requests submitted but not yet marked Paid/Rejected.
  /// NOTE: per [withdrawalHint], a withdrawal debits the wallet the
  /// moment it's *requested*, not once processed — so
  /// `primaryWallet.balance` already reflects these. This list is
  /// exposed for display ("1 withdrawal in progress") but deliberately
  /// isn't subtracted from anything here — there's no evidence in this
  /// payload that a "withdrawable" amount should differ from `balance`
  /// at all.
  List<WalletWithdrawalEntity> get pendingWithdrawals =>
      withdrawals.where((w) => w.status == WithdrawalStatus.pending).toList();
}
