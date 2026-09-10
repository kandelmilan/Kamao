import '../../domain/entities/app_config_entity.dart';

class AppConfigModel extends AppConfigEntity {
  const AppConfigModel({
    required super.product,
    required super.brandCategories,
    required super.platforms,
    required super.payoutDestinations,
    super.minimumAge,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      product: json['product'] as String? ?? '',
      minimumAge: json['minimumAge'] as int?,
      platforms: (json['platforms'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      payoutDestinations:
          (json['payoutDestinations'] as List<dynamic>? ?? const [])
              .map((e) => e.toString())
              .toList(),
      brandCategories: (json['brandCategories'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
