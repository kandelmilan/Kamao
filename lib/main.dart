import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:kamao/app/bindings/initial_binding.dart';
import 'package:kamao/src/social_connections/services/social_deep_link_service.dart';
import 'package:requests_inspector/requests_inspector.dart';

import 'app/main_app.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Keep the native (Android 12+) splash up until SplashView is ready.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Get.put(SocialDeepLinkService(), permanent: true);
  // Register all permanent dependencies
  InitialBinding().dependencies();

  runApp(RequestsInspector(enabled: true, child: const MainApp()));
  // runApp(const MainApp());
}
