import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_detail_entity.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_entity.dart';

abstract class HelpSupportRepository {
  Future<Either<Failure, String>> createTicket({
    required String subject,
    required String description,
    required String priority,
  });

  Future<Either<Failure, List<SupportTicketEntity>>> getTickets();

  Future<Either<Failure, SupportTicketDetailEntity>> getTicketDetail(
    String ticketId,
  );
}
