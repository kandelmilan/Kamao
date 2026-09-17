import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/help_support/domain/entities/support_ticket_entity.dart';
import 'package:kamao/src/help_support/domain/usecases/get_support_tickets_usecase.dart';
import 'package:kamao/src/help_support/presentation/utils/support_ticket_status_filter.dart';

class ViewTicketsController extends GetxController {
  ViewTicketsController(this._getSupportTicketsUseCase);

  final GetSupportTicketsUseCase _getSupportTicketsUseCase;

  final RxList<SupportTicketEntity> tickets = <SupportTicketEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final RxString statusFilter = SupportTicketStatusFilter.all.obs;

  List<SupportTicketEntity> get filteredTickets {
    final filter = statusFilter.value;
    if (filter == SupportTicketStatusFilter.all) return tickets.toList();
    return tickets
        .where((t) => t.status.toLowerCase() == filter.toLowerCase())
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadTickets();
  }

  void setStatusFilter(String status) {
    statusFilter.value = status;
  }

  void openTicket(SupportTicketEntity ticket) {
    Get.toNamed(
      AppRoutes.ticketDetail,
      parameters: {'id': ticket.id},
      arguments: ticket.id,
    );
  }

  Future<void> openRaiseTicket() async {
    await Get.toNamed(AppRoutes.raiseTicket);
    await loadTickets();
  }

  Future<void> loadTickets() async {
    isLoading.value = true;
    error.value = null;

    final result = await _getSupportTicketsUseCase(const NoParams());

    result.fold(
      (failure) => error.value = failure.message,
      (data) => tickets.assignAll(data),
    );

    isLoading.value = false;
  }
}
