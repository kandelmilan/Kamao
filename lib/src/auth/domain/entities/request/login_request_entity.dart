// class LoginRequestEntity {
//   const LoginRequestEntity({
//     required this.email,
//     required this.password,
//     required this.tenantCode,
//   });

//   final String email;
//   final String password;
//   final String tenantCode;

//   LoginRequestEntity copyWith({
//     String? email,
//     String? password,
//     String? tenantCode,
//   }) {
//     return LoginRequestEntity(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       tenantCode: tenantCode ?? this.tenantCode,
//     );
//   }

//   @override
//   String toString() {
//     return '''
// LoginRequestEntity(
//   email: $email,
//   tenantCode: $tenantCode,
// )
// ''';
//   }
// }
class LoginRequestEntity {
  const LoginRequestEntity({
    required this.email,
    required this.password,
    this.tenantCode = 'Demo',
  });

  final String email;
  final String password;
  final String tenantCode;

  LoginRequestEntity copyWith({
    String? email,
    String? password,
    String? tenantCode,
  }) {
    return LoginRequestEntity(
      email: email ?? this.email,
      password: password ?? this.password,
      tenantCode: tenantCode ?? this.tenantCode,
    );
  }

  @override
  String toString() {
    return '''
LoginRequestEntity(
  email: $email,
  tenantCode: $tenantCode,
)
''';
  }
}
