class TenantEntity {
  const TenantEntity({
    required this.code,
    required this.name,
    required this.isActive,
  });

  final String code;
  final String name;
  final bool isActive;
}
