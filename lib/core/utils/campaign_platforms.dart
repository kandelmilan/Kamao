/// Maps API content-type codes and platform labels to display keys.
///
/// Content types use prefixes: `IG` → Instagram, `TT` → TikTok, `FB` → Facebook
/// (e.g. `IG_REEL`, `TT_VIDEO`, `FB_POST`), plus full names / `platforms` arrays.
List<String> resolveCampaignPlatforms({
  List<String>? contentTypes,
  List<String>? platforms,
  String? name,
  String? objective,
}) {
  final resolved = <String>[];

  void addAll(Iterable<String>? values) {
    for (final raw in values ?? const <String>[]) {
      for (final key in _keysFromToken(raw)) {
        if (!resolved.contains(key)) resolved.add(key);
      }
    }
  }

  addAll(contentTypes);
  if (resolved.isNotEmpty) return resolved;

  addAll(platforms);
  if (resolved.isNotEmpty) return resolved;

  final text = '${name ?? ''} ${objective ?? ''}';
  for (final match in RegExp(
    r'\b(IG|TT|FB|YT|INSTAGRAM|TIKTOK|FACEBOOK|YOUTUBE)\b',
    caseSensitive: false,
  ).allMatches(text)) {
    for (final key in _keysFromToken(match.group(0)!)) {
      if (!resolved.contains(key)) resolved.add(key);
    }
  }
  return resolved;
}

/// Pulls ContentType directive values (`IG_REEL`, `TT_VIDEO`, …).
List<String> contentTypesFromDirectives(
  Iterable<({String directiveType, String valueText})> directives,
) {
  final out = <String>[];
  for (final d in directives) {
    final type = d.directiveType.trim().toLowerCase().replaceAll(' ', '');
    if (type != 'contenttype') continue;
    final value = d.valueText.trim();
    if (value.isEmpty) continue;
    out.add(value);
  }
  return out;
}

/// `IG_REEL` → `Instagram Reel`, `TT_VIDEO` → `TikTok Video`, `FB` → `Facebook`.
String formatContentTypeLabel(String raw) {
  final token = raw.trim();
  if (token.isEmpty) return '';

  // Already human text.
  if (token.contains(' ') && !_looksLikeCode(token)) return token;

  final parts = token
      .split(RegExp(r'[_\-\s]+'))
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return token;

  final platform = _platformDisplayName(parts.first);
  if (platform == null) {
    return parts.map(_titleCase).join(' ');
  }
  if (parts.length == 1) return platform;

  final rest = parts.skip(1).map(_titleCase).join(' ');
  return rest.isEmpty ? platform : '$platform $rest';
}

/// Joins several codes: `IG_REEL / TT_VIDEO` → `Instagram Reel / TikTok Video`.
String formatContentTypeLabels(Iterable<String> codes) {
  final labels = <String>[];
  for (final raw in codes) {
    for (final part in raw.split(RegExp(r'[/|,;]+'))) {
      final label = formatContentTypeLabel(part);
      if (label.isNotEmpty && !labels.contains(label)) labels.add(label);
    }
  }
  return labels.join(' / ');
}

bool _looksLikeCode(String token) {
  final upper = token.toUpperCase();
  return RegExp(r'\b(IG|TT|FB|YT)([_\-\s]|$)').hasMatch(upper);
}

String? _platformDisplayName(String code) {
  switch (code.trim().toLowerCase()) {
    case 'ig':
    case 'instagram':
      return 'Instagram';
    case 'tt':
    case 'tiktok':
      return 'TikTok';
    case 'fb':
    case 'facebook':
      return 'Facebook';
    case 'yt':
    case 'youtube':
      return 'YouTube';
    default:
      return null;
  }
}

String _titleCase(String raw) {
  final s = raw.trim().toLowerCase();
  if (s.isEmpty) return '';
  switch (s) {
    case 'ig':
      return 'Instagram';
    case 'tt':
      return 'TikTok';
    case 'fb':
      return 'Facebook';
    case 'yt':
      return 'YouTube';
  }
  return '${s[0].toUpperCase()}${s.substring(1)}';
}

Iterable<String> _keysFromToken(String raw) {
  final token = raw.trim();
  if (token.isEmpty) return const [];

  final parts = token
      .split(RegExp(r'[/|,;\s]+'))
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty);

  final keys = <String>[];
  for (final part in parts) {
    final key = _normalizePlatformKey(part);
    if (key != null && !keys.contains(key)) keys.add(key);
  }
  return keys;
}

String? _normalizePlatformKey(String raw) {
  final lower = raw.trim().toLowerCase();
  if (lower.isEmpty) return null;

  final code = lower.split(RegExp(r'[_\-\s]')).first;
  switch (code) {
    case 'ig':
    case 'instagram':
      return 'instagram';
    case 'tt':
    case 'tiktok':
      return 'tiktok';
    case 'fb':
    case 'facebook':
      return 'facebook';
    case 'yt':
    case 'youtube':
      return 'youtube';
  }

  if (lower.contains('instagram')) return 'instagram';
  if (lower.contains('tiktok') || lower.contains('tik tok')) return 'tiktok';
  if (lower.contains('facebook')) return 'facebook';
  if (lower.contains('youtube') || lower.contains('you tube')) {
    return 'youtube';
  }
  return null;
}
