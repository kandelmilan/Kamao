import 'package:url_launcher/url_launcher.dart';

class AppLegalLinks {
  AppLegalLinks._();

  static const String privacyPolicy =
      'https://aayurise.gyanbato.com/privacy';

  static const String termsAndConditions =
      'https://aayurise.gyanbato.com/terms';

  static Future<bool> openPrivacyPolicy() => openUrl(privacyPolicy);

  static Future<bool> openTermsAndConditions() =>
      openUrl(termsAndConditions);

  static Future<bool> openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
