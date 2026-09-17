import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_entity.dart';
import 'package:kamao/src/help_support/presentation/controllers/view_tickets_controller.dart';
import 'package:kamao/src/help_support/presentation/utils/support_ticket_status_filter.dart';
import 'package:kamao/src/help_support/presentation/widgets/support_ui.dart';
import 'package:remixicon/remixicon.dart';

class ViewTicketsView extends GetView<ViewTicketsController> {
  const ViewTicketsView({super.key});

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
                _TicketsHeader(onNewTicket: controller.openRaiseTicket),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.tickets.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.onboardingGreen,
                        ),
                      );
                    }

                    if (controller.error.value != null &&
                        controller.tickets.isEmpty) {
                      return _EmptyState(
                        icon: RemixIcons.error_warning_line,
                        title: "Couldn't load tickets",
                        subtitle: controller.error.value!,
                        actionLabel: 'Retry',
                        onAction: controller.loadTickets,
                      );
                    }

                    final filtered = controller.filteredTickets;

                    return RefreshIndicator(
                      color: AppColors.onboardingGreen,
                      onRefresh: controller.loadTickets,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                              child: _MyTicketsCard(
                                filter: controller.statusFilter.value,
                                onFilterChanged: controller.setStatusFilter,
                                tickets: filtered,
                                allEmpty: controller.tickets.isEmpty,
                                onOpen: controller.openTicket,
                                onRaise: controller.openRaiseTicket,
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 24)),
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

class _TicketsHeader extends StatelessWidget {
  const _TicketsHeader({required this.onNewTicket});

  final VoidCallback onNewTicket;

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
              'Support',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
          ),
          TextButton(
            onPressed: onNewTicket,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onboardingGreen,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(RemixIcons.add_line, size: 18),
                SizedBox(width: 2),
                Text(
                  'New',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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

class _MyTicketsCard extends StatelessWidget {
  const _MyTicketsCard({
    required this.filter,
    required this.onFilterChanged,
    required this.tickets,
    required this.allEmpty,
    required this.onOpen,
    required this.onRaise,
  });

  final String filter;
  final ValueChanged<String> onFilterChanged;
  final List<SupportTicketEntity> tickets;
  final bool allEmpty;
  final ValueChanged<SupportTicketEntity> onOpen;
  final VoidCallback onRaise;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0E5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    RemixIcons.customer_service_2_line,
                    size: 16,
                    color: Color(0xFF4C5749),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'My tickets',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.cardTitle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: onRaise,
                    icon: const Icon(RemixIcons.add_line, size: 16),
                    label: const Text(
                      'New ticket',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.walletButton,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _StatusFilterDropdown(
              value: filter,
              onChanged: onFilterChanged,
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF2F5F9)),
          if (allEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: _InlineEmpty(
                title: 'No tickets yet',
                subtitle: 'Raise a ticket and it will appear here.',
                actionLabel: 'New ticket',
                onAction: onRaise,
              ),
            )
          else if (tickets.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: _InlineEmpty(
                title: 'No matches',
                subtitle: 'No tickets for this status filter.',
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              itemCount: tickets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _TicketCard(
                  ticket: ticket,
                  onTap: () => onOpen(ticket),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _StatusFilterDropdown extends StatelessWidget {
  const _StatusFilterDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'STATUS',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: Color(0xFF6E6971),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAF6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4EBE1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                RemixIcons.arrow_down_s_line,
                color: AppColors.bodyGrey,
              ),
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
              ),
              items: SupportTicketStatusFilter.values
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(SupportTicketStatusFilter.label(status)),
                    ),
                  )
                  .toList(),
              onChanged: (next) {
                if (next != null) onChanged(next);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.onTap});

  final SupportTicketEntity ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final updated = ticket.updatedAt ?? ticket.createdAt;
    final updatedLabel = updated == null
        ? ''
        : DateFormat('M/d/yyyy h:mm:ss a').format(updated.toLocal());
    final shortId = ticket.id.length > 8
        ? '${ticket.id.substring(0, 8)}…'
        : ticket.id;

    return Material(
      color: const Color(0xFFF7FAF6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.subject,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onboardingGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          shortId,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9B7BA8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SupportStatusChip(status: ticket.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'PRIORITY',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: Color(0xFF9A949E),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    ticket.priority.isEmpty ? '—' : ticket.priority,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.subtext,
                    ),
                  ),
                  const Spacer(),
                  if (updatedLabel.isNotEmpty)
                    Flexible(
                      child: Text(
                        updatedLabel,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9A949E),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  const _InlineEmpty({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 13,
            color: AppColors.bodyGrey,
          ),
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                color: AppColors.onboardingGreen,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0E5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 28, color: const Color(0xFF4C5749)),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.bodyGrey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.onboardingGreen,
              ),
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
