class CreateSupportTicketRequestModel {
  const CreateSupportTicketRequestModel({
    required this.subject,
    required this.description,
    required this.priority,
  });

  final String subject;
  final String description;
  final String priority;

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'description': description,
        'priority': priority,
      };
}
