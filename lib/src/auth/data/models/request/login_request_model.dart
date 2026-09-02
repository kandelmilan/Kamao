import 'package:kamao/src/auth/auth.dart';

class LoginRequestModel {
  final String email;
  final String password;
  final String tenantCode;

  const LoginRequestModel({
    required this.email,
    required this.password,
    required this.tenantCode,
  });

  // Model → JSON
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'tenantCode': tenantCode};
  }

  factory LoginRequestModel.fromEntity(LoginRequestEntity entity) {
    return LoginRequestModel(
      email: entity.email,
      password: entity.password,
      tenantCode: entity.tenantCode,
    );
  }
  // Model → Entity
  LoginRequestEntity toEntity() {
    return LoginRequestEntity(
      email: email,
      password: password,
      tenantCode: tenantCode,
    );
  }

  LoginRequestModel copyWith({
    String? email,
    String? password,
    String? tenantCode,
  }) {
    return LoginRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
      tenantCode: tenantCode ?? this.tenantCode,
    );
  }

  @override
  String toString() {
    return 'LoginRequestModel(email: $email, tenantCode: $tenantCode)';
  }
}
