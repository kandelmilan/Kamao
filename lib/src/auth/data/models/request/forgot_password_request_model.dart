import 'package:kamao/src/auth/auth.dart';

class ForgotPasswordRequestModel {
  const ForgotPasswordRequestModel({
    required this.tenantCode,
    required this.email,
  });

  final String tenantCode;
  final String email;

  factory ForgotPasswordRequestModel.fromEntity(
    ForgotPasswordRequestEntity entity,
  ) {
    return ForgotPasswordRequestModel(
      tenantCode: entity.tenantCode,
      email: entity.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {'tenantCode': tenantCode, 'email': email};
  }

  ForgotPasswordRequestModel copyWith({String? tenantCode, String? email}) {
    return ForgotPasswordRequestModel(
      tenantCode: tenantCode ?? this.tenantCode,
      email: email ?? this.email,
    );
  }
}
