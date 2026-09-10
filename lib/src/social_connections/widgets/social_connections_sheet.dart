import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:kamao/app/app.dart';
import '../domain/entities/social_platform.dart';
import '../domain/entities/social_connection_status.dart';

abstract class SocialConnectionsHost {
  List<SocialPlatform> get socialPlatforms;
  RxMap<String, SocialConnectionStatus> get socialConnections;
  Future<void> connectPlatform(String platformId);
}

void showSocialConnectionsSheet(
  BuildContext context,
  SocialConnectionsHost controller,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _SocialConnectionsSheet(controller: controller),
  );
}

class SocialBubble extends StatelessWidget {
  const SocialBubble({
    super.key,
    required this.platform,
    required this.status,
    required this.onTap,
  });

  final SocialPlatform platform;
  final SocialConnectionStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isConnected = status.state == SocialConnectionState.connected;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: platform.backgroundGradient == null
                  ? (platform.backgroundColor ?? AppColors.glass)
                  : null,
              gradient: platform.backgroundGradient != null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: platform.backgroundGradient!,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: Icon(platform.icon, size: 15, color: platform.iconColor),
          ),
          if (isConnected)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  RemixIcons.check_line,
                  size: 9,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SocialConnectionsSheet extends StatelessWidget {
  const _SocialConnectionsSheet({required this.controller});

  final SocialConnectionsHost controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connected Accounts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.cardTitle,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Connect the account that owns your posts so we can verify rewards.",
              style: TextStyle(fontSize: 12.5, color: AppColors.bodyGrey),
            ),
            const SizedBox(height: 18),
            for (final platform in controller.socialPlatforms)
              Obx(() {
                final status =
                    controller.socialConnections[platform.id] ??
                    SocialConnectionStatus.initial;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SocialBubble(
                        platform: platform,
                        status: status,
                        onTap: () {},
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              platform.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.cardTitle,
                              ),
                            ),
                            Text(
                              _statusLabel(platform, status),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    status.state == SocialConnectionState.error
                                    ? AppColors.accentDark
                                    : AppColors.bodyGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 34,
                        child: OutlinedButton(
                          onPressed:
                              status.state == SocialConnectionState.connecting
                              ? null
                              : () => controller.connectPlatform(platform.id),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              status.state == SocialConnectionState.connecting
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  status.state ==
                                          SocialConnectionState.connected
                                      ? 'Reconnect'
                                      : 'Connect',
                                  style: const TextStyle(fontSize: 12),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  String _statusLabel(SocialPlatform platform, SocialConnectionStatus status) {
    switch (status.state) {
      case SocialConnectionState.connected:
        return 'Connected${status.connectedAccountLabel != null ? ' — ${status.connectedAccountLabel}' : ''}';
      case SocialConnectionState.connecting:
        return 'Opening browser…';
      case SocialConnectionState.error:
        return status.errorMessage ?? 'Connection failed — tap to retry';
      case SocialConnectionState.notConnected:
        return platform.notConnectedLabel ?? 'Not connected';
    }
  }
}
