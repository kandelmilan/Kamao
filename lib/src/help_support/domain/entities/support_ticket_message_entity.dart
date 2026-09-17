class SupportTicketMessageEntity {
  const SupportTicketMessageEntity({
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
}
