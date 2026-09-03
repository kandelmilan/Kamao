// import 'dart:async';
// import 'package:app_links/app_links.dart';

// /// Listens for kamao://social-connect-result?code=...&state=...
// /// redirects fired when the platform hands control back to the app.
// class SocialDeepLinkService {
//   final _appLinks = AppLinks();
//   StreamSubscription<Uri>? _sub;

//   void listen(void Function(Uri uri) onResult) {
//     _sub = _appLinks.uriLinkStream.listen((uri) {
//       if (uri.scheme == 'kamao' && uri.host == 'social-connect-result') {
//         onResult(uri);
//       }
//     }, onError: (_) {});
//   }

//   void dispose() => _sub?.cancel();
// }
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

/// App-wide listener for kamao://social-connect-result redirects.
///
/// Must be created ONCE, as early as possible — e.g. in main.dart via
/// `Get.put(SocialDeepLinkService(), permanent: true)`, before splash
/// navigates anywhere. app_links' getInitialLink() only ever returns
/// the cold-launch link ONCE for the whole app lifetime; if a
/// per-screen controller (like HomeController, which is only created
/// after splash) calls it, it's already too late and gets null.
///
/// Screens that care about the result call consumePendingLink() to
/// pick up anything that arrived before they existed, then listen()
/// for anything that arrives while they're alive.
class SocialDeepLinkService {
  SocialDeepLinkService() {
    _init();
  }

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Uri? _pendingLink;
  final _controller = StreamController<Uri>.broadcast();

  bool _isRelevant(Uri uri) =>
      uri.scheme == 'kamao' && uri.host == 'social-connect-result';

  // social_deep_link_service.dart — add debugPrint calls
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
      if (_isRelevant(uri)) {
        _pendingLink = uri;
        _controller.add(uri);
      }
    }, onError: (e) => debugPrint('[DeepLink] stream error: $e'));
  }

  Uri? consumePendingLink() {
    debugPrint('[DeepLink] consumePendingLink() → $_pendingLink');
    final link = _pendingLink;
    _pendingLink = null;
    return link;
  }

  /// Live updates for links that arrive while a screen is already
  /// listening (app resumed from background mid-flow, for example).
  void listen(void Function(Uri uri) onResult) {
    _controller.stream.listen(onResult);
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
