import 'package:flutter/material.dart';

class SocialPlatform {
  const SocialPlatform({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
    this.backgroundGradient,
    this.notConnectedLabel,
  });

  final String id; // matches the {platform} segment in your API routes
  final String name;
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final List<Color>? backgroundGradient;
  final String? notConnectedLabel;
}
