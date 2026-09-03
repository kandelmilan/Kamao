enum SocialConnectionState { notConnected, connecting, connected, error }

class SocialConnectionStatus {
  const SocialConnectionStatus({
    required this.state,
    this.connectedAccountLabel,
    this.errorMessage,
  });

  final SocialConnectionState state;
  final String? connectedAccountLabel; 
  final String? errorMessage;

  static const SocialConnectionStatus initial = SocialConnectionStatus(
    state: SocialConnectionState.notConnected,
  );
}
