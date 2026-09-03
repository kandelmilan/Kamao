import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/auth/domain/entities/response/register_response_entity.dart';

// Same top-level shape as the login response ({ accessToken, refreshToken,
// userId, ... } sitting directly under "data"), so this parses exactly the
// way LoginResponseModel does, straight into AuthDataModel.
class RegisterResponseModel {
  const RegisterResponseModel({required this.data});

  final AuthDataModel data;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(data: AuthDataModel.fromJson(json));
  }

  RegisterResponseEntity toEntity() {
    return RegisterResponseEntity(
      success: true,
      data: data.toEntity(),
      message: null,
      correlationId: null,
    );
  }
}
