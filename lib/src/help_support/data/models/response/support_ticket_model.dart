import 'package:kamao/src/help_support/domain/entities/support_ticket_entity.dart';

class SupportTicketModel {
  const SupportTicketModel({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
    required this.requesterName,
    required this.requesterEmail,
    required this.messageCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String subject;
  final String description;
  final String status;
  final String priority;
  final String requesterName;
  final String requesterEmail;
  final int messageCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      requesterName: json['requesterName']?.toString() ?? '',
      requesterEmail: json['requesterEmail']?.toString() ?? '',
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  SupportTicketEntity toEntity() => SupportTicketEntity(
        id: id,
        subject: subject,
        description: description,
        status: status,
        priority: priority,
        requesterName: requesterName,
        requesterEmail: requesterEmail,
        messageCount: messageCount,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
