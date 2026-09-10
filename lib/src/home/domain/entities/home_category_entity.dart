import 'package:kamao/core/core.dart';

class HomeCategoryEntity {
  const HomeCategoryEntity({
    required this.name,
    required this.brandCount,
    required this.liveCampaignCount,
    this.coverImageUrl,
    this.logoUrl,
  });

  final String name;
  final int brandCount;
  final int liveCampaignCount;
  final String? coverImageUrl;
  final String? logoUrl;

  String? get logoImageUrl {
    final path = logoUrl;
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '${AppConstants.assetBaseUrl}$path';
  }
}
