import 'package:get/get.dart';
import 'package:kamao/src/help_support/domain/usecases/get_support_tickets_usecase.dart';
import 'package:kamao/src/help_support/presentation/bindings/help_support_binding.dart';
import 'package:kamao/src/help_support/presentation/controllers/view_tickets_controller.dart';

class ViewTicketsBinding extends Bindings {
  @override
  void dependencies() {
    registerHelpSupportDependencies();
    Get.lazyPut(
      () => ViewTicketsController(Get.find<GetSupportTicketsUseCase>()),
    );
  }
}
