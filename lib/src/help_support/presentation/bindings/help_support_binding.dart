import 'package:get/get.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/help_support/data/datasources/help_support_remote_data_source.dart';
import 'package:kamao/src/help_support/data/repositories/help_support_repository_impl.dart';
import 'package:kamao/src/help_support/domain/repositories/help_support_repository.dart';
import 'package:kamao/src/help_support/domain/usecases/create_support_ticket_usecase.dart';
import 'package:kamao/src/help_support/domain/usecases/get_support_ticket_detail_usecase.dart';
import 'package:kamao/src/help_support/domain/usecases/get_support_tickets_usecase.dart';

void registerHelpSupportDependencies() {
  if (!Get.isRegistered<HelpSupportRemoteDataSource>()) {
    Get.lazyPut<HelpSupportRemoteDataSource>(
      () => HelpSupportRemoteDataSourceImpl(Get.find<ApiService>()),
      fenix: true,
    );
  }
  if (!Get.isRegistered<HelpSupportRepository>()) {
    Get.lazyPut<HelpSupportRepository>(
      () => HelpSupportRepositoryImpl(Get.find<HelpSupportRemoteDataSource>()),
      fenix: true,
    );
  }
  if (!Get.isRegistered<CreateSupportTicketUseCase>()) {
    Get.lazyPut(
      () => CreateSupportTicketUseCase(Get.find<HelpSupportRepository>()),
      fenix: true,
    );
  }
  if (!Get.isRegistered<GetSupportTicketsUseCase>()) {
    Get.lazyPut(
      () => GetSupportTicketsUseCase(Get.find<HelpSupportRepository>()),
      fenix: true,
    );
  }
  if (!Get.isRegistered<GetSupportTicketDetailUseCase>()) {
    Get.lazyPut(
      () => GetSupportTicketDetailUseCase(Get.find<HelpSupportRepository>()),
      fenix: true,
    );
  }
}

class HelpSupportBinding extends Bindings {
  @override
  void dependencies() {
    registerHelpSupportDependencies();
  }
}
