import 'package:kamao/core/core.dart';

/// Turns API-relative media paths into absolute URLs.
///
/// Example: `/uploads/avatars/x.jpg`
/// → `https://aayurise.gyanbato.com/api/uploads/avatars/x.jpg`
String? resolveImageUrl(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http://') || path.startsWith('https://')) {
    // Legacy absolute URLs that omitted `/api` before uploads moved there.
    const legacyHost = 'https://aayurise.gyanbato.com/uploads/';
    const fixedHost = 'https://aayurise.gyanbato.com/api/uploads/';
    if (path.startsWith(legacyHost)) {
      return '$fixedHost${path.substring(legacyHost.length)}';
    }
    return path;
  }
  final normalizedPath = path.startsWith('/') ? path : '/$path';
  return '${AppConstants.assetBaseUrl}$normalizedPath';
}
