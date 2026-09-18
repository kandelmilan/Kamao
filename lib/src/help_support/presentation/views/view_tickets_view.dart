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
                const _TicketsHeader(),
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
                    final allEmpty = controller.tickets.isEmpty;

                    return RefreshIndicator(
                      color: AppColors.onboardingGreen,
                      onRefresh: controller.loadTickets,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                              child: _TicketsToolbar(
                                filter: controller.statusFilter.value,
                                onFilterChanged: controller.setStatusFilter,
                                onRaise: controller.openRaiseTicket,
                              ),
                            ),
                          ),
                          if (allEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _EmptyState(
                                icon: RemixIcons.file_list_3_line,
                                title: 'No tickets yet',
                                subtitle:
                                    'Raise a ticket and it will appear here.',
                                actionLabel: 'New ticket',
                                onAction: controller.openRaiseTicket,
                              ),
                            )
                          else if (filtered.isEmpty)
                            const SliverFillRemaining(
                              hasScrollBody: false,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 32),
                                child: _InlineEmpty(
                                  title: 'No matches',
                                  subtitle:
                                      'No tickets for this status filter.',
                                ),
                              ),
                            )
                          else
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                              sliver: SliverList.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final ticket = filtered[index];
                                  return _TicketCard(
                                    ticket: ticket,
                                    onTap: () => controller.openTicket(ticket),
                                  );
                                },
                              ),
                            ),
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
  const _TicketsHeader();

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
              'View tickets',
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

class _TicketsToolbar extends StatelessWidget {
  const _TicketsToolbar({
    required this.filter,
    required this.onFilterChanged,
    required this.onRaise,
  });

  final String filter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onRaise;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                RemixIcons.customer_service_2_line,
                size: 18,
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
        const SizedBox(height: 14),
        _StatusFilterDropdown(
          value: filter,
          onChanged: onFilterChanged,
        ),
      ],
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
            color: Colors.white,
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
        : DateFormat('MMM d, yyyy · h:mm a').format(updated.toLocal());
    final shortId = ticket.id.length > 8
        ? '${ticket.id.substring(0, 8)}…'
        : ticket.id;
    final description = ticket.description.trim();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8ECE6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A1A153B),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              ticket.subject.isEmpty
                                  ? 'Untitled ticket'
                                  : ticket.subject,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                                color: AppColors.heading,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SupportStatusChip(status: ticket.status),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '#$shortId',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9B7BA8),
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            height: 1.35,
                            color: AppColors.bodyGrey,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            RemixIcons.flag_2_line,
                            size: 14,
                            color: Color(0xFF9A949E),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            ticket.priority.isEmpty ? '—' : ticket.priority,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.subtext,
                            ),
                          ),
                          if (updatedLabel.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            const Icon(
                              RemixIcons.time_line,
                              size: 14,
                              color: Color(0xFF9A949E),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                updatedLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF9A949E),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 2, left: 4),
                  child: Icon(
                    RemixIcons.arrow_right_s_line,
                    size: 22,
                    color: Color(0xFF9A949E),
                  ),
                ),
              ],
            ),
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
      mainAxisAlignment: MainAxisAlignment.center,
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
