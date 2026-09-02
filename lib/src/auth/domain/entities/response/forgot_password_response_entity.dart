class ForgotPasswordResponseEntity {
  const ForgotPasswordResponseEntity({
    required this.message,
    required this.devResetLink,
  });

  final String message;
  final String devResetLink;
}
