import 'package:kamao/src/auth/auth.dart';

class LoginResponseEntity {
  const LoginResponseEntity({
    required this.data,
    this.success = true,
    this.message,
    this.correlationId,
  });

  final bool success;
  final AuthDataEntity data;
  final String? message;
  final String? correlationId;

  LoginResponseEntity copyWith({
    bool? success,
    AuthDataEntity? data,
    String? message,
    String? correlationId,
  }) {
    return LoginResponseEntity(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
      correlationId: correlationId ?? this.correlationId,
    );
  }

  @override
  String toString() {
    return 'LoginResponseEntity('
        'success: $success, '
        'data: $data, '
        'message: $message, '
        'correlationId: $correlationId'
        ')';
  }
}
