import 'package:flutter/material.dart';
import 'package:kamao/core/core.dart';

class PermissionGate extends StatelessWidget {
  const PermissionGate({
    super.key,
    required this.permission,
    required this.builder,
    this.message = "You don't have access to this section.",
  });

  final String permission;
  final WidgetBuilder builder;
  final String message;

  @override
  Widget build(BuildContext context) {
    if (!userHasPermission(permission)) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
          ),
        ),
      );
    }
    return builder(context);
  }
}
