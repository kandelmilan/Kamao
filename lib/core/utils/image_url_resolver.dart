import 'package:kamao/core/constants/app_constants.dart';

/// Turns API-relative media paths into absolute URLs.
///
/// Hosting is split by folder:
/// - `/uploads/commerce/...` → `https://aayurise.gyanbato.com/uploads/...`
/// - `/uploads/avatars|ugc/...` → `https://aayurise.gyanbato.com/api/uploads/...`
String? resolveImageUrl(String? path) {
  if (path == null || path.isEmpty) return null;

  if (path.startsWith('http://') || path.startsWith('https://')) {
    return _rewriteAbsoluteUploadUrl(path);
  }

  final normalized = path.startsWith('/') ? path : '/$path';
  return '${_baseForUploadPath(normalized)}$normalized';
}

String _baseForUploadPath(String normalizedPath) {
  // Brand/commerce assets are served from the site root.
  if (normalizedPath.startsWith('/uploads/commerce/')) {
    return AppConstants.publicAssetBaseUrl;
  }
  // Avatars, UGC thumbnails, and other app uploads sit under /api.
  return AppConstants.assetBaseUrl;
}

String _rewriteAbsoluteUploadUrl(String url) {
  const site = 'https://aayurise.gyanbato.com';
  const apiUploads = '$site/api/uploads/';
  const rootUploads = '$site/uploads/';

  if (url.startsWith(apiUploads)) {
    final rest = url.substring(apiUploads.length);
    if (rest.startsWith('commerce/')) {
      return '$rootUploads$rest';
    }
    return url;
  }

  if (url.startsWith(rootUploads)) {
    final rest = url.substring(rootUploads.length);
    if (!rest.startsWith('commerce/')) {
      return '$apiUploads$rest';
    }
    return url;
  }

  return url;
}
