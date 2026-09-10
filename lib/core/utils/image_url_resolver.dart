import 'package:kamao/core/core.dart';

String? resolveImageUrl(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path; // already absolute
  }
  final normalizedPath = path.startsWith('/') ? path : '/$path';
  return '${AppConstants.assetBaseUrl}$normalizedPath';
}
