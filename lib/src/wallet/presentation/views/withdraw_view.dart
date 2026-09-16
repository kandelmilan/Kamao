import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/wallet/presentation/controllers/withdraw_controller.dart';
import 'package:remixicon/remixicon.dart';

/// Withdraw screen — Figma Campaign App node 725:4191.
class WithdrawView extends GetView<WithdrawController> {
  const WithdrawView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Colors.white)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.onboardingBgTop,
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const _WithdrawHeader(),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.summary.value == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _AvailableCard(controller: controller),
                          const SizedBox(height: 24),
                          const _SectionTitle(title: 'Withdrawal Request'),
                          const SizedBox(height: 16),
                          _AmountField(controller: controller),
                          const SizedBox(height: 16),
                          _PayoutMethodField(controller: controller),
                          const SizedBox(height: 16),
                          _LabeledField(
                            label: 'ACCOUNT HOLDER NAME',
                            child: TextField(
                              controller: controller.accountNameController,
                              textCapitalization: TextCapitalization.words,
                              decoration: _inputDecoration(
                                hint: 'Full name as per ID',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(() {
                            final isWallet = controller.isWalletDestination;
                            return _LabeledField(
                              label: isWallet
                                  ? 'MOBILE NUMBER'
                                  : 'ACCOUNT NUMBER',
                              child: TextField(
                                controller:
                                    controller.accountNumberController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                decoration: _inputDecoration(
                                  hint: isWallet
                                      ? '98XXXXXXXX'
                                      : 'Account number',
                                ),
                              ),
                            );
                          }),
                          Obx(() {
                            if (controller.isWalletDestination) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: _LabeledField(
                                label: 'BANK NAME',
                                child: TextField(
                                  controller: controller.bankNameController,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  decoration: _inputDecoration(
                                    hint: 'e.g. PRABHU',
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                          Obx(() {
                            final err = controller.fieldError.value;
                            if (err == null || err.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                err,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFDC2626),
                                ),
                              ),
                            );
                          }),
                          const _InfoNote(),
                          const SizedBox(height: 28),
                          Obx(() {
                            final busy = controller.isSubmitting.value;
                            return SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: busy ? null : controller.submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.walletButton,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: AppColors
                                      .walletButton
                                      .withValues(alpha: 0.5),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: busy
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Request Withdrawal',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            RemixIcons.arrow_right_line,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFF9A949E),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFEDECED)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFEDECED)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.onboardingGreen, width: 1.5),
    ),
  );
}

class _WithdrawHeader extends StatelessWidget {
  const _WithdrawHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              RemixIcons.arrow_left_s_line,
              size: 28,
              color: AppColors.heading,
            ),
          ),
          const Expanded(
            child: Text(
              'withdraw',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _AvailableCard extends StatelessWidget {
  const _AvailableCard({required this.controller});

  final WithdrawController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6F0E4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AVAILABLE TO WITHDRAW',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: Color(0xFF6E6971),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              controller.formattedAvailableBalance,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.cardTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.onboardingGreen,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.cardTitle,
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Color(0xFF6E6971),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller});

  final WithdrawController controller;

  @override
  Widget build(BuildContext context) {
    return _LabeledField(
      label: 'AMOUNT (${controller.currency})',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: _inputDecoration(hint: 'Rs. 0.00'),
          ),
          const SizedBox(height: 6),
          Obx(
            () => Text(
              controller.minWithdrawalLabel,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9A949E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PayoutMethodField extends StatelessWidget {
  const _PayoutMethodField({required this.controller});

  final WithdrawController controller;

  @override
  Widget build(BuildContext context) {
    return _LabeledField(
      label: 'PAYOUT METHOD',
      child: Obx(() {
        final destinations = controller.destinations.toList();
        final selected = controller.normalizeDestination(
          controller.selectedDestination.value,
        );
        final value = destinations.contains(selected)
            ? selected
            : (destinations.isNotEmpty ? destinations.first : null);

        return InputDecorator(
          decoration: _inputDecoration(hint: 'Select payout method').copyWith(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                RemixIcons.arrow_down_s_line,
                size: 20,
                color: Color(0xFF6E6971),
              ),
              borderRadius: BorderRadius.circular(12),
              selectedItemBuilder: (context) {
                return destinations
                    .map(
                      (destination) => Align(
                        alignment: Alignment.centerLeft,
                        child: _PayoutOptionRow(
                          logo: controller.logoFor(destination),
                          label: controller.destinationLabel(destination),
                        ),
                      ),
                    )
                    .toList();
              },
              items: destinations
                  .map(
                    (destination) => DropdownMenuItem<String>(
                      value: destination,
                      child: _PayoutOptionRow(
                        logo: controller.logoFor(destination),
                        label: controller.destinationLabel(destination),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (next) {
                if (next == null) return;
                controller.selectDestination(next);
              },
            ),
          ),
        );
      }),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(RemixIcons.information_line, size: 16, color: Color(0xFF6E6971)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Funds will be transferred to your selected account within '
            '24-48 business hours. Please ensure details are correct.',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 16.5 / 12,
              color: Color(0xFF6E6971),
            ),
          ),
        ),
      ],
    );
  }
}

/// Shared logo + label row so the closed dropdown and menu items match.
class _PayoutOptionRow extends StatelessWidget {
  const _PayoutOptionRow({required this.label, this.logo});

  final String? logo;
  final String label;

  static const double _logoSize = 28;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PayoutLogo(logo: logo, size: _logoSize),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
            ),
          ),
        ),
      ],
    );
  }
}

class _PayoutLogo extends StatelessWidget {
  const _PayoutLogo({required this.size, this.logo});

  final String? logo;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (logo == null) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFFE8F0E5),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          RemixIcons.bank_line,
          size: size * 0.55,
          color: AppColors.onboardingGreen,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEDECED)),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: Image.asset(
        logo!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Icon(
          RemixIcons.bank_line,
          size: size * 0.55,
          color: AppColors.onboardingGreen,
        ),
      ),
    );
  }
}
