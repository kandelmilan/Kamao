import 'package:kamao/src/auth/auth.dart';

class AuthDataModel {
  const AuthDataModel({
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

  factory AuthDataModel.fromEntity(AuthDataEntity entity) {
    return AuthDataModel(
      accessToken: entity.accessToken,
      accessTokenExpiresAt: entity.accessTokenExpiresAt,
      refreshToken: entity.refreshToken,
      userId: entity.userId,
      tenantId: entity.tenantId,
      fullName: entity.fullName,
      sessionId: entity.sessionId,
      roleId: entity.roleId,
    );
  }
  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    final model = AuthDataModel(
      accessToken: json['accessToken']?.toString() ?? '',
      accessTokenExpiresAt:
          DateTime.tryParse(json['accessTokenExpiresAt']?.toString() ?? '') ??
          DateTime.now(),
      refreshToken: json['refreshToken']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      tenantId: json['tenantId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      sessionId: json['sessionId']?.toString() ?? '',
      roleId: json['roleId']?.toString() ?? '',
    );

    return model;
  }
  // factory AuthDataModel.fromJson(Map<String, dynamic> json) {
  //   print("========= AuthData JSON =========");
  //   print(json);

  //   final model = AuthDataModel(
  //     accessToken: json['accessToken'] as String? ?? '',
  //     accessTokenExpiresAt:
  //         DateTime.tryParse(json['accessTokenExpiresAt'] as String? ?? '') ??
  //         DateTime.now(),
  //     refreshToken: json['refreshToken'] as String? ?? '',
  //     userId: json['userId'] as String? ?? '',
  //     tenantId: json['tenantId'] as String? ?? '',
  //     fullName: json['fullName'] as String? ?? '',
  //     sessionId: json['sessionId'] as String? ?? '',
  //     roleId: json['roleId'] as String? ?? '',
  //   );

  //   print("AccessToken = ${model.accessToken}");
  //   print("UserId = ${model.userId}");
  //   print("FullName = ${model.fullName}");

  //   return model;
  // }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'accessTokenExpiresAt': accessTokenExpiresAt.toIso8601String(),
    'refreshToken': refreshToken,
    'userId': userId,
    'tenantId': tenantId,
    'fullName': fullName,
    'sessionId': sessionId,
    'roleId': roleId,
  };

  AuthDataModel copyWith({
    String? accessToken,
    DateTime? accessTokenExpiresAt,
    String? refreshToken,
    String? userId,
    String? tenantId,
    String? fullName,
    String? sessionId,
    String? roleId,
  }) => AuthDataModel(
    accessToken: accessToken ?? this.accessToken,
    accessTokenExpiresAt: accessTokenExpiresAt ?? this.accessTokenExpiresAt,
    refreshToken: refreshToken ?? this.refreshToken,
    userId: userId ?? this.userId,
    tenantId: tenantId ?? this.tenantId,
    fullName: fullName ?? this.fullName,
    sessionId: sessionId ?? this.sessionId,
    roleId: roleId ?? this.roleId,
  );

  AuthDataEntity toEntity() => AuthDataEntity(
    accessToken: accessToken,
    accessTokenExpiresAt: accessTokenExpiresAt,
    refreshToken: refreshToken,
    userId: userId,
    tenantId: tenantId,
    fullName: fullName,
    sessionId: sessionId,
    roleId: roleId,
  );
}
