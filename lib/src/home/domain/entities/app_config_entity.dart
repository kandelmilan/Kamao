class AppConfigEntity {
  const AppConfigEntity({
    required this.product,
    required this.brandCategories,
    required this.platforms,
    required this.payoutDestinations,
    this.minimumAge,
  });

  final String product;
  final int? minimumAge;
  final List<String> platforms;
  final List<String> payoutDestinations;
  final List<String> brandCategories;
}
