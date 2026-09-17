import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_message_entity.dart';
import 'package:kamao/src/help_support/presentation/controllers/ticket_detail_controller.dart';
import 'package:kamao/src/help_support/presentation/widgets/support_ui.dart';
import 'package:remixicon/remixicon.dart';

class TicketDetailView extends GetView<TicketDetailController> {
  const TicketDetailView({super.key});

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
                const _DetailHeader(),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.detail.value == null) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.onboardingGreen,
                        ),
                      );
                    }

                    final err = controller.error.value;
                    if (err != null && controller.detail.value == null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                err,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  color: AppColors.bodyGrey,
                                ),
                              ),
                              TextButton(
                                onPressed: controller.loadDetail,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final detail = controller.detail.value;
                    if (detail == null) return const SizedBox.shrink();

                    final ticket = detail.ticket;
                    final messages = detail.messages;

                    return RefreshIndicator(
                      color: AppColors.onboardingGreen,
                      onRefresh: controller.loadDetail,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                        children: [
                          _TicketSummaryCard(
                            subject: ticket.subject,
                            id: ticket.id,
                            status: ticket.status,
                            priority: ticket.priority,
                            description: ticket.description,
                            updatedAt: ticket.updatedAt ?? ticket.createdAt,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Conversation',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.cardTitle,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (messages.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFF2F5F9),
                                ),
                              ),
                              child: const Text(
                                'No messages yet.',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: AppColors.bodyGrey,
                                ),
                              ),
                            )
                          else
                            ...messages.map(
                              (m) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _MessageBubble(message: m),
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

class _DetailHeader extends StatelessWidget {
  const _DetailHeader();

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
              'Ticket',
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

class _TicketSummaryCard extends StatelessWidget {
  const _TicketSummaryCard({
    required this.subject,
    required this.id,
    required this.status,
    required this.priority,
    required this.description,
    required this.updatedAt,
  });

  final String subject;
  final String id;
  final String status;
  final String priority;
  final String description;
  final DateTime? updatedAt;

  @override
  Widget build(BuildContext context) {
    final updatedLabel = updatedAt == null
        ? ''
        : DateFormat('M/d/yyyy h:mm:ss a').format(updatedAt!.toLocal());
    final shortId = id.length > 8 ? '${id.substring(0, 8)}…' : id;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF2F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1A153B),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
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
                      subject,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
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
              SupportStatusChip(status: status),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _MetaPill(label: 'Priority', value: priority),
              const SizedBox(width: 8),
              if (updatedLabel.isNotEmpty)
                Expanded(
                  child: _MetaPill(label: 'Updated', value: updatedLabel),
                ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text(
              'DESCRIPTION',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: Color(0xFF9A949E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                height: 1.4,
                color: AppColors.subtext,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: Color(0xFF9A949E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.isEmpty ? '—' : value,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.subtext,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final SupportTicketMessageEntity message;

  @override
  Widget build(BuildContext context) {
    final isStaff = message.isStaff;
    final time = message.createdAt == null
        ? ''
        : DateFormat('MMM d, h:mm a').format(message.createdAt!.toLocal());

    return Align(
      alignment: isStaff ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: isStaff ? Colors.white : const Color(0xFFE8F0E5),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isStaff ? 4 : 16),
              bottomRight: Radius.circular(isStaff ? 16 : 4),
            ),
            border: Border.all(
              color: isStaff
                  ? const Color(0xFFF2F5F9)
                  : const Color(0xFFD7E4D2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      message.authorName.isEmpty
                          ? (isStaff ? 'Staff' : 'You')
                          : message.authorName,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isStaff
                            ? AppColors.onboardingGreen
                            : const Color(0xFF4C5749),
                      ),
                    ),
                  ),
                  if (isStaff)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0E5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Staff',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF426340),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                message.body,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.heading,
                ),
              ),
              if (time.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11,
                    color: Color(0xFF9A949E),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
