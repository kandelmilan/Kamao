class SupportTicketEntity {
  const SupportTicketEntity({
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
}
