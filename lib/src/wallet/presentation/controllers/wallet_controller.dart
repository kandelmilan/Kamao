import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/wallet/domain/entities/response/payout_method_entity.dart';
import 'package:kamao/src/wallet/domain/entities/response/withdrawal_entity.dart';
import 'package:kamao/src/wallet/domain/usecases/get_payout_method_usecase.dart';
import 'package:kamao/src/wallet/domain/usecases/get_withdrawals_usecase.dart';
import 'package:kamao/src/wallet/presentation/bindings%20/wallet_bindings.dart';
import 'package:kamao/src/wallet/presentation/views/wallet_transactions_view.dart';
// `wallet.dart` re-exports wallet_entity.dart, which declares its own
// `WithdrawalStatus` — a separate, narrower enum than the one in
// withdrawal_entity.dart (no `processing` case). Hiding it here avoids
// an ambiguous-import error; the withdrawal_entity.dart version is the
// one this controller (and WithdrawalEntity/WithdrawalModel) actually use.
import 'package:kamao/src/wallet/wallet.dart' hide WithdrawalStatus;

enum WalletActivityTab { withdrawals, ledger }

class WalletController extends GetxController {
  WalletController(
    this._getWallet,
    this._getWithdrawals,
    this._getPayoutMethod,
  );

  final GetWalletUseCase _getWallet;
  final GetWithdrawalsUseCase _getWithdrawals;
  final GetPayoutMethodUseCase _getPayoutMethod;

  final Rxn<WalletSummaryEntity> summary = Rxn<WalletSummaryEntity>();
  final RxList<WithdrawalEntity> withdrawals = <WithdrawalEntity>[].obs;
  final Rxn<PayoutMethodEntity> payoutMethod = Rxn<PayoutMethodEntity>();

  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  final Rx<WalletActivityTab> selectedTab = WalletActivityTab.withdrawals.obs;
  final RxBool isBalanceHidden = false.obs;

  static final _amount = NumberFormat('#,##0.00');
  static final _date = DateFormat('MMM dd, yyyy');
  static final _time = DateFormat('h:mm a');

  /// Backend-provided nudge shown in the green banner (e.g. withdrawal
  /// minimums, processing-time notices). Null/empty falls back to the
  /// banner's own default copy.
  String? get hintBody {
    final hint = summary.value?.withdrawalHint;
    if (hint == null || hint.trim().isEmpty) return null;
    return hint.trim();
  }

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    isLoading.value = true;
    error.value = null;

    final walletResult = await _getWallet(NoParams());
    walletResult.fold(
      (failure) => error.value = failure.message,
      (data) => summary.value = data,
    );

    final withdrawalsResult = await _getWithdrawals(NoParams());
    withdrawalsResult.fold(
      (failure) => error.value ??= failure.message,
      (data) => withdrawals.assignAll(data),
    );

    // Fetched but not rendered on this screen yet — needed once the
    // Withdraw flow (bottom sheet / page) is built, so it's cheap to
    // load alongside the rest rather than re-fetching later.
    final payoutMethodResult = await _getPayoutMethod(NoParams());
    payoutMethodResult.fold(
      (_) => payoutMethod.value = null,
      (data) => payoutMethod.value = data,
    );

    isLoading.value = false;
  }

  Future<void> refresh() => loadAll();

  void selectTab(WalletActivityTab tab) => selectedTab.value = tab;

  void toggleBalanceVisibility() =>
      isBalanceHidden.value = !isBalanceHidden.value;

  void onWithdrawTap() {
    // TODO: open the withdraw bottom sheet / flow once it's built.
  }

  void onSeeAllActivity() {
    Get.toNamed(AppRoutes.walletdetails);
  }
  // ---------- Display helpers ----------

  /// The wallet this screen cares about — see
  /// [WalletSummaryEntity.primaryWallet].
  WalletEntity? get _wallet => summary.value?.primaryWallet;

  String get formattedAvailableBalance {
    final wallet = _wallet;
    if (wallet == null) return '—';
    if (isBalanceHidden.value) return '••••••';
    return '${wallet.currency} ${_amount.format(wallet.balance)}';
  }

  /// Per [WalletSummaryEntity.pendingWithdrawals]'s own documentation,
  /// a withdrawal debits the wallet the moment it's requested, so
  /// `balance` already excludes anything mid-flight — there's no
  /// separate "withdrawable" figure in this API payload today. This
  /// mirrors the available balance until the backend exposes one.
  String get formattedWithdrawableBalance {
    final wallet = _wallet;
    if (wallet == null) return '—';
    return '${wallet.currency} ${_amount.format(wallet.balance)}';
  }

  /// Backend-provided nudge shown in the green banner (e.g. withdrawal
  /// minimums, processing-time notices). Null/empty hides the banner
  /// entirely rather than showing a hollow card.
  String? get walletHintMessage {
    final hint = summary.value?.withdrawalHint;
    if (hint == null || hint.trim().isEmpty) return null;
    return hint;
  }

  List<WalletLedgerEntryEntity> get ledgerEntries =>
      summary.value?.ledger ?? [];

  bool get isWithdrawalsTabEmpty =>
      !isLoading.value && error.value == null && withdrawals.isEmpty;

  bool get isLedgerTabEmpty =>
      !isLoading.value && error.value == null && ledgerEntries.isEmpty;

  String formatDate(DateTime dt) => _date.format(dt);

  String formatTime(DateTime dt) => _time.format(dt).toLowerCase();

  String formatDateTime(DateTime dt) => '${formatDate(dt)} • ${formatTime(dt)}';

  String formatAmount(double amount) => _amount.format(amount.abs());

  /// "BankTransfer" -> "BANK TRANSFER"
  String destinationLabel(String destinationType) {
    final spaced = destinationType.replaceAllMapped(
      RegExp('(?<=[a-z])(?=[A-Z])'),
      (m) => ' ',
    );
    return spaced.toUpperCase();
  }

  String withdrawalStatusLabel(WithdrawalStatus status) {
    switch (status) {
      case WithdrawalStatus.paid:
        return 'Paid';
      case WithdrawalStatus.pending:
        return 'Pending';
      case WithdrawalStatus.processing:
        return 'Processing';
      case WithdrawalStatus.rejected:
        return 'Rejected';
      case WithdrawalStatus.unknown:
        return 'Unknown';
    }
  }

  String ledgerEntryLabel(WalletLedgerEntryType type) {
    switch (type) {
      case WalletLedgerEntryType.withdrawal:
        return 'WITHDRAWAL';
      case WalletLedgerEntryType.rewardPayout:
        return 'REWARD PAYOUT';
      case WalletLedgerEntryType.withdrawalReversal:
        return 'WITHDRAWAL REVERSAL';
      case WalletLedgerEntryType.unknown:
        return 'TRANSACTION';
    }
  }

  /// Debits (withdrawal requests) are shown as a negative delta;
  /// everything else (reward payouts, reversals back into the wallet)
  /// is a credit. The sign is derived from the entry type rather than
  /// trusted from the raw amount, since the API doesn't document a
  /// signed-amount convention.
  bool isLedgerEntryDebit(WalletLedgerEntryType type) =>
      type == WalletLedgerEntryType.withdrawal;
}
