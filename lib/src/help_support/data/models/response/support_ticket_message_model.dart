import 'package:kamao/src/help_support/domain/entities/support_ticket_message_entity.dart';

class SupportTicketMessageModel {
  const SupportTicketMessageModel({
    required this.id,
    required this.body,
    required this.authorName,
    required this.isStaff,
    required this.createdAt,
  });

  final String id;
  final String body;
  final String authorName;
  final bool isStaff;
  final DateTime? createdAt;

  factory SupportTicketMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketMessageModel(
      id: json['id']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      authorName: json['authorName']?.toString() ?? '',
      isStaff: json['isStaff'] == true,
      createdAt: _parseDate(json['createdAt']),
    );
  }

  SupportTicketMessageEntity toEntity() => SupportTicketMessageEntity(
        id: id,
        body: body,
        authorName: authorName,
        isStaff: isStaff,
        createdAt: createdAt,
      );

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
