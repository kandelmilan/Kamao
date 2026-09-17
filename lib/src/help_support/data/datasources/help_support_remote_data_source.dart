import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/help_support/data/models/request/create_support_ticket_request_model.dart';
import 'package:kamao/src/help_support/data/models/response/support_ticket_detail_model.dart';
import 'package:kamao/src/help_support/data/models/response/support_ticket_model.dart';

abstract class HelpSupportRemoteDataSource {
  Future<Either<Failure, ApiResponse<String>>> createTicket(
    CreateSupportTicketRequestModel request,
  );

  Future<Either<Failure, ApiResponse<List<SupportTicketModel>>>> getTickets();

  Future<Either<Failure, ApiResponse<SupportTicketDetailModel>>> getTicketDetail(
    String ticketId,
  );
}

class HelpSupportRemoteDataSourceImpl implements HelpSupportRemoteDataSource {
  const HelpSupportRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Either<Failure, ApiResponse<String>>> createTicket(
    CreateSupportTicketRequestModel request,
  ) {
    return ApiResponseHandler.handleResponse<String>(
      () => _apiService.post(
        ApiEndpoints.supportTickets,
        data: request.toJson(),
      ),
      (data) => data is String ? data : data?.toString() ?? '',
    );
  }

  @override
  Future<Either<Failure, ApiResponse<List<SupportTicketModel>>>> getTickets() {
    return ApiResponseHandler.handleResponse<List<SupportTicketModel>>(
      () => _apiService.get(ApiEndpoints.supportTickets),
      (data) => (data as List)
          .map(
            (item) =>
                SupportTicketModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<SupportTicketDetailModel>>>
      getTicketDetail(String ticketId) {
    return ApiResponseHandler.handleResponse<SupportTicketDetailModel>(
      () => _apiService.get(ApiEndpoints.supportTicketDetail(ticketId)),
      (data) => SupportTicketDetailModel.fromJson(
        data as Map<String, dynamic>,
      ),
    );
  }
}
