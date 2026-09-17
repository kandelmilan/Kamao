import 'package:get/get.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_detail_entity.dart';
import 'package:kamao/src/help_support/domain/usecases/get_support_ticket_detail_usecase.dart';

class TicketDetailController extends GetxController {
  TicketDetailController({
    required GetSupportTicketDetailUseCase getSupportTicketDetailUseCase,
    required this.ticketId,
  }) : _getSupportTicketDetailUseCase = getSupportTicketDetailUseCase;

  final GetSupportTicketDetailUseCase _getSupportTicketDetailUseCase;
  final String ticketId;

  final Rxn<SupportTicketDetailEntity> detail = Rxn<SupportTicketDetailEntity>();
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  Future<void> loadDetail() async {
    isLoading.value = true;
    error.value = null;

    final result = await _getSupportTicketDetailUseCase(ticketId);

    result.fold(
      (failure) => error.value = failure.message,
      (data) => detail.value = data,
    );

    isLoading.value = false;
  }
}
