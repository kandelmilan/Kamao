import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/wallet/domain/entities/response/withdrawal_entity.dart';
import 'package:kamao/src/wallet/wallet.dart' hide WithdrawalStatus;
import 'package:remixicon/remixicon.dart';

import '../controllers/wallet_controller.dart';

/// Segmented control for switching between Withdrawals and Ledger.
/// Shared by the wallet home page and the "See All" page so both stay
/// visually identical.
class WalletActivityTabs extends StatelessWidget {
  const WalletActivityTabs({super.key, required this.controller});

  final WalletController controller;

  static const _trackColor = Color(0xFFEDECED);
  static const _untappedColor = Color(0xFF4A434D);
  static const _tappedColor = Color(0xFF426340);
  static const _pillHeight = 28.0;
  static const _transition = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _trackColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        final selected = controller.selectedTab.value;
        final isLedger = selected == WalletActivityTab.ledger;

        return LayoutBuilder(
          builder: (context, constraints) {
            final pillWidth = constraints.maxWidth / 2;

            return Stack(
              children: [
                // Sliding white pill — inactive side stays fully transparent.
                AnimatedAlign(
                  duration: _transition,
                  curve: Curves.easeInOut,
                  alignment:
                      isLedger ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: pillWidth,
                    height: _pillHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _ActivityTabButton(
                        label: 'Withdrawals',
                        isSelected: !isLedger,
                        onTap: () => controller
                            .selectTab(WalletActivityTab.withdrawals),
                      ),
                    ),
                    Expanded(
                      child: _ActivityTabButton(
                        label: 'Ledger',
                        isSelected: isLedger,
                        onTap: () =>
                            controller.selectTab(WalletActivityTab.ledger),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}

class _ActivityTabButton extends StatelessWidget {
  const _ActivityTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: WalletActivityTabs._pillHeight,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: WalletActivityTabs._transition,
            curve: Curves.easeInOut,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
              color: isSelected
                  ? WalletActivityTabs._tappedColor
                  : WalletActivityTabs._untappedColor,
            ),
            child: Text(label, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

/// Renders the list for whichever tab is selected.
///
/// Pass [maxItems] to cap the number of rows shown (used on the wallet
/// home page for a "latest N" preview). Leave it null to show everything
/// currently loaded (used on the "See All" page).
class WalletActivityList extends StatelessWidget {
  const WalletActivityList({
    super.key,
    required this.controller,
    this.maxItems,
    this.expandEmpty = false,
  });

  final WalletController controller;
  final int? maxItems;

  /// When true, empty state fills available height and centers the message
  /// (used on the All Transactions page).
  final bool expandEmpty;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tab = controller.selectedTab.value;
      final isWithdrawals = tab == WalletActivityTab.withdrawals;

      final isLoading =
          controller.isLoading.value &&
          (isWithdrawals
              ? controller.withdrawals.isEmpty
              : controller.ledgerEntries.isEmpty);

      if (isLoading) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
          ),
        );
      }

      final isEmpty = isWithdrawals
          ? controller.isWithdrawalsTabEmpty
          : controller.isLedgerTabEmpty;

      if (controller.error.value != null && isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: TextButton(
              onPressed: controller.refresh,
              child: const Text("Couldn't load activity — tap to retry"),
            ),
          ),
        );
      }

      if (isEmpty) {
        final emptyMessage = Text(
          isWithdrawals ? 'No withdrawal yet' : 'No ledger entries yet',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.bodyGrey,
          ),
        );

        if (expandEmpty) {
          return Center(child: emptyMessage);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: Center(child: emptyMessage),
        );
      }

      if (isWithdrawals) {
        final all = controller.withdrawals;
        final items = (maxItems == null || all.length <= maxItems!)
            ? all
            : all.take(maxItems!).toList();
        return Column(
          children: [
            for (final withdrawal in items) ...[
              _WithdrawalRow(controller: controller, withdrawal: withdrawal),
              if (withdrawal != items.last) const SizedBox(height: 12),
            ],
          ],
        );
      }

      final all = controller.ledgerEntries;
      final entries = (maxItems == null || all.length <= maxItems!)
          ? all
          : all.take(maxItems!).toList();
      return Column(
        children: [
          for (final entry in entries) ...[
            _LedgerRow(controller: controller, entry: entry),
            if (entry != entries.last) const SizedBox(height: 12),
          ],
        ],
      );
    });
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: child,
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}

class _WithdrawalRow extends StatelessWidget {
  const _WithdrawalRow({required this.controller, required this.withdrawal});

  final WalletController controller;
  final WithdrawalEntity withdrawal;

