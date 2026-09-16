import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kamao/src/social_connections/data/repositories/social_connections_repository.dart';
import 'package:kamao/src/social_connections/domain/entities/social_connection_status.dart';
import 'package:kamao/src/social_connections/domain/entities/social_platform_type.dart';

class ConnectedSocialAccount {
  const ConnectedSocialAccount({
    required this.platformId,
    required this.platformLabel,
    required this.displayName,
  });

  final String platformId;
  final String platformLabel;
  final String displayName;
}

class SocialAccountsSheetController extends GetxController {
  SocialAccountsSheetController(this._repository);

  final SocialConnectionsRepository _repository;

  final RxList<ConnectedSocialAccount> accounts =
      <ConnectedSocialAccount>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    debugPrint('SocialAccountsSheetController: onInit -> loading accounts');
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    isLoading.value = true;
    error.value = null;

    try {
      debugPrint('SocialAccountsSheetController: calling repository');
      final statuses = await _repository.fetchAllConnectionStatuses();
      debugPrint('SocialAccountsSheetController: got statuses -> $statuses');

      accounts.value = statuses.entries
          .where((e) => e.value.state == SocialConnectionState.connected)
          .map((e) {
            final platform = SocialPlatformType.tryParse(e.key);
            return ConnectedSocialAccount(
              platformId: platform?.apiId ?? e.key,
              platformLabel: platform?.displayName ?? e.key,
              displayName: e.value.connectedAccountLabel ?? '@${e.key}',
            );
          })
          .toList();
      debugPrint('SocialAccountsSheetController: accounts = ${accounts.value}');
    } catch (e, st) {
      debugPrint('SocialAccountsSheetController: ERROR $e\n$st');
      error.value = 'Could not load your social accounts.';
    } finally {
      isLoading.value = false;
    }
  }
}
