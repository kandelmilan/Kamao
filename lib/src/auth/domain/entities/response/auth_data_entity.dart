class AuthDataEntity {
  const AuthDataEntity({
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
    required this.userId,
    required this.tenantId,
    required this.fullName,
    required this.sessionId,
    required this.roleId,
  });

  final String accessToken;
  final DateTime accessTokenExpiresAt;
  final String refreshToken;
  final String userId;
  final String tenantId;
  final String fullName;
  final String sessionId;
  final String roleId;

  AuthDataEntity copyWith({
    String? accessToken,
    DateTime? accessTokenExpiresAt,
    String? refreshToken,
    String? userId,
    String? tenantId,
    String? fullName,
    String? sessionId,
    String? roleId,
  }) {
    return AuthDataEntity(
      accessToken: accessToken ?? this.accessToken,
      accessTokenExpiresAt: accessTokenExpiresAt ?? this.accessTokenExpiresAt,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
      tenantId: tenantId ?? this.tenantId,
      fullName: fullName ?? this.fullName,
      sessionId: sessionId ?? this.sessionId,
      roleId: roleId ?? this.roleId,
    );
  }

  @override
  String toString() {
    return 'AuthDataEntity('
        'userId: $userId, '
        'fullName: $fullName, '
        'tenantId: $tenantId'
        ')';
  }
}
