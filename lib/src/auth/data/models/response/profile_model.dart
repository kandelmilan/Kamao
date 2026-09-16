import 'package:kamao/src/auth/domain/entities/response/profile_entity.dart';

class ProfileUserModel {
  const ProfileUserModel({
    required this.userId,
    required this.tenantId,
    required this.email,
    required this.userName,
    required this.fullName,
    required this.roleId,
    required this.permissions,
  });

  final String userId;
  final String tenantId;
  final String email;
  final String userName;
  final String fullName;
  final String roleId;
  final List<String> permissions;

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      userId: json['userId'] as String? ?? '',
      tenantId: json['tenantId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      roleId: json['roleId'] as String? ?? '',
      permissions: (json['permissions'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
    );
  }

  ProfileUserEntity toEntity() {
    return ProfileUserEntity(
      userId: userId,
      tenantId: tenantId,
      email: email,
      userName: userName,
      fullName: fullName,
      roleId: roleId,
      permissions: permissions,
    );
  }
}

class ProfileInsightsModel {
  const ProfileInsightsModel({
    required this.totalRewarded,
    required this.averagePostReward,
    required this.totalWithdrawn,
    required this.rewardedPostCount,
    required this.postsTotal,
    required this.postsRewarded,
    required this.postsInFlight,
    required this.walletBalance,
    required this.currency,
  });

  final double totalRewarded;
  final double averagePostReward;
  final double totalWithdrawn;
  final int rewardedPostCount;
  final int postsTotal;
  final int postsRewarded;
  final int postsInFlight;
  final double walletBalance;
  final String currency;

  static double _asDouble(dynamic v) => v == null ? 0.0 : (v as num).toDouble();
  static int _asInt(dynamic v) => v == null ? 0 : (v as num).toInt();

  factory ProfileInsightsModel.fromJson(Map<String, dynamic> json) {
    return ProfileInsightsModel(
      totalRewarded: _asDouble(json['totalRewarded']),
      averagePostReward: _asDouble(json['averagePostReward']),
      totalWithdrawn: _asDouble(json['totalWithdrawn']),
      rewardedPostCount: _asInt(json['rewardedPostCount']),
      postsTotal: _asInt(json['postsTotal']),
      postsRewarded: _asInt(json['postsRewarded']),
      postsInFlight: _asInt(json['postsInFlight']),
      walletBalance: _asDouble(json['walletBalance']),
      currency: json['currency'] as String? ?? 'NPR',
    );
  }

  ProfileInsightsEntity toEntity() {
    return ProfileInsightsEntity(
      totalRewarded: totalRewarded,
      averagePostReward: averagePostReward,
      totalWithdrawn: totalWithdrawn,
      rewardedPostCount: rewardedPostCount,
      postsTotal: postsTotal,
      postsRewarded: postsRewarded,
      postsInFlight: postsInFlight,
      walletBalance: walletBalance,
      currency: currency,
    );
  }
}

class ProfileConnectionModel {
  const ProfileConnectionModel({
    required this.platform,
    required this.externalAccountId,
    required this.displayName,
    required this.isConnected,
    this.expiresAt,
  });

  final String platform;
  final String externalAccountId;
  final String displayName;
  final bool isConnected;
  final DateTime? expiresAt;

  factory ProfileConnectionModel.fromJson(Map<String, dynamic> json) {
    final rawExpiresAt = json['expiresAt'] as String?;
    return ProfileConnectionModel(
      platform: json['platform'] as String? ?? '',
      externalAccountId: json['externalAccountId'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      isConnected: json['isConnected'] as bool? ?? false,
      expiresAt: rawExpiresAt == null ? null : DateTime.tryParse(rawExpiresAt),
    );
  }

  ProfileConnectionEntity toEntity() {
    return ProfileConnectionEntity(
      platform: platform,
      externalAccountId: externalAccountId,
      displayName: displayName,
      isConnected: isConnected,
      expiresAt: expiresAt,
    );
  }
}

/// Wraps the `data` object of the `/creator/profile` response.
class ProfileModel {
  const ProfileModel({
    required this.user,
    required this.insights,
    required this.connections,
    this.needsSocialConnect = false,
  });

  final ProfileUserModel user;
  final ProfileInsightsModel insights;
  final List<ProfileConnectionModel> connections;
  final bool needsSocialConnect;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      user: ProfileUserModel.fromJson(
        json['user'] as Map<String, dynamic>? ?? const {},
      ),
      insights: ProfileInsightsModel.fromJson(
        json['insights'] as Map<String, dynamic>? ?? const {},
      ),
      connections: (json['connections'] as List<dynamic>? ?? const [])
          .map(
            (e) => ProfileConnectionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      needsSocialConnect: json['needsSocialConnect'] as bool? ?? false,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      user: user.toEntity(),
      insights: insights.toEntity(),
      connections: connections.map((c) => c.toEntity()).toList(),
      needsSocialConnect: needsSocialConnect,
    );
  }
}
