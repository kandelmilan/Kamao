import '../../domain/entities/tenant_entity.dart';

class TenantModel {
  const TenantModel({
    required this.code,
    required this.name,
    required this.isActive,
  });

  final String code;
  final String name;
  final bool isActive;

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  TenantEntity toEntity() {
    return TenantEntity(code: code, name: name, isActive: isActive);
  }
}
