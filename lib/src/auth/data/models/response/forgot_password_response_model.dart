import 'package:kamao/src/auth/auth.dart';

class ForgotPasswordResponseModel {
  const ForgotPasswordResponseModel({
    required this.message,
    required this.devResetLink,
  });

  final String message;
  final String devResetLink;

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      message: json['message'] ?? '',
      devResetLink: json['devResetLink'] ?? '',
    );
  }

  ForgotPasswordResponseEntity toEntity() {
    return ForgotPasswordResponseEntity(
      message: message,
      devResetLink: devResetLink,
    );
  }

  ForgotPasswordResponseModel copyWith({
    String? message,
    String? devResetLink,
  }) {
    return ForgotPasswordResponseModel(
      message: message ?? this.message,
      devResetLink: devResetLink ?? this.devResetLink,
    );
  }
}
