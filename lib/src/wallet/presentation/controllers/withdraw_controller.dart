import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/app_config_entity.dart';
import 'package:kamao/src/home/domain/usecase/get_app_config_usecase.dart';
import 'package:kamao/src/home/presentation/controllers/home_controller.dart';
import 'package:kamao/src/main_nav/presentation/controllers/main_nav_controller.dart';
import 'package:kamao/src/wallet/domain/entities/response/payout_method_entity.dart';
import 'package:kamao/src/wallet/domain/usecases/create_withdrawal_usecase.dart';
import 'package:kamao/src/wallet/domain/usecases/get_payout_method_usecase.dart';
import 'package:kamao/src/wallet/presentation/controllers/wallet_controller.dart';
import 'package:kamao/src/wallet/wallet.dart' hide WithdrawalStatus;

class WithdrawController extends GetxController {
  WithdrawController(
    this._getWallet,
    this._getPayoutMethod,
    this._createWithdrawal, {
    GetAppConfigUseCase? getAppConfig,
  }) : _getAppConfig = getAppConfig;

  final GetWalletUseCase _getWallet;
  final GetPayoutMethodUseCase _getPayoutMethod;
  final CreateWithdrawalUseCase _createWithdrawal;
  final GetAppConfigUseCase? _getAppConfig;

  static const double minWithdrawalAmount = 100;

  static final _amountFormat = NumberFormat('#,##0.00');

  final amountController = TextEditingController();
  final accountNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final bankNameController = TextEditingController();

  final Rxn<WalletSummaryEntity> summary = Rxn<WalletSummaryEntity>();
  final Rxn<PayoutMethodEntity> savedPayoutMethod = Rxn<PayoutMethodEntity>();
  final RxList<String> destinations = <String>['khalti', 'esewa'].obs;
  final RxString selectedDestination = 'khalti'.obs;

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxnString error = RxnString();
  final RxnString fieldError = RxnString();

  WalletEntity? get _wallet => summary.value?.primaryWallet;

  String get currency => _wallet?.currency.toUpperCase() ?? 'NPR';

  double get availableBalance => _wallet?.balance ?? 0;

  String get formattedAvailableBalance {
    final wallet = _wallet;
    if (wallet == null) return '—';
    return '${wallet.currency.toUpperCase()} '
        '${_amountFormat.format(wallet.balance)}';
  }

  String get minWithdrawalLabel =>
      'Min withdrawal: $currency ${_amountFormat.format(minWithdrawalAmount)}';

  bool get isWalletDestination {
    final d = selectedDestination.value.toLowerCase();
    return d.contains('khalti') || d.contains('esewa');
  }

  /// Canonical id used for API + logo mapping.
  String normalizeDestination(String raw) {
    final lower = raw.trim().toLowerCase();
    if (lower.contains('khalti')) return 'khalti';
    if (lower.contains('esewa')) return 'esewa';
    if (lower.contains('bank')) return 'bank';
    return lower;
  }

  String destinationLabel(String raw) {
    switch (normalizeDestination(raw)) {
      case 'khalti':
        return 'Khalti Wallet';
      case 'esewa':
        return 'eSewa Wallet';
      case 'bank':
        return 'Bank Transfer';
      default:
        final spaced = raw.replaceAllMapped(
          RegExp('(?<=[a-z])(?=[A-Z])'),
          (m) => ' ',
        );
        final lower = spaced.toLowerCase().trim();
        if (lower.isEmpty) return 'Payout method';
        return '${lower[0].toUpperCase()}${lower.substring(1)}';
    }
  }

