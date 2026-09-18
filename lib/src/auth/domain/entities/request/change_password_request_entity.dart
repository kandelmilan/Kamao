class ChangePasswordRequestEntity {
  const ChangePasswordRequestEntity({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;
}
