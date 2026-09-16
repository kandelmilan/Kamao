import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';

/// App-wide listener for `kamao://social-connect-result` redirects.
///
/// Must be created once, early — e.g. in `main.dart` via
/// `Get.put(SocialDeepLinkService(), permanent: true)` — so
/// `getInitialLink()` is not lost before Home/Profile mount.
class SocialDeepLinkService {
  SocialDeepLinkService() {
    _init();
  }

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Uri? _pendingLink;
  String? _lastDelivered;
  final _controller = StreamController<Uri>.broadcast();

  bool _isRelevant(Uri uri) =>
      uri.scheme == 'kamao' && uri.host == 'social-connect-result';

  Future<void> _init() async {
    try {
      final initial = await _appLinks.getInitialLink();
      debugPrint('[DeepLink] getInitialLink() → $initial');
      if (initial != null && _isRelevant(initial)) {
        _pendingLink = initial;
        debugPrint('[DeepLink] stored as pending: $_pendingLink');
      }
    } catch (e) {
      debugPrint('[DeepLink] getInitialLink failed: $e');
    }

    _sub = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('[DeepLink] uriLinkStream fired: $uri');
      if (!_isRelevant(uri)) return;
      _deliver(uri);
    }, onError: (e) => debugPrint('[DeepLink] stream error: $e'));
  }

  void _deliver(Uri uri) {
    final key = uri.toString();
    if (_lastDelivered == key) {
      debugPrint('[DeepLink] ignoring duplicate: $key');
      return;
    }
    _lastDelivered = key;

    if (_controller.hasListener) {
      _controller.add(uri);
    } else {
      _pendingLink = uri;
    }
  }

  Uri? consumePendingLink() {
    debugPrint('[DeepLink] consumePendingLink() → $_pendingLink');
    final link = _pendingLink;
    _pendingLink = null;
    if (link != null) {
      _lastDelivered = link.toString();
    }
    return link;
  }

  /// Live updates for links that arrive while a screen is already listening.
  StreamSubscription<Uri> listen(void Function(Uri uri) onResult) {
    return _controller.stream.listen(onResult);
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