  String? logoFor(String raw) {
    switch (normalizeDestination(raw)) {
      case 'khalti':
        return AppImages.khalti;
      case 'esewa':
        return AppImages.esewa;
      default:
        return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  @override
  void onClose() {
    amountController.dispose();
    accountNameController.dispose();
    accountNumberController.dispose();
    bankNameController.dispose();
    super.onClose();
  }

  /// Fresh wallet + payout method every time the screen opens.
  Future<void> refreshAll() async {
    isLoading.value = true;
    error.value = null;

    await Future.wait([
      _loadWallet(force: true),
      _loadPayoutMethod(),
      _loadDestinations(),
    ]);

    _applySavedPayoutMethod();
    isLoading.value = false;
  }

  Future<void> _loadWallet({bool force = false}) async {
    if (!force && Get.isRegistered<WalletController>()) {
      final existing = Get.find<WalletController>().summary.value;
      if (existing != null) {
        summary.value = existing;
        return;
      }
    }

    final result = await _getWallet(const NoParams());
    result.fold(
      (failure) => error.value = failure.message,
      (data) {
        summary.value = data;
        if (Get.isRegistered<WalletController>()) {
          Get.find<WalletController>().summary.value = data;
        }
      },
    );
  }

  Future<void> _loadPayoutMethod() async {
    final result = await _getPayoutMethod(const NoParams());
    result.fold(
      (_) => savedPayoutMethod.value = null,
      (data) {
        savedPayoutMethod.value = data;
        if (Get.isRegistered<WalletController>()) {
          Get.find<WalletController>().payoutMethod.value = data;
        }
      },
    );
  }

  Future<void> _loadDestinations() async {
    final usecase = _getAppConfig;
    if (usecase == null) return;

    final result = await usecase(const NoParams());
    result.fold(
      (_) {},
      (AppConfigEntity config) {
        final seen = <String>{};
        final list = <String>[];
        for (final raw in config.payoutDestinations) {
          final id = normalizeDestination(raw);
          if (id.isEmpty || seen.contains(id)) continue;
          seen.add(id);
          list.add(id);
        }
        if (list.isNotEmpty) {
          destinations.assignAll(list);
          if (!seen.contains(normalizeDestination(selectedDestination.value))) {
            selectedDestination.value = list.first;
          } else {
            selectedDestination.value =
                normalizeDestination(selectedDestination.value);
          }
        }
      },
    );
  }

  void _applySavedPayoutMethod() {
    final saved = savedPayoutMethod.value;
    if (saved == null) return;

    final id = normalizeDestination(saved.destinationType);
    if (id.isNotEmpty) {
      if (!destinations.contains(id)) {
        destinations.insert(0, id);
      }
      selectedDestination.value = id;
    }

    accountNameController.text = saved.accountName;
    accountNumberController.text = saved.accountNumber;
    bankNameController.text = saved.bankName ?? '';
  }

  void selectDestination(String value) {
    selectedDestination.value = normalizeDestination(value);
    fieldError.value = null;
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;
    fieldError.value = null;

    final amountText = amountController.text
        .replaceAll(',', '')
        .replaceAll('Rs.', '')
        .replaceAll('रू', '')
        .replaceAll(currency, '')
        .trim();
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      fieldError.value = 'Enter a valid withdrawal amount';
      return;
    }
    if (amount < minWithdrawalAmount) {
      fieldError.value =
          'Minimum withdrawal is $currency '
          '${_amountFormat.format(minWithdrawalAmount)}';
      return;
    }
    if (amount > availableBalance) {
      fieldError.value = 'Amount exceeds available balance';
      return;
    }

    final accountName = accountNameController.text.trim();
    final accountNumber = accountNumberController.text.trim();
    if (accountName.isEmpty) {
      fieldError.value = 'Account holder name is required';
      return;
    }
    if (accountNumber.isEmpty) {
      fieldError.value = isWalletDestination
          ? 'Mobile number is required'
          : 'Account number is required';
      return;
    }

    final destination = normalizeDestination(selectedDestination.value);
    if (destination.isEmpty) {
      fieldError.value = 'Select a payout method';
      return;
    }

    String? bankName = bankNameController.text.trim();
    if (bankName.isEmpty) {
      bankName = isWalletDestination ? destination : null;
    }
    if (!isWalletDestination && (bankName == null || bankName.isEmpty)) {
      fieldError.value = 'Bank name is required';
      return;
    }

    isSubmitting.value = true;
    final result = await _createWithdrawal(
      CreateWithdrawalParams(
        amount: amount,
        destinationType: destination,
        accountName: accountName,
        accountNumber: accountNumber,
        currency: currency,
        bankName: bankName,
      ),
    );

    await result.fold(
      (failure) async {
        fieldError.value = failure.message;
        Get.snackbar(
          'Withdrawal failed',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) async {
        Get.snackbar(
          'Request submitted',
          'Your withdrawal request is being processed.',
          snackPosition: SnackPosition.BOTTOM,
        );
        await _refreshAfterSuccess();
        _navigateToHome();
      },
    );

    isSubmitting.value = false;
  }

  Future<void> _refreshAfterSuccess() async {
    if (Get.isRegistered<WalletController>()) {
      await Get.find<WalletController>().refresh();
    } else {
      await Future.wait([_loadWallet(force: true), _loadPayoutMethod()]);
    }
    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().refreshHome();
    }
  }

  void _navigateToHome() {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(MainNavTab.home);
      Get.until(
        (route) =>
            route.settings.name == AppRoutes.mainNav || route.isFirst,
      );
      return;
    }

    Get.offAllNamed(AppRoutes.mainNav);
  }
}
