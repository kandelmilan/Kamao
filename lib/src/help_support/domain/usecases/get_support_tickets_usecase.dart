import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_entity.dart';
import 'package:kamao/src/help_support/domain/repositories/help_support_repository.dart';

class GetSupportTicketsUseCase
    extends UseCase<List<SupportTicketEntity>, NoParams> {
  GetSupportTicketsUseCase(this._repository);

  final HelpSupportRepository _repository;

  @override
  Future<Either<Failure, List<SupportTicketEntity>>> call(NoParams params) {
    return _repository.getTickets();
  }
}
