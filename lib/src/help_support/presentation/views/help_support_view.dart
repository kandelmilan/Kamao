import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:remixicon/remixicon.dart';

/// Hub: Raise a ticket / View tickets — matches profile settings card style.
class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  static const _cardBorder = Color(0xFFF2F5F9);
  static const _rowIconBg = Color(0xFFE8F0E5);
  static const _rowIconColor = Color(0xFF4C5749);
  static const _rowTitle = Color(0xFF4A434D);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Color(0xFFFAFAF9))),
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
                const _HelpHeader(title: 'Help & Support'),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      const Text(
                        'How can we help?',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Raise a new ticket or check the status of existing ones.',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.bodyGrey,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _OptionsCard(
                        children: [
                          _OptionRow(
                            icon: RemixIcons.add_circle_line,
                            title: 'Raise a ticket',
                            onTap: () => Get.toNamed(AppRoutes.raiseTicket),
                          ),
                          const Divider(height: 1, color: _cardBorder),
                          _OptionRow(
                            icon: RemixIcons.file_list_3_line,
                            title: 'View tickets',
                            onTap: () => Get.toNamed(AppRoutes.viewTickets),
                          ),
                        ],
                      ),
                    ],
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

class _HelpHeader extends StatelessWidget {
  const _HelpHeader({required this.title});

  final String title;

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
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
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

class _OptionsCard extends StatelessWidget {
  const _OptionsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HelpSupportView._cardBorder),
      ),
      child: Column(children: children),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: HelpSupportView._rowIconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: HelpSupportView._rowIconColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: HelpSupportView._rowTitle,
                ),
              ),
            ),
            const Icon(
              RemixIcons.arrow_right_s_line,
              size: 22,
              color: Color(0xFF9A949E),
            ),
          ],
        ),
      ),
    );
  }
}
