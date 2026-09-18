import 'package:kamao/core/core.dart';

/// Full brand profile returned by `GET /creator/brands/{id}`.
///
/// Deliberately separate from the existing `BrandEntity` (used for
/// Popular/Featured brand tiles) — that one only carries what a tile
/// needs. This one backs the brand *detail* screen, so it also
/// carries bio/about copy, social handles, post tips, and the
/// posting-limit windows.
class BrandProfileEntity {
  const BrandProfileEntity({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.logoUrl,
    this.coverImageUrl,
    this.aliases,
    this.bio,
    this.about,
    this.categoryName,
    this.websiteUrl,
    this.instagramHandle,
    this.tikTokHandle,
    this.youTubeHandle,
    this.facebookHandle,
    this.postTip1,
    this.postTip2,
    this.postTip3,
    required this.maxRewardAmount,
    required this.receiptRequired,
    required this.postsPer7Days,
    required this.postsPer12Months,
    required this.currency,
    required this.liveCampaignCount,
    this.isFavourite = false,
  });

  final String id;
  final String code;
  final String name;
  final String? description;

  /// Relative path from the API — use [logoImageUrl] to render it.
  final String? logoUrl;
  final String? coverImageUrl;
  final String? aliases;
  final String? bio;
  final String? about;
  final String? categoryName;
  final String? websiteUrl;
  final String? instagramHandle;
  final String? tikTokHandle;
  final String? youTubeHandle;
  final String? facebookHandle;
  final String? postTip1;
  final String? postTip2;
  final String? postTip3;
  final num maxRewardAmount;
  final bool receiptRequired;
  final int postsPer7Days;
  final int postsPer12Months;
  final String currency;
  final int liveCampaignCount;
  final bool isFavourite;

  /// Full, directly-loadable logo URL via [resolveImageUrl].
  String? get logoImageUrl => resolveImageUrl(logoUrl);

  String? get coverImageFullUrl => resolveImageUrl(coverImageUrl);

  /// Non-empty post tips, in order — drives the "Post Tips" card.
  List<String> get postTips => [
    if (postTip1 != null && postTip1!.trim().isNotEmpty) postTip1!.trim(),
    if (postTip2 != null && postTip2!.trim().isNotEmpty) postTip2!.trim(),
    if (postTip3 != null && postTip3!.trim().isNotEmpty) postTip3!.trim(),
  ];

  /// Platforms with a handle set, in display order — drives the
  /// "Post on" chips in the header and the links card.
  List<String> get connectedPlatforms => [
    if (instagramHandle != null && instagramHandle!.isNotEmpty) 'Instagram',
    if (tikTokHandle != null && tikTokHandle!.isNotEmpty) 'TikTok',
    if (youTubeHandle != null && youTubeHandle!.isNotEmpty) 'YouTube',
    if (facebookHandle != null && facebookHandle!.isNotEmpty) 'Facebook',
  ];

  BrandProfileEntity copyWith({bool? isFavourite}) {
    return BrandProfileEntity(
      id: id,
      code: code,
      name: name,
      description: description,
      logoUrl: logoUrl,
      coverImageUrl: coverImageUrl,
      aliases: aliases,
      bio: bio,
      about: about,
      categoryName: categoryName,
      websiteUrl: websiteUrl,
      instagramHandle: instagramHandle,
      tikTokHandle: tikTokHandle,
      youTubeHandle: youTubeHandle,
      facebookHandle: facebookHandle,
      postTip1: postTip1,
      postTip2: postTip2,
      postTip3: postTip3,
      maxRewardAmount: maxRewardAmount,
      receiptRequired: receiptRequired,
      postsPer7Days: postsPer7Days,
      postsPer12Months: postsPer12Months,
      currency: currency,
      liveCampaignCount: liveCampaignCount,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
