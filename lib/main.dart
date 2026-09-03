import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/bindings/initial_binding.dart';
import 'package:kamao/src/social_connections/services/social_deep_link_service.dart';
import 'package:requests_inspector/requests_inspector.dart';

import 'app/main_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(SocialDeepLinkService(), permanent: true);
  // Register all permanent dependencies
  InitialBinding().dependencies();

  runApp(RequestsInspector(enabled: true, child: const MainApp()));
  // runApp(const MainApp());
}
