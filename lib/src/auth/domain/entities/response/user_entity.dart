class UserEntity {
  const UserEntity({
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

  UserEntity copyWith({
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
    return UserEntity(
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
