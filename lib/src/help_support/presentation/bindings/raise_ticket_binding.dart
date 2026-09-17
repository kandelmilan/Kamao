import 'package:get/get.dart';
import 'package:kamao/src/help_support/domain/usecases/create_support_ticket_usecase.dart';
import 'package:kamao/src/help_support/presentation/bindings/help_support_binding.dart';
import 'package:kamao/src/help_support/presentation/controllers/raise_ticket_controller.dart';

class RaiseTicketBinding extends Bindings {
  @override
  void dependencies() {
    registerHelpSupportDependencies();
    Get.lazyPut(
      () => RaiseTicketController(Get.find<CreateSupportTicketUseCase>()),
    );
  }
}
