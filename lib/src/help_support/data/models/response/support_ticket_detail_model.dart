import 'package:kamao/src/help_support/data/models/response/support_ticket_message_model.dart';
import 'package:kamao/src/help_support/data/models/response/support_ticket_model.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_detail_entity.dart';

class SupportTicketDetailModel {
  const SupportTicketDetailModel({
    required this.ticket,
    required this.messages,
  });

  final SupportTicketModel ticket;
  final List<SupportTicketMessageModel> messages;

  factory SupportTicketDetailModel.fromJson(Map<String, dynamic> json) {
    final ticketJson = json['ticket'];
    final messagesJson = json['messages'];

    return SupportTicketDetailModel(
      ticket: SupportTicketModel.fromJson(
        ticketJson is Map<String, dynamic>
            ? ticketJson
            : <String, dynamic>{},
      ),
      messages: messagesJson is List
          ? messagesJson
              .whereType<Map>()
              .map(
                (item) => SupportTicketMessageModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
    );
  }

  SupportTicketDetailEntity toEntity() => SupportTicketDetailEntity(
        ticket: ticket.toEntity(),
        messages: messages.map((m) => m.toEntity()).toList(),
      );
}
