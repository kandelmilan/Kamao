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
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.homeBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
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
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    24 + (bottomInset > 0 ? 12 : 0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _AvailableCard(controller: controller),
                      const SizedBox(height: 28),
                      const _SectionTitle(title: 'Withdrawal Request'),
                      const SizedBox(height: 18),
                      _AmountField(controller: controller),
                      const SizedBox(height: 16),
                      _PayoutMethodField(controller: controller),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'ACCOUNT HOLDER NAME',
                        child: TextField(
                          controller: controller.accountNameController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          style: _fieldTextStyle,
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
                            controller: controller.accountNumberController,
                            keyboardType: TextInputType.phone,
                            textInputAction: isWallet
                                ? TextInputAction.done
                                : TextInputAction.next,
                            style: _fieldTextStyle,
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
                              textInputAction: TextInputAction.done,
                              style: _fieldTextStyle,
                              decoration: _inputDecoration(
                                hint: 'e.g. PRABHU',
                              ),
                            ),
                          ),
                        );
                      }),
                      Obx(() {
                        final err = controller.fieldError.value;
                        if (err == null || err.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
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
                      const SizedBox(height: 16),
                      const _InfoNote(),
                      const SizedBox(height: 28),
                      Obx(() {
                        final busy = controller.isSubmitting.value;
                        return SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: busy ? null : controller.submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF334D32),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(
                                0xFF334D32,
                              ).withValues(alpha: 0.5),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
                                : const Text(
                                    'Request Withdrawal',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 24 / 16,
                                      color: Colors.white,
                                    ),
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
    );
  }
}

const TextStyle _fieldTextStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: AppColors.heading,
);

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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDECED)),
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
            style: _fieldTextStyle,
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
                color: Color(0xFF6F338D),
              ),
              borderRadius: BorderRadius.circular(12),
              selectedItemBuilder: (context) {
                return destinations
                    .map(
                      (destination) => Align(
                        alignment: Alignment.centerLeft,
                        child: _PayoutOptionRow(
                          destination: destination,
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
                        destination: destination,
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

  static const _bg = Color(0xFFF3F4F8);
  static const _border = Color(0xFFCBD5E1);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: const _DashedRRectPainter(
        color: _border,
        radius: 12,
        dash: 3,
        gap: 2,
      ),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 96.5),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              RemixIcons.information_line,
              size: 16,
              color: Color(0xFF64748B),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Funds will be transferred to your selected account within '
                '24-48 business hours. Please ensure details are correct.',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 16.5 / 12,
                  color: Color(0xFF4A5568),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.radius,
    this.dash = 3,
    this.gap = 2,
  });

  final Color color;
  final double radius;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.dash != dash ||
      oldDelegate.gap != gap;
}

/// Shared icon + label row so the closed dropdown and menu items match.
class _PayoutOptionRow extends StatelessWidget {
  const _PayoutOptionRow({
    required this.destination,
    required this.label,
  });

  final String destination;
  final String label;

  static const double _iconSize = 28;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PayoutMethodIcon(destination: destination, size: _iconSize),
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

class _PayoutMethodIcon extends StatelessWidget {
  const _PayoutMethodIcon({required this.destination, required this.size});

  final String destination;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isBank = destination.toLowerCase().contains('bank');
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0E5),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(
        isBank ? RemixIcons.bank_line : RemixIcons.smartphone_line,
        size: size * 0.55,
        color: AppColors.onboardingGreen,
      ),
    );
  }
}
