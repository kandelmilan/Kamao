// import 'package:kamao/core/core.dart';
// import '../../domain/entities/social_connection_status.dart';

// /// Talks to the social OAuth endpoints through ApiService.
// ///
// /// Flow: startConnect() gets an authorizeUrl and opens it in the
// /// browser. The vendor redirects to the backend's own GET
// /// .../callback (never seen by the app). The backend then
// /// 302-redirects to kamao://social-connect-result?ok=1&platform=...,
// /// which wakes the app — at that point we call
// /// fetchAllConnectionStatuses() to get the real, current state.
// class SocialConnectionsRepository {
//   SocialConnectionsRepository(this._apiService);
//   final ApiService _apiService;

//   static const appRedirect = 'kamao://social-connect-result';

//   /// POST /v{version}/creator/social/{platform}/start
//   Future<String> startConnect(String platformId) async {
//     final response = await _apiService.post(
//       '/creator/social/$platformId/start',
//       data: {'appRedirect': appRedirect},
//     );
//     final authUrl = response.data['data']['authorizeUrl'] as String?;
//     if (authUrl == null || authUrl.isEmpty) {
//       throw Exception('No authorizeUrl returned for $platformId');
//     }
//     return authUrl;
//   }

//   /// GET /v{version}/creator/social/connections
//   /// Confirmed response shape:
//   /// { success, data: [{ platform, externalAccountId, displayName,
//   ///                      expiresAt, isConnected }], message,
//   ///   correlationId }
//   Future<Map<String, SocialConnectionStatus>>
//   fetchAllConnectionStatuses() async {
//     final response = await _apiService.get('/creator/social/connections');
//     final list = response.data['data'] as List<dynamic>? ?? [];

//     final result = <String, SocialConnectionStatus>{};
//     for (final item in list) {
//       final platformId = (item['platform'] as String).toLowerCase();
//       final isConnected = item['isConnected'] == true;
//       result[platformId] = isConnected
//           ? SocialConnectionStatus(
//               state: SocialConnectionState.connected,
//               connectedAccountLabel: item['displayName'] as String?,
//             )
//           : SocialConnectionStatus.initial;
//     }
//     return result;
//   }
// }
import 'package:flutter/material.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/social_connections/domain/entities/social_connection_status.dart';

/// Talks to the social OAuth endpoints through ApiService.
///
/// Flow: startConnect() gets an authorizeUrl and opens it in the
/// browser. The vendor (Instagram, TikTok, Facebook, YouTube — same
/// flow for all of them, keyed only by platformId) redirects to the
/// backend's own GET .../callback (never seen by the app). The
/// backend then 302-redirects to
/// kamao://social-connect-result?ok=1&platform=..., which wakes the
/// app — at that point we call fetchAllConnectionStatuses() to get
/// the real, current state.
class SocialConnectionsRepository {
  SocialConnectionsRepository(this._apiService);
  final ApiService _apiService;

  static const appRedirect = 'kamao://social-connect-result';
  // static const appRedirect =
  //     'https://aayurise.gyanbato.com/api/v1/creator/social/Tiktok/callback';

  /// POST /v{version}/creator/social/{platform}/start
  Future<String> startConnect(String platformId) async {
    final response = await _apiService.post(
      '/creator/social/$platformId/start',
      data: {'appRedirect': appRedirect},
    );
    final authUrl = response.data['data']['authorizeUrl'] as String?;
    debugPrint('authUrl: $authUrl');
    if (authUrl == null || authUrl.isEmpty) {
      throw Exception('No authorizeUrl returned for $platformId');
    }
    return authUrl;
  }

  /// GET /v{version}/creator/social/connections
  /// Confirmed response shape:
  /// { success, data: [{ platform, externalAccountId, displayName,
  ///                      expiresAt, isConnected }], message,
  ///   correlationId }
  Future<Map<String, SocialConnectionStatus>>
  fetchAllConnectionStatuses() async {
    final response = await _apiService.get('/creator/social/connections');
    final list = response.data['data'] as List<dynamic>? ?? [];

    final result = <String, SocialConnectionStatus>{};
    for (final item in list) {
      final platformId = (item['platform'] as String).toLowerCase();
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
