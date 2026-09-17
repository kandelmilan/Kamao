class ForgotPasswordRequestEntity {
  const ForgotPasswordRequestEntity({
    this.tenantCode = 'Demo',
    required this.email,
  });

  final String tenantCode;
  final String email;
}
