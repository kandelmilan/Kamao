// class RegisterRequestEntity {
//   const RegisterRequestEntity({
//     required this.tenantCode,
//     required this.fullName,
//     required this.email,
//     required this.password,
//     required this.accountType,
//     required this.acceptedMinimumAge,
//   });

//   final String tenantCode;
//   final String fullName;
//   final String email;
//   final String password;
//   final String accountType;
//   final bool acceptedMinimumAge;

//   RegisterRequestEntity copyWith({
//     String? tenantCode,
//     String? fullName,
//     String? email,
//     String? password,
//     String? accountType,
//     bool? acceptedMinimumAge,
//   }) {
//     return RegisterRequestEntity(
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
//     return '''
// RegisterRequestEntity(
//   tenantCode: $tenantCode,
//   fullName: $fullName,
//   email: $email,
//   accountType: $accountType ',
//   acceptedMinimumAge: $acceptedMinimumAge,
// )
// ''';
//   }
// }

class RegisterRequestEntity {
  const RegisterRequestEntity({
    this.tenantCode = 'Demo',
    required this.fullName,
    required this.email,
    required this.password,
    this.accountType = 'Creator',
    required this.acceptedMinimumAge,
  });

  final String tenantCode;
  final String fullName;
  final String email;
  final String password;
  final String accountType;
  final bool acceptedMinimumAge;

  RegisterRequestEntity copyWith({
    String? tenantCode,
    String? fullName,
    String? email,
    String? password,
    String? accountType,
    bool? acceptedMinimumAge,
  }) {
    return RegisterRequestEntity(
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
    return '''
RegisterRequestEntity(
  tenantCode: $tenantCode,
  fullName: $fullName,
  email: $email,
  accountType: $accountType,
  acceptedMinimumAge: $acceptedMinimumAge,
)
''';
  }
}
