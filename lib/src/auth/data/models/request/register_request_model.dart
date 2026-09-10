// import 'package:kamao/src/auth/auth.dart';
// import 'package:kamao/src/auth/domain/entities/request/register_request_entity.dart';

// class RegisterRequestModel {
//   final String tenantCode;
//   final String fullName;
//   final String email;
//   final String password;
//   final String accountType;
//   final bool acceptedMinimumAge;

//   const RegisterRequestModel({
//     required this.tenantCode,
//     required this.fullName,
//     required this.email,
//     required this.password,
//     required this.accountType,
//     required this.acceptedMinimumAge,
//   });

//   // Model → JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'tenantCode': tenantCode,
//       'fullName': fullName,
//       'email': email,
//       'password': password,
//       'accountType': accountType,
//       'acceptedMinimumAge': acceptedMinimumAge,
//     };
//   }

//   factory RegisterRequestModel.fromEntity(RegisterRequestEntity entity) {
//     return RegisterRequestModel(
//       tenantCode: entity.tenantCode,
//       fullName: entity.fullName,
//       email: entity.email,
//       password: entity.password,
//       accountType: entity.accountType,
//       acceptedMinimumAge: entity.acceptedMinimumAge,
//     );
//   }

//   // Model → Entity
//   RegisterRequestEntity toEntity() {
//     return RegisterRequestEntity(
//       tenantCode: tenantCode,
//       fullName: fullName,
//       email: email,
//       password: password,
//       accountType: accountType,
//       acceptedMinimumAge: acceptedMinimumAge,
//     );
//   }

//   RegisterRequestModel copyWith({
//     String? tenantCode,
//     String? fullName,
//     String? email,
//     String? password,
//     String? accountType,
//     bool? acceptedMinimumAge,
//   }) {
//     return RegisterRequestModel(
//       tenantCode: tenantCode ?? this.tenantCode,
//       fullName: fullName ?? this.fullName,
//       email: email ?? this.email,
//       password: password ?? this.password,
//       accountType: accountType ?? this.accountType,
//       acceptedMinimumAge: acceptedMinimumAge ?? this.acceptedMinimumAge,
//     );
//   }

//   @override
//   String toString() {
//     return 'RegisterRequestModel(fullName: $fullName, email: $email, '
//         'accountType: $accountType, tenantCode: $tenantCode)';
//   }
// }

import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/auth/domain/entities/request/register_request_entity.dart';

class RegisterRequestModel {
  final String tenantCode;
  final String fullName;
  final String email;
  final String password;
  final String accountType;
  final bool acceptedMinimumAge;

  const RegisterRequestModel({
    this.tenantCode = 'Demo',
    required this.fullName,
    required this.email,
    required this.password,
    this.accountType = 'Creator',
    required this.acceptedMinimumAge,
  });

  // Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'tenantCode': tenantCode,
      'fullName': fullName,
      'email': email,
      'password': password,
      'accountType': accountType,
      'acceptedMinimumAge': acceptedMinimumAge,
    };
  }

  factory RegisterRequestModel.fromEntity(RegisterRequestEntity entity) {
    return RegisterRequestModel(
      tenantCode: entity.tenantCode,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      accountType: entity.accountType,
      acceptedMinimumAge: entity.acceptedMinimumAge,
    );
  }

  // Model → Entity
  RegisterRequestEntity toEntity() {
    return RegisterRequestEntity(
      tenantCode: tenantCode,
      fullName: fullName,
      email: email,
      password: password,
      accountType: accountType,
      acceptedMinimumAge: acceptedMinimumAge,
    );
  }

  RegisterRequestModel copyWith({
    String? tenantCode,
    String? fullName,
    String? email,
    String? password,
    String? accountType,
    bool? acceptedMinimumAge,
  }) {
    return RegisterRequestModel(
      tenantCode: tenantCode ?? this.tenantCode,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      accountType: accountType ?? this.accountType,
      acceptedMinimumAge: acceptedMinimumAge ?? this.acceptedMinimumAge,
    );
  }

  @override
  String toString() {
    return 'RegisterRequestModel(fullName: $fullName, email: $email, '
        'accountType: $accountType, tenantCode: $tenantCode)';
  }
}
