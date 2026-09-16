import 'package:flutter/foundation.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/social_connections/domain/entities/social_connection_status.dart';
import 'package:kamao/src/social_connections/domain/entities/social_platform_type.dart';

/// Social OAuth via ApiService.
///
/// Flow for every [SocialPlatformType] (instagram / facebook / tiktok):
/// 1. [startConnect] → POST …/start `{ appRedirect }` → `authorizeUrl`
/// 2. Open `authorizeUrl` in the browser (app never calls vendor callback)
/// 3. Backend finishes OAuth, 302 → `kamao://social-connect-result?…`
/// 4. App reloads with [fetchAllConnectionStatuses]
class SocialConnectionsRepository {
  SocialConnectionsRepository(this._apiService);
  final ApiService _apiService;

  static const appRedirect = 'kamao://social-connect-result';

  /// POST /creator/social/{platform}/start
  Future<String> startConnect(String platformId) async {
    final platform = SocialPlatformType.tryParse(platformId);
    final pathPlatform = platform?.apiId ?? platformId.toLowerCase();

    final response = await _apiService.post(
      ApiEndpoints.socialStart(pathPlatform),
      data: {'appRedirect': appRedirect},
    );
    final authUrl = response.data['data']['authorizeUrl'] as String?;
    debugPrint('[SocialConnections] authorizeUrl ($pathPlatform): $authUrl');
    if (authUrl == null || authUrl.isEmpty) {
      throw Exception('No authorizeUrl returned for $pathPlatform');
    }
    return authUrl;
  }

  /// GET /creator/social/connections
  ///
  /// `{ success, data: [{ platform, externalAccountId, displayName,
  ///    expiresAt, isConnected }], … }`
  Future<Map<String, SocialConnectionStatus>>
  fetchAllConnectionStatuses() async {
    final response = await _apiService.get(ApiEndpoints.socialConnections);
    final list = response.data['data'] as List<dynamic>? ?? [];

    final result = <String, SocialConnectionStatus>{};
    for (final item in list) {
      final platformId = (item['platform'] as String? ?? '').toLowerCase();
      if (platformId.isEmpty) continue;
      final isConnected = item['isConnected'] == true;
      result[platformId] = isConnected
          ? SocialConnectionStatus(
              state: SocialConnectionState.connected,
              connectedAccountLabel: item['displayName'] as String?,
            )
          : SocialConnectionStatus.initial;
    }
    return result;
  }
}
