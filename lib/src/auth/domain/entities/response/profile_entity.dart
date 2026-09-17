class ProfileUserEntity {
  const ProfileUserEntity({
    required this.userId,
    required this.tenantId,
    required this.email,
    required this.userName,
    required this.fullName,
    required this.roleId,
    required this.permissions,
    this.avatarUrl,
  });

  final String userId;
  final String tenantId;
  final String email;
  final String userName;
  final String fullName;
  final String roleId;
  final List<String> permissions;

  /// Relative or absolute avatar path from the API (nullable when unset).
  final String? avatarUrl;

  ProfileUserEntity copyWith({
    String? userId,
    String? tenantId,
    String? email,
    String? userName,
    String? fullName,
    String? roleId,
    List<String>? permissions,
    String? avatarUrl,
    bool clearAvatarUrl = false,
  }) {
    return ProfileUserEntity(
      userId: userId ?? this.userId,
      tenantId: tenantId ?? this.tenantId,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      roleId: roleId ?? this.roleId,
      permissions: permissions ?? this.permissions,
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
    );
  }
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

/// Badge awarded on the creator's current progress snapshot
/// (`data.progress.progress.badges`) or listed in the catalog
/// (`data.progress.badges`). Optional catalog fields are null when
/// the badge comes from the awarded list.
class ProfileBadgeEntity {
  const ProfileBadgeEntity({
    required this.code,
    required this.name,
    required this.description,
    required this.howToEarn,
    required this.kind,
    required this.icon,
    this.source,
    this.awardedAt,
    this.note,
    this.ruleType,
    this.thresholdInt,
    this.thresholdMoney,
    this.platform,
    this.windowDays,
    this.earned,
  });

  final String code;
  final String name;
  final String description;
  final String howToEarn;
  final String kind;
  final String icon;
  final String? source;
  final DateTime? awardedAt;
  final String? note;
  final String? ruleType;
  final int? thresholdInt;
  final double? thresholdMoney;
  final String? platform;
  final int? windowDays;
  final bool? earned;
}

class ProfileLevelEntity {
  const ProfileLevelEntity({
    required this.code,
    required this.name,
    required this.rank,
    required this.blurb,
    required this.minRewardedPosts,
    required this.minTotalRewarded,
    required this.requireBoth,
    required this.benefits,
    required this.unlocked,
    required this.isCurrent,
  });

  final String code;
  final String name;
  final int rank;
  final String blurb;
  final int minRewardedPosts;
  final double minTotalRewarded;
  final bool requireBoth;
  final List<String> benefits;
  final bool unlocked;
  final bool isCurrent;
}

/// Inner `data.progress.progress` object — current level + stats.
class ProfileProgressStatsEntity {
  const ProfileProgressStatsEntity({
    required this.computedLevelCode,
    required this.computedLevelName,
    required this.computedLevelRank,
    required this.effectiveLevelCode,
    required this.effectiveLevelName,
    required this.effectiveLevelRank,
    required this.benefits,
    required this.rewardedPosts,
    required this.totalRewarded,
    required this.distinctBrands,
    required this.joinedCampaigns,
    required this.submittedPosts,
    required this.approvedPosts,
    required this.rejectedPosts,
    required this.paidWithdrawals,
    required this.connectedAccounts,
    required this.hasManualFloor,
    required this.badges,
    this.lastComputedAt,
    this.nextLevelCode,
    this.nextLevelName,
    this.nextLevelRank,
    this.nextLevelBlurb,
    this.nextMinRewardedPosts,
    this.nextMinTotalRewarded,
    this.postsToNext,
    this.nprToNext,
    this.floorLevelCode,
    this.floorLevelName,
    this.floorExpiresAt,
    this.floorReason,
  });

  final String computedLevelCode;
  final String computedLevelName;
  final int computedLevelRank;
  final String effectiveLevelCode;
  final String effectiveLevelName;
  final int effectiveLevelRank;
  final List<String> benefits;
  final int rewardedPosts;
  final double totalRewarded;
  final int distinctBrands;
  final int joinedCampaigns;
  final int submittedPosts;
  final int approvedPosts;
  final int rejectedPosts;
  final int paidWithdrawals;
  final int connectedAccounts;
  final DateTime? lastComputedAt;
  final String? nextLevelCode;
  final String? nextLevelName;
  final int? nextLevelRank;
  final String? nextLevelBlurb;
  final int? nextMinRewardedPosts;
  final double? nextMinTotalRewarded;
  final int? postsToNext;
  final double? nprToNext;
  final bool hasManualFloor;
  final String? floorLevelCode;
  final String? floorLevelName;
  final DateTime? floorExpiresAt;
  final String? floorReason;
  final List<ProfileBadgeEntity> badges;

  /// Display name for the creator's current level chip.
  String get levelName =>
      effectiveLevelName.isNotEmpty ? effectiveLevelName : computedLevelName;

  /// Stable level code for badge styling, e.g. "seed", "rising".
  String get levelCode =>
      effectiveLevelCode.isNotEmpty ? effectiveLevelCode : computedLevelCode;
}

/// Top-level `data.progress` — current stats, level ladder, badge catalog.
class ProfileProgressEntity {
  const ProfileProgressEntity({
    required this.current,
    required this.levels,
    required this.badges,
  });

  final ProfileProgressStatsEntity current;
  final List<ProfileLevelEntity> levels;
  final List<ProfileBadgeEntity> badges;
}

/// Wraps the full `/creator/profile` payload.
class ProfileEntity {
  const ProfileEntity({
    required this.user,
    required this.insights,
    required this.connections,
    this.progress,
    this.needsSocialConnect = false,
  });

  final ProfileUserEntity user;
  final ProfileInsightsEntity insights;
  final List<ProfileConnectionEntity> connections;
  final ProfileProgressEntity? progress;

  /// From `data.needsSocialConnect` — true when the creator should
  /// connect Instagram / Facebook / TikTok before posting.
  final bool needsSocialConnect;

  /// Effective (or computed) level display name, e.g. "Elite".
  String get levelName => progress?.current.levelName ?? '';

  /// Effective (or computed) level code, e.g. "elite".
  String get levelCode => progress?.current.levelCode ?? '';

  /// Case-insensitive lookup, e.g. connectionFor('facebook').
  ProfileConnectionEntity? connectionFor(String platform) {
    for (final c in connections) {
      if (c.platform.toLowerCase() == platform.toLowerCase()) return c;
    }
    return null;
  }

  ProfileEntity copyWith({
    ProfileUserEntity? user,
    ProfileInsightsEntity? insights,
    List<ProfileConnectionEntity>? connections,
    ProfileProgressEntity? progress,
    bool? needsSocialConnect,
  }) {
    return ProfileEntity(
      user: user ?? this.user,
      insights: insights ?? this.insights,
      connections: connections ?? this.connections,
      progress: progress ?? this.progress,
      needsSocialConnect: needsSocialConnect ?? this.needsSocialConnect,
    );
  }
}