  _StatusColors get _colors {
    switch (withdrawal.status) {
      case WithdrawalStatus.paid:
        return const _StatusColors(
          amount: Color(0xFF16A34A),
          pillBg: Color(0xFFE7F8EE),
          pillFg: Color(0xFF16A34A),
        );
      case WithdrawalStatus.pending:
      case WithdrawalStatus.processing:
        return const _StatusColors(
          amount: Color(0xFFCA8A04),
          pillBg: Color(0xFFFFF3DA),
          pillFg: Color(0xFFCA8A04),
        );
      case WithdrawalStatus.rejected:
        return const _StatusColors(
          amount: Color(0xFFDC2626),
          pillBg: Color(0xFFFDE7E9),
          pillFg: Color(0xFFDC2626),
        );
      case WithdrawalStatus.unknown:
        return const _StatusColors(
          amount: Color(0xFFCA8A04),
          pillBg: Color(0xFFFFF3DA),
          pillFg: Color(0xFFCA8A04),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors;
    return _ActivityCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DestinationIcon(destinationType: withdrawal.destinationType),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.destinationLabel(withdrawal.destinationType),
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    color: Color(0xFF4A434D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.formatDateTime(withdrawal.requestedAt)} • '
                  '${withdrawal.accountNumber}',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    height: 16.5 / 11,
                    color: Color(0xFF6E6971),
                  ),
                ),
                if (withdrawal.status == WithdrawalStatus.rejected &&
                    (withdrawal.adminNote ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    withdrawal.adminNote!,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 16.5 / 11,
                      color: Color(0xFFD92D20),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                controller.formatAmount(withdrawal.amount),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 16 / 12,
                  color: colors.amount,
                ),
              ),
              const SizedBox(height: 6),
              _StatusPill(
                label: controller.withdrawalStatusLabel(withdrawal.status),
                background: colors.pillBg,
                foreground: colors.pillFg,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DestinationIcon extends StatelessWidget {
  const _DestinationIcon({required this.destinationType});

  final String destinationType;

  static const double _size = 44;

  @override
  Widget build(BuildContext context) {
    final normalized = destinationType.toLowerCase();

    if (normalized.contains('esewa')) {
      return _LogoCircle(assetPath: AppImages.esewa);
    }

    if (normalized.contains('khalti')) {
      return _LogoCircle(assetPath: AppImages.khalti);
    }

    // Banking / bank transfer / anything else.
    return Container(
      width: _size,
      height: _size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF4595E),
      ),
      alignment: Alignment.center,
      child: const Icon(RemixIcons.bank_line, size: 20, color: Colors.white),
    );
  }
}

class _LogoCircle extends StatelessWidget {
  const _LogoCircle({required this.assetPath});

  final String assetPath;

  static const double _size = 44;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      // NOTE: clipBehavior requires a `decoration`, not the `color`
      // shorthand — Container asserts `decoration != null ||
      // clipBehavior == Clip.none`. Using BoxDecoration here avoids the
      // "Failed assertion... decoration != null" crash.
      decoration: const BoxDecoration(color: Colors.white),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: Image.asset(
        assetPath,
        width: _size,
        height: _size,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.controller, required this.entry});

  final WalletController controller;
  final WalletLedgerEntryEntity entry;

  @override
  Widget build(BuildContext context) {
    final isDebit = controller.isLedgerEntryDebit(entry.entryType);
    final isReversal =
        entry.entryType == WalletLedgerEntryType.withdrawalReversal;
    final amountColor = isDebit
        ? const Color(0xFFD92D20)
        : const Color(0xFF16A34A);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 104),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.ledgerEntryLabel(entry.entryType).toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                      color: Color(0xFF4A434D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.formatDateTime(entry.createdAt),
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      height: 16.5 / 11,
                      color: Color(0xFF6E6971),
                    ),
                  ),
                  if (entry.narration.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.narration,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        height: 16.5 / 11,
                        color: isReversal
                            ? const Color(0xFFD92D20)
                            : const Color(0xFF6E6971),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const _VerticalDivider(),
            SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${isDebit ? '-' : ''}${controller.formatAmount(entry.amount)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.currency,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      height: 16.5 / 11,
                      color: Color(0xFF6E6971),
                    ),
                  ),
                ],
              ),
            ),
            const _VerticalDivider(),
            SizedBox(
              width: 78,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.formatAmount(entry.balanceAfter),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Balance After',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      height: 16.5 / 11,
                      color: Color(0xFF6E6971),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 32,
        child: VerticalDivider(
          width: 1,
          thickness: 1,
          color: Color(0xFFEDECED),
        ),
      ),
    );
  }
}

class _StatusColors {
  const _StatusColors({
    required this.amount,
    required this.pillBg,
    required this.pillFg,
  });

  final Color amount;
  final Color pillBg;
  final Color pillFg;
}
