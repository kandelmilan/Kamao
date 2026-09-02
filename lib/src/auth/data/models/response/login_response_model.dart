import 'package:kamao/src/auth/auth.dart';

class LoginResponseModel {
  const LoginResponseModel({
    required this.data,
  });

  final AuthDataModel data;


  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      data: AuthDataModel.fromJson(json),
    );
  }


  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      success: true,
      data: data.toEntity(),
      message: null,
      correlationId: null,
    );
  }
}