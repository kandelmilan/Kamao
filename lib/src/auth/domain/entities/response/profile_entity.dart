class ProfileUserEntity {
  const ProfileUserEntity({
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
}

class ProfileInsightsEntity {
  const ProfileInsightsEntity({
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
}

class ProfileConnectionEntity {
  const ProfileConnectionEntity({
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
}

/// Wraps the full `/creator/profile` payload.
class ProfileEntity {
  const ProfileEntity({
    required this.user,
    required this.insights,
    required this.connections,
    this.needsSocialConnect = false,
  });

  final ProfileUserEntity user;
  final ProfileInsightsEntity insights;
  final List<ProfileConnectionEntity> connections;

  /// From `data.needsSocialConnect` — true when the creator should
  /// connect Instagram / Facebook / TikTok before posting.
  final bool needsSocialConnect;

  /// Case-insensitive lookup, e.g. connectionFor('facebook').
  ProfileConnectionEntity? connectionFor(String platform) {
    for (final c in connections) {
      if (c.platform.toLowerCase() == platform.toLowerCase()) return c;
    }
    return null;
  }
}
