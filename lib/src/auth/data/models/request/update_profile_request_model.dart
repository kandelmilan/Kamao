import 'package:kamao/src/auth/domain/entities/request/update_profile_request_entity.dart';

class UpdateProfileRequestModel {
  const UpdateProfileRequestModel({
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
  final String dateOfBirth;
  final String country;
  final String city;
  final String address;
  final String gender;
  final String shortDescription;
  final List<String> niches;

  factory UpdateProfileRequestModel.fromEntity(
    UpdateProfileRequestEntity entity,
  ) {
    return UpdateProfileRequestModel(
      email: entity.email,
      userName: entity.userName,
      fullName: entity.fullName,
      phone: entity.phone,
      dateOfBirth: entity.dateOfBirth,
      country: entity.country,
      city: entity.city,
      address: entity.address,
      gender: entity.gender,
      shortDescription: entity.shortDescription,
      niches: entity.niches,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'userName': userName,
      'fullName': fullName,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'country': country,
      'city': city,
      'address': address,
      'gender': gender,
      'shortDescription': shortDescription,
      'niches': niches,
    };
  }
}
