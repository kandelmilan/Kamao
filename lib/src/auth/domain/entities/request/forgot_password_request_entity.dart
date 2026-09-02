class ForgotPasswordRequestEntity {
  const ForgotPasswordRequestEntity({
    required this.tenantCode,
    required this.email,
  });

  final String tenantCode;
  final String email;
}
