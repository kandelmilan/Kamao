import 'package:kamao/src/auth/auth.dart';

class ChangePasswordRequestModel {
  const ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;

  factory ChangePasswordRequestModel.fromEntity(
    ChangePasswordRequestEntity entity,
  ) {
    return ChangePasswordRequestModel(
      currentPassword: entity.currentPassword,
      newPassword: entity.newPassword,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}
