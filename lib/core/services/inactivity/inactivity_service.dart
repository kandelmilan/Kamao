import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:kamao/core/core.dart';

class InactivityService {
  InactivityService(this._storage, {this.timeout = const Duration(minutes: 5)});

  final AuthStorageService _storage;
  final Duration timeout;

  Timer? _timer;
  bool _tracking = false;

  VoidCallback? onTimeout;

  Future<void> initialize() async {
    _tracking = true;
    await _storage.saveLastActivity(DateTime.now());
    _startTimer();
  }

  Future<void> resetTimer() async {
    if (!_tracking) return;

    await _storage.saveLastActivity(DateTime.now());
    _startTimer();
  }

  Future<void> pauseTimer() async {
    if (!_tracking) return;

    _timer?.cancel();

    await _storage.saveLastActivity(DateTime.now());
  }

  Future<void> resumeTimer() async {
    if (!_tracking) return;

    if (await hasSessionExpired()) {
      onTimeout?.call();
      return;
    }

    await resetTimer();
  }

  Future<bool> hasSessionExpired() async {
    final lastActivity = await _storage.getLastActivity();

    if (lastActivity == null) return false;

    return DateTime.now().difference(lastActivity) >= timeout;
  }

  Future<void> stop() async {
    _tracking = false;
    _timer?.cancel();
    await _storage.clearLastActivity();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer(timeout, () {
      onTimeout?.call();
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
