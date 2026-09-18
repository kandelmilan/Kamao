import 'package:dartz/dartz.dart';
import 'package:kamao/core/errors/failure.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:kamao/src/home/domain/usecase/marketplace/get_campaign_detail_usecase.dart';

/// In-memory platforms from campaign detail (`platforms` + ContentType directives).
/// List endpoints omit these; detail has them — we cache after the first fetch.
class CampaignPlatformCache {
  CampaignPlatformCache._();

  static final Map<String, ({List<String> contentTypes, List<String> platforms})>
      _byId = {};

  static void put(
    String campaignId, {
    required List<String> contentTypes,
    required List<String> platforms,
  }) {
    if (contentTypes.isEmpty && platforms.isEmpty) return;
    _byId[campaignId] = (
      contentTypes: List.unmodifiable(contentTypes),
      platforms: List.unmodifiable(platforms),
    );
  }

  static void putFromDetail(CampaignDetailEntity detail) {
    put(
      detail.id,
      contentTypes: detail.contentTypes,
      platforms: detail.platforms,
    );
  }

  static ({List<String> contentTypes, List<String> platforms})? get(
    String campaignId,
  ) =>
      _byId[campaignId];

  static CampaignEntity applyCache(CampaignEntity campaign) {
    final cached = _byId[campaign.id];
    if (cached == null) return campaign;
    if (campaign.contentTypes.isNotEmpty || campaign.platforms.isNotEmpty) {
      return campaign;
    }
    return campaign.copyWith(
      contentTypes: cached.contentTypes,
      platforms: cached.platforms,
    );
  }
}

/// Fills [contentTypes]/[platforms] on list campaigns that lack them by
/// calling campaign detail (same source as the Post-on row).
Future<List<CampaignEntity>> enrichCampaignPlatforms({
  required List<CampaignEntity> campaigns,
  required GetCampaignDetailUseCase getDetail,
  int maxFetches = 12,
}) async {
  final out = List<CampaignEntity>.from(campaigns);
  final toFetch = <int>[];

  for (var i = 0; i < out.length; i++) {
    final applied = CampaignPlatformCache.applyCache(out[i]);
    out[i] = applied;
    if (applied.displayPlatforms.isEmpty) {
      toFetch.add(i);
    }
  }

  final fetchIndexes = toFetch.take(maxFetches).toList();
  if (fetchIndexes.isEmpty) return out;

  await Future.wait(
    fetchIndexes.map((index) async {
      final id = out[index].id;
      final Either<Failure, CampaignDetailEntity> result = await getDetail(
        CampaignIdParams(id),
      );
      result.fold((_) {}, (detail) {
        CampaignPlatformCache.putFromDetail(detail);
        out[index] = out[index].copyWith(
          contentTypes: detail.contentTypes,
          platforms: detail.platforms,
        );
      });
    }),
  );

  return out;
}
