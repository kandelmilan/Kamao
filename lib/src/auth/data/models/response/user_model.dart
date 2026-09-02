
import 'package:kamao/src/auth/auth.dart';

class UserModel {
  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId']?.toString() ?? '',
      tenantId: json['tenantId']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      roleId: json['roleId']?.toString() ?? '',
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'tenantId': tenantId,
      'email': email,
      'userName': userName,
      'fullName': fullName,
      'roleId': roleId,
      'permissions': permissions,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      tenantId: tenantId,
      email: email,
      userName: userName,
      fullName: fullName,
      roleId: roleId,
      permissions: permissions,
    );
  }

  UserModel copyWith({
    String? userId,
    String? tenantId,
    String? email,
    String? userName,
    String? fullName,
    String? roleId,
    List<String>? permissions,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      tenantId: tenantId ?? this.tenantId,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      roleId: roleId ?? this.roleId,
      permissions: permissions ?? this.permissions,
    );
  }

  @override
  String toString() {
    return 'UserModel('
        'userId: $userId, '
        'email: $email, '
        'fullName: $fullName, '
        'permissions: ${permissions.length}'
        ')';
  }
}
