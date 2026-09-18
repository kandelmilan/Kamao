import 'package:kamao/core/utils/campaign_platforms.dart';

/// A single "what you need to do" row, built dynamically from the
/// campaign's directives (and brief include/exclude summaries) rather
/// than hardcoded fields — so new directive types from the backend show
/// up automatically without a UI change.
class CampaignChecklistItem {
  const CampaignChecklistItem({required this.label, required this.value});

  final String label;
  final String value;
}

class CampaignBriefEntity {
  const CampaignBriefEntity({
    required this.campaignId,
    required this.title,
    required this.narrative,
    required this.includeSummary,
    required this.excludeSummary,
  });

  final String campaignId;
  final String title;
  final String? narrative;
  final String? includeSummary;
  final String? excludeSummary;
}

class CampaignDirectiveEntity {
  const CampaignDirectiveEntity({
    required this.id,
    required this.directiveType,
    required this.valueText,
    required this.isRequired,
    required this.sortOrder,
  });

  final String id;
  final String directiveType; // e.g. "ContentType"
  final String valueText; // e.g. "IG_REEL"
  final bool isRequired;
  final int sortOrder;
}

class CampaignDetailEntity {
  const CampaignDetailEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.objective,
    required this.status,
    required this.currency,
    required this.startDateUtc,
    required this.endDateUtc,
    required this.startDateLocal,
    required this.endDateLocal,
    required this.participationMode,
    required this.performanceWindowHours,
    required this.purchaseProofRequired,
    required this.brandName,
    required this.creatorRewardBudget,
    required this.alreadyJoined,
    required this.brandId,
    required this.brandLogoUrl,
    required this.brandCoverUrl,
    required this.brandCategory,
    required this.creatorMinReward,
    required this.creatorMaxReward,
    required this.isFavourite,
    required this.earnRangeLabel,
    required this.brief,
    required this.directives,
    required this.platforms,
  });

  final String id;
  final String code;
  final String name;
  final String objective;
  final String status;
  final String currency;

  final DateTime? startDateUtc;
  final DateTime? endDateUtc;
  final DateTime? startDateLocal;
  final DateTime? endDateLocal;

  final String participationMode;
  final int? performanceWindowHours;
  final bool purchaseProofRequired;

  final String brandName;
  final double creatorRewardBudget;
  final bool alreadyJoined;
  final String brandId;
  final String? brandLogoUrl;
  final String? brandCoverUrl;
  final String? brandCategory;
  final double creatorMinReward;
  final double creatorMaxReward;
  final bool isFavourite;

  /// Server-formatted label, e.g. "NPR 500 per creator" — use directly,
  /// no need to recompute from min/max on the client.
  final String earnRangeLabel;

  final CampaignBriefEntity brief;
  final List<CampaignDirectiveEntity> directives;

  /// e.g. ['Instagram']
  final List<String> platforms;

  /// Content-type codes from ContentType directives (`IG_REEL`, `TT_VIDEO`, …).
  List<String> get contentTypes => contentTypesFromDirectives(
        directives.map(
          (d) => (directiveType: d.directiveType, valueText: d.valueText),
        ),
      );

  /// Logos for cards / Post-on — prefers content-type codes.
  List<String> get displayPlatforms => resolveCampaignPlatforms(
        contentTypes: contentTypes,
        platforms: platforms,
        name: name,
        objective: objective,
      );

  /// Short line shown under the brand name in the header.
  String get brandTagline => objective;

  /// Main goal copy shown in the "Campaign Goal" card.
  String get campaignGoal =>
      (brief.narrative != null && brief.narrative!.trim().isNotEmpty)
      ? brief.narrative!
      : objective;

  /// Dynamically built "What you need to do" rows: one per directive
  /// type (grouped, values joined), plus include/exclude summaries from
  /// the brief when present.
  List<CampaignChecklistItem> get checklistItems {
    final items = <CampaignChecklistItem>[];

    final sorted = [...directives]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    final grouped = <String, List<String>>{};
    for (final d in sorted) {
      grouped.putIfAbsent(d.directiveType, () => []).add(d.valueText);
    }
    grouped.forEach((type, values) {
      final isContentType =
          type.trim().toLowerCase().replaceAll(' ', '') == 'contenttype';
      items.add(
        CampaignChecklistItem(
          label: _humanizeLabel(type),
          value: isContentType
              ? formatContentTypeLabels(values)
              : values.join(' / '),
        ),
      );
    });

    if (brief.includeSummary != null &&
        brief.includeSummary!.trim().isNotEmpty) {
      items.add(
        CampaignChecklistItem(
          label: 'MUST INCLUDE',
          value: brief.includeSummary!,
        ),
      );
    }
    if (brief.excludeSummary != null &&
        brief.excludeSummary!.trim().isNotEmpty) {
      items.add(
        CampaignChecklistItem(label: 'AVOID', value: brief.excludeSummary!),
      );
    }

    return items;
  }

  CampaignDetailEntity copyWith({bool? alreadyJoined, bool? isFavourite}) {
    return CampaignDetailEntity(
      id: id,
      code: code,
      name: name,
      objective: objective,
      status: status,
      currency: currency,
      startDateUtc: startDateUtc,
      endDateUtc: endDateUtc,
      startDateLocal: startDateLocal,
      endDateLocal: endDateLocal,
      participationMode: participationMode,
      performanceWindowHours: performanceWindowHours,
      purchaseProofRequired: purchaseProofRequired,
      brandName: brandName,
      creatorRewardBudget: creatorRewardBudget,
      alreadyJoined: alreadyJoined ?? this.alreadyJoined,
      brandId: brandId,
      brandLogoUrl: brandLogoUrl,
      brandCoverUrl: brandCoverUrl,
      brandCategory: brandCategory,
      creatorMinReward: creatorMinReward,
      creatorMaxReward: creatorMaxReward,
      isFavourite: isFavourite ?? this.isFavourite,
      earnRangeLabel: earnRangeLabel,
      brief: brief,
      directives: directives,
      platforms: platforms,
    );
  }
}

/// "ContentType" -> "CONTENT TYPE", "MustShow" -> "MUST SHOW"
String _humanizeLabel(String raw) {
  final spaced = raw.replaceAllMapped(
    RegExp(r'(?<=[a-z0-9])(?=[A-Z])'),
    (m) => ' ',
  );
  return spaced.toUpperCase();
}
