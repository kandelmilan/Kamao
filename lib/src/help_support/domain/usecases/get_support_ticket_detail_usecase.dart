import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_detail_entity.dart';
import 'package:kamao/src/help_support/domain/repositories/help_support_repository.dart';

class GetSupportTicketDetailUseCase
    extends UseCase<SupportTicketDetailEntity, String> {
  GetSupportTicketDetailUseCase(this._repository);

  final HelpSupportRepository _repository;

  @override
  Future<Either<Failure, SupportTicketDetailEntity>> call(String ticketId) {
    return _repository.getTicketDetail(ticketId);
  }
}
