

import 'package:kamao/src/auth/auth.dart';

class RefreshTokenRequestModel {
  const RefreshTokenRequestModel({required this.refreshToken});

  final String refreshToken;

  factory RefreshTokenRequestModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenRequestModel(
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }

  factory RefreshTokenRequestModel.fromEntity(
    RefreshTokenRequestEntity entity,
  ) {
    return RefreshTokenRequestModel(refreshToken: entity.refreshToken);
  }

  RefreshTokenRequestEntity toEntity() {
    return RefreshTokenRequestEntity(refreshToken: refreshToken);
  }

  Map<String, dynamic> toJson() {
    return {'refreshToken': refreshToken};
  }
}
