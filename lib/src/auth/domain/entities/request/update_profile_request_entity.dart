class UpdateProfileRequestEntity {
  const UpdateProfileRequestEntity({
    required this.email,
    required this.userName,
    required this.fullName,
    required this.phone,
    required this.dateOfBirth,
    required this.country,
    required this.city,
    required this.address,
    required this.gender,
    required this.shortDescription,
    required this.niches,
  });

  final String email;
  final String userName;
  final String fullName;
  final String phone;

  /// Date-only ISO string, e.g. `2026-09-18`.
  final String dateOfBirth;
  final String country;
  final String city;
  final String address;
  final String gender;
  final String shortDescription;
  final List<String> niches;
}
