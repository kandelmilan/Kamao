
class RefreshTokenRequestEntity {
  const RefreshTokenRequestEntity({required this.refreshToken});
  final String refreshToken;

  RefreshTokenRequestEntity copyWith({String? refreshToken}) {
    return RefreshTokenRequestEntity(
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory RefreshTokenRequestEntity.fromEntity(
    RefreshTokenRequestEntity entity,
  ) {
    return RefreshTokenRequestEntity(refreshToken: entity.refreshToken);
  }

  RefreshTokenRequestEntity toEntity() {
    return RefreshTokenRequestEntity(refreshToken: refreshToken);
  }

  @override
  String toString() {
    return 'RefreshTokenRequestEntity(refreshToken: $refreshToken)';
  }
}
