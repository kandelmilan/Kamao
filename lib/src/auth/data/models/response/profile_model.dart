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
    this.avatarUrl,
  });

  final String userId;
  final String tenantId;
  final String email;
  final String userName;
  final String fullName;
  final String roleId;
  final List<String> permissions;
  final String? avatarUrl;

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
      avatarUrl: json['avatarUrl'] as String?,
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
      avatarUrl: avatarUrl,
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

class ProfileBadgeModel {
  const ProfileBadgeModel({
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

  static double? _asDoubleOrNull(dynamic v) =>
      v == null ? null : (v as num).toDouble();
  static int? _asIntOrNull(dynamic v) => v == null ? null : (v as num).toInt();

  factory ProfileBadgeModel.fromJson(Map<String, dynamic> json) {
    final rawAwardedAt = json['awardedAt'] as String?;
    return ProfileBadgeModel(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      howToEarn: json['howToEarn'] as String? ?? '',
      kind: json['kind'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      source: json['source'] as String?,
      awardedAt:
          rawAwardedAt == null ? null : DateTime.tryParse(rawAwardedAt),
      note: json['note'] as String?,
      ruleType: json['ruleType'] as String?,
      thresholdInt: _asIntOrNull(json['thresholdInt']),
      thresholdMoney: _asDoubleOrNull(json['thresholdMoney']),
      platform: json['platform'] as String?,
      windowDays: _asIntOrNull(json['windowDays']),
      earned: json['earned'] as bool?,
    );
  }

  ProfileBadgeEntity toEntity() {
    return ProfileBadgeEntity(
      code: code,
      name: name,
      description: description,
      howToEarn: howToEarn,
      kind: kind,
      icon: icon,
      source: source,
      awardedAt: awardedAt,
      note: note,
      ruleType: ruleType,
      thresholdInt: thresholdInt,
      thresholdMoney: thresholdMoney,
      platform: platform,
      windowDays: windowDays,
      earned: earned,
    );
  }
}

class ProfileLevelModel {
  const ProfileLevelModel({
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

  static double _asDouble(dynamic v) => v == null ? 0.0 : (v as num).toDouble();
  static int _asInt(dynamic v) => v == null ? 0 : (v as num).toInt();

  factory ProfileLevelModel.fromJson(Map<String, dynamic> json) {
    return ProfileLevelModel(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      rank: _asInt(json['rank']),
      blurb: json['blurb'] as String? ?? '',
      minRewardedPosts: _asInt(json['minRewardedPosts']),
      minTotalRewarded: _asDouble(json['minTotalRewarded']),
      requireBoth: json['requireBoth'] as bool? ?? false,
      benefits: (json['benefits'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      unlocked: json['unlocked'] as bool? ?? false,
      isCurrent: json['isCurrent'] as bool? ?? false,
    );
  }

  ProfileLevelEntity toEntity() {
    return ProfileLevelEntity(
      code: code,
      name: name,
      rank: rank,
      blurb: blurb,
      minRewardedPosts: minRewardedPosts,
      minTotalRewarded: minTotalRewarded,
      requireBoth: requireBoth,
      benefits: benefits,
      unlocked: unlocked,
      isCurrent: isCurrent,
    );
  }
}

class ProfileProgressStatsModel {
  const ProfileProgressStatsModel({
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
  final List<ProfileBadgeModel> badges;

  static double _asDouble(dynamic v) => v == null ? 0.0 : (v as num).toDouble();
  static int _asInt(dynamic v) => v == null ? 0 : (v as num).toInt();
  static double? _asDoubleOrNull(dynamic v) =>
      v == null ? null : (v as num).toDouble();
  static int? _asIntOrNull(dynamic v) => v == null ? null : (v as num).toInt();

  factory ProfileProgressStatsModel.fromJson(Map<String, dynamic> json) {
    final rawLastComputedAt = json['lastComputedAt'] as String?;
    final rawFloorExpiresAt = json['floorExpiresAt'] as String?;
    return ProfileProgressStatsModel(
      computedLevelCode: json['computedLevelCode'] as String? ?? '',
      computedLevelName: json['computedLevelName'] as String? ?? '',
      computedLevelRank: _asInt(json['computedLevelRank']),
      effectiveLevelCode: json['effectiveLevelCode'] as String? ?? '',
      effectiveLevelName: json['effectiveLevelName'] as String? ?? '',
      effectiveLevelRank: _asInt(json['effectiveLevelRank']),
      benefits: (json['benefits'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      rewardedPosts: _asInt(json['rewardedPosts']),
      totalRewarded: _asDouble(json['totalRewarded']),
      distinctBrands: _asInt(json['distinctBrands']),
      joinedCampaigns: _asInt(json['joinedCampaigns']),
      submittedPosts: _asInt(json['submittedPosts']),
      approvedPosts: _asInt(json['approvedPosts']),
      rejectedPosts: _asInt(json['rejectedPosts']),
      paidWithdrawals: _asInt(json['paidWithdrawals']),
      connectedAccounts: _asInt(json['connectedAccounts']),
      lastComputedAt: rawLastComputedAt == null
          ? null
          : DateTime.tryParse(rawLastComputedAt),
      nextLevelCode: json['nextLevelCode'] as String?,
      nextLevelName: json['nextLevelName'] as String?,
      nextLevelRank: _asIntOrNull(json['nextLevelRank']),
      nextLevelBlurb: json['nextLevelBlurb'] as String?,
      nextMinRewardedPosts: _asIntOrNull(json['nextMinRewardedPosts']),
      nextMinTotalRewarded: _asDoubleOrNull(json['nextMinTotalRewarded']),
      postsToNext: _asIntOrNull(json['postsToNext']),
      nprToNext: _asDoubleOrNull(json['nprToNext']),
      hasManualFloor: json['hasManualFloor'] as bool? ?? false,
      floorLevelCode: json['floorLevelCode'] as String?,
      floorLevelName: json['floorLevelName'] as String?,
      floorExpiresAt: rawFloorExpiresAt == null
          ? null
          : DateTime.tryParse(rawFloorExpiresAt),
      floorReason: json['floorReason'] as String?,
      badges: (json['badges'] as List<dynamic>? ?? const [])
          .map((e) => ProfileBadgeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ProfileProgressStatsEntity toEntity() {
    return ProfileProgressStatsEntity(
      computedLevelCode: computedLevelCode,
      computedLevelName: computedLevelName,
      computedLevelRank: computedLevelRank,
      effectiveLevelCode: effectiveLevelCode,
      effectiveLevelName: effectiveLevelName,
      effectiveLevelRank: effectiveLevelRank,
      benefits: benefits,
      rewardedPosts: rewardedPosts,
      totalRewarded: totalRewarded,
      distinctBrands: distinctBrands,
      joinedCampaigns: joinedCampaigns,
      submittedPosts: submittedPosts,
      approvedPosts: approvedPosts,
      rejectedPosts: rejectedPosts,
      paidWithdrawals: paidWithdrawals,
      connectedAccounts: connectedAccounts,
      lastComputedAt: lastComputedAt,
      nextLevelCode: nextLevelCode,
      nextLevelName: nextLevelName,
      nextLevelRank: nextLevelRank,
      nextLevelBlurb: nextLevelBlurb,
      nextMinRewardedPosts: nextMinRewardedPosts,
      nextMinTotalRewarded: nextMinTotalRewarded,
      postsToNext: postsToNext,
      nprToNext: nprToNext,
      hasManualFloor: hasManualFloor,
      floorLevelCode: floorLevelCode,
      floorLevelName: floorLevelName,
      floorExpiresAt: floorExpiresAt,
      floorReason: floorReason,
      badges: badges.map((b) => b.toEntity()).toList(),
    );
  }
}

class ProfileProgressModel {
  const ProfileProgressModel({
    required this.current,
    required this.levels,
    required this.badges,
  });

  final ProfileProgressStatsModel current;
  final List<ProfileLevelModel> levels;
  final List<ProfileBadgeModel> badges;

  factory ProfileProgressModel.fromJson(Map<String, dynamic> json) {
    return ProfileProgressModel(
      current: ProfileProgressStatsModel.fromJson(
        json['progress'] as Map<String, dynamic>? ?? const {},
      ),
      levels: (json['levels'] as List<dynamic>? ?? const [])
          .map((e) => ProfileLevelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      badges: (json['badges'] as List<dynamic>? ?? const [])
          .map((e) => ProfileBadgeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ProfileProgressEntity toEntity() {
    return ProfileProgressEntity(
      current: current.toEntity(),
      levels: levels.map((l) => l.toEntity()).toList(),
      badges: badges.map((b) => b.toEntity()).toList(),
    );
  }
}

/// Wraps the `data` object of the `/creator/profile` response.
class ProfileModel {
  const ProfileModel({
    required this.user,
    required this.insights,
    required this.connections,
    this.progress,
    this.needsSocialConnect = false,
  });

  final ProfileUserModel user;
  final ProfileInsightsModel insights;
  final List<ProfileConnectionModel> connections;
  final ProfileProgressModel? progress;
  final bool needsSocialConnect;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final progressJson = json['progress'] as Map<String, dynamic>?;
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
      progress: progressJson == null
          ? null
          : ProfileProgressModel.fromJson(progressJson),
      needsSocialConnect: json['needsSocialConnect'] as bool? ?? false,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      user: user.toEntity(),
      insights: insights.toEntity(),
      connections: connections.map((c) => c.toEntity()).toList(),
      progress: progress?.toEntity(),
      needsSocialConnect: needsSocialConnect,
    );
  }
}
