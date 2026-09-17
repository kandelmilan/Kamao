import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/help_support/data/datasources/help_support_remote_data_source.dart';
import 'package:kamao/src/help_support/data/models/request/create_support_ticket_request_model.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_detail_entity.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_entity.dart';
import 'package:kamao/src/help_support/domain/repositories/help_support_repository.dart';

class HelpSupportRepositoryImpl implements HelpSupportRepository {
  const HelpSupportRepositoryImpl(this._remoteDataSource);

  final HelpSupportRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, String>> createTicket({
    required String subject,
    required String description,
    required String priority,
  }) async {
    final result = await _remoteDataSource.createTicket(
      CreateSupportTicketRequestModel(
        subject: subject,
        description: description,
        priority: priority,
      ),
    );

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data ?? ''),
    );
  }

  @override
  Future<Either<Failure, List<SupportTicketEntity>>> getTickets() async {
    final result = await _remoteDataSource.getTickets();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(
        (response.data ?? []).map((model) => model.toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, SupportTicketDetailEntity>> getTicketDetail(
    String ticketId,
  ) async {
    final result = await _remoteDataSource.getTicketDetail(ticketId);

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!.toEntity()),
    );
  }
}
