import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/help_support/domain/repositories/help_support_repository.dart';

class CreateSupportTicketParams {
  const CreateSupportTicketParams({
    required this.subject,
    required this.description,
    required this.priority,
  });

  final String subject;
  final String description;
  final String priority;
}

class CreateSupportTicketUseCase
    extends UseCase<String, CreateSupportTicketParams> {
  CreateSupportTicketUseCase(this._repository);

  final HelpSupportRepository _repository;

  @override
  Future<Either<Failure, String>> call(CreateSupportTicketParams params) {
    return _repository.createTicket(
      subject: params.subject,
      description: params.description,
      priority: params.priority,
    );
  }
}
