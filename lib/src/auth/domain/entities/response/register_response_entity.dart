import 'package:kamao/src/auth/auth.dart';

// The register endpoint returns the exact same shape as login (it logs the
// new user straight in), so this mirrors LoginResponseEntity and wraps the
// same AuthDataEntity rather than inventing a parallel set of fields.
class RegisterResponseEntity {
  const RegisterResponseEntity({
    required this.data,
    this.success = true,
    this.message,
    this.correlationId,
  });

  final bool success;
  final AuthDataEntity data;
  final String? message;
  final String? correlationId;

  RegisterResponseEntity copyWith({
    bool? success,
    AuthDataEntity? data,
    String? message,
    String? correlationId,
  }) {
    return RegisterResponseEntity(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
      correlationId: correlationId ?? this.correlationId,
    );
  }

  @override
  String toString() {
    return 'RegisterResponseEntity('
        'success: $success, '
        'data: $data, '
        'message: $message, '
        'correlationId: $correlationId'
        ')';
  }
}
