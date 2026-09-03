// import 'package:kamao/core/core.dart';
// import '../../domain/entities/social_connection_status.dart';

// /// Talks to the social OAuth endpoints directly through ApiService —
// /// kept as a single repository (no separate remote-data-source /
// /// Either / UseCase split) since the connectSocialAccounts() stub
// /// this replaces was a simple async method too, not a full use-case
// /// flow. Say the word if you'd rather this match the
// /// data-source -> repository -> use-case pattern used for
// /// wallet/brands, and I'll split it out the same way.
// class SocialConnectionsRepository {
//   SocialConnectionsRepository(this._apiService);
//   final ApiService _apiService;

//   static const appRedirect =
//       'https://aayurise.gyanbato.com/Api/v1/creator/social/Instagram/callback';

//   /// POST /v{version}/creator/social/{platform}/start
//   Future<String> startConnect(String platformId) async {
//     final response = await _apiService.post(
//       '/creator/social/$platformId/start',
//       data: {'appRedirect': appRedirect},
//     );
//     final authUrl = response.data['authUrl'] as String?;
//     if (authUrl == null || authUrl.isEmpty) {
//       throw Exception('No authUrl returned for $platformId');
//     }
//     return authUrl;
//   }

//   /// POST /v{version}/creator/social/{platform}/callback
//   Future<SocialConnectionStatus> completeConnect({
//     required String platformId,
//     required String code,
//     String? state,
//   }) async {
//     final response = await _apiService.post(
//       '/creator/social/$platformId/callback',
//       data: {
//         'platform': platformId,
//         'code': code,
//         if (state != null) 'state': state,
//       },
//     );
//     final data = response.data as Map<String, dynamic>;
//     return SocialConnectionStatus(
//       state: SocialConnectionState.connected,
//       connectedAccountLabel: data['accountLabel'] as String?,
//     );
//   }
// }
import 'package:kamao/core/core.dart';
import '../../domain/entities/social_connection_status.dart';

class SocialConnectionsRepository {
  SocialConnectionsRepository(this._apiService);
  final ApiService _apiService;

  static const appRedirect = 'kamao://social-connect-result';

  /// POST /v{version}/creator/social/{platform}/start
  // Future<String> startConnect(String platformId) async {
  //   final response = await _apiService.post(
  //     '/creator/social/$platformId/start',
  //     data: {'appRedirect': appRedirect},
  //   );
  //   final authUrl = response.data['data']['authorizeUrl'] as String?;
  //   if (authUrl == null || authUrl.isEmpty) {
  //     throw Exception('No authorizeUrl returned for $platformId');
  //   }
  //   return authUrl;
  // }
  Future<String> startConnect(String platformId) async {
    final response = await _apiService.post(
      '/creator/social/$platformId/start',
      data: {'appRedirect': appRedirect},
    );
    final authUrl = response.data['data']['authorizeUrl'] as String?;
    if (authUrl == null || authUrl.isEmpty) {
      throw Exception('No authorizeUrl returned for $platformId');
    }
    return authUrl;
  }

  /// GET /v{version}/creator/social/{platform}/callback
  /// Called by the app (not the vendor) after the deep link wakes us
  /// back up, to fetch the connection the vendor's own GET hit to
  /// this same URL already stored server-side.
  Future<SocialConnectionStatus> fetchConnectionStatus(
    String platformId,
  ) async {
    final response = await _apiService.get(
      '/creator/social/$platformId/callback',
    );
    final data = response.data['data'] as Map<String, dynamic>?;

    if (data == null || data['connected'] != true) {
      return SocialConnectionStatus.initial;
    }

    return SocialConnectionStatus(
      state: SocialConnectionState.connected,
      connectedAccountLabel: data['accountLabel'] as String?,
    );
  }

  /// GET /v{version}/creator/social/connections (adjust path/shape once confirmed)
  Future<Map<String, SocialConnectionStatus>>
  fetchAllConnectionStatuses() async {
    final response = await _apiService.get('/creator/social/connections');
    final list = response.data['data'] as List<dynamic>? ?? [];

    final result = <String, SocialConnectionStatus>{};
    for (final item in list) {
      final platformId = (item['platform'] as String).toLowerCase();
      final connected = item['connected'] == true;
      result[platformId] = connected
          ? SocialConnectionStatus(
              state: SocialConnectionState.connected,
              connectedAccountLabel: item['accountLabel'] as String?,
            )
          : SocialConnectionStatus.initial;
    }
    return result;
  }
}
