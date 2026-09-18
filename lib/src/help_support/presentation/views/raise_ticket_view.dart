import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/help_support/presentation/controllers/raise_ticket_controller.dart';
import 'package:kamao/src/help_support/presentation/widgets/support_ui.dart';
import 'package:remixicon/remixicon.dart';

class RaiseTicketView extends GetView<RaiseTicketController> {
  const RaiseTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
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
                const _RaiseHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      24 + (bottomInset > 0 ? 12 : 0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF2F5F9)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A1A153B),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _SectionTitle(title: 'New ticket'),
                          const SizedBox(height: 6),
                          const Text(
                            'Tell us what\'s going on and we\'ll get back to you.',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: AppColors.bodyGrey,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _LabeledField(
                            label: 'SUBJECT',
                            child: TextField(
                              controller: controller.subjectController,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                              ),
                              decoration: supportInputDecoration(
                                hint: 'Brief summary of your issue',
                                prefixIcon: const Icon(
                                  RemixIcons.edit_2_line,
                                  size: 18,
                                  color: Color(0xFF8A9A86),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _LabeledField(
                            label: 'DESCRIPTION',
                            child: TextField(
                              controller: controller.descriptionController,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.newline,
                              minLines: 5,
                              maxLines: 10,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: AppColors.heading,
                                height: 1.4,
                              ),
                              decoration: supportInputDecoration(
                                hint: 'Describe the issue in detail',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _LabeledField(
                            label: 'PRIORITY',
                            child: Obx(
                              () => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7FAF6),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFE4EBE1),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: controller.priority.value,
                                    isExpanded: true,
                                    icon: const Icon(
                                      RemixIcons.arrow_down_s_line,
                                      color: AppColors.bodyGrey,
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
                                    ),
                                    items: RaiseTicketController.priorities
                                        .map(
                                          (p) => DropdownMenuItem(
                                            value: p,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  RemixIcons.flag_2_line,
                                                  size: 16,
                                                  color: _priorityColor(p),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(p),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.priority.value = value;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                          const SizedBox(height: 24),
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
                                            'Submit ticket',
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color _priorityColor(String priority) {
  switch (priority) {
    case 'Critical':
      return const Color(0xFFDC2626);
    case 'High':
      return const Color(0xFFEA580C);
    case 'Medium':
      return const Color(0xFFB45309);
    default:
      return const Color(0xFF426340);
  }
}

class _RaiseHeader extends StatelessWidget {
  const _RaiseHeader();

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
              'Raise a ticket',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
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
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
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
            letterSpacing: 0.6,
            color: Color(0xFF6E6971),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
