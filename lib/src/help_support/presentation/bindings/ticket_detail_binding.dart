import 'package:get/get.dart';
import 'package:kamao/src/help_support/domain/usecases/get_support_ticket_detail_usecase.dart';
import 'package:kamao/src/help_support/presentation/bindings/help_support_binding.dart';
import 'package:kamao/src/help_support/presentation/controllers/ticket_detail_controller.dart';

class TicketDetailBinding extends Bindings {
  @override
  void dependencies() {
    registerHelpSupportDependencies();

    final rawId = Get.parameters['id'] ?? Get.arguments;
    if (rawId is! String || rawId.isEmpty) {
      throw ArgumentError(
        'TicketDetailBinding: no ticket id. '
        'parameters=${Get.parameters}, arguments=${Get.arguments}',
      );
    }

    Get.put(
      TicketDetailController(
        getSupportTicketDetailUseCase: Get.find<GetSupportTicketDetailUseCase>(),
        ticketId: rawId,
      ),
    );
  }
}
