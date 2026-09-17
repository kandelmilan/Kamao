import 'package:kamao/src/help_support/domain/entities/support_ticket_entity.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_message_entity.dart';

class SupportTicketDetailEntity {
  const SupportTicketDetailEntity({
    required this.ticket,
    required this.messages,
  });

  final SupportTicketEntity ticket;
  final List<SupportTicketMessageEntity> messages;
}
