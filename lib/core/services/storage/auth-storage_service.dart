import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../constants/app_constants.dart';
import '../../utils/app_logger.dart';

class AuthStorageService {
  AuthStorageService();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  //==========================================================
  // Safe read/write helpers
  //==========================================================

  /// Reads [key] safely. If the underlying Keystore-backed value can't be
  /// decrypted (e.g. KeyPermanentlyInvalidatedException / BadPaddingException
  /// after a Keystore reset on some Android devices), this deletes just that
  /// corrupted entry and returns null instead of throwing and blocking
  /// whatever called it (e.g. an interceptor on every request).
  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      AppLogger.error(
        'Secure storage read failed for "$key", clearing corrupted entry: $e',
        tag: 'STORAGE',
      );
      try {
        await _storage.delete(key: key);
      } catch (_) {
        // If delete also fails, nothing more we can safely do here.
      }
      return null;
    }
  }

  Future<void> _safeWrite(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      AppLogger.error(
        'Secure storage write failed for "$key": $e',
        tag: 'STORAGE',
      );
    }
  }

  Future<void> _safeDelete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      AppLogger.error(
        'Secure storage delete failed for "$key": $e',
        tag: 'STORAGE',
      );
    }
  }

  //==========================================================
  // Access Token
  //==========================================================

  Future<void> saveAccessToken(String token) async {
    await _safeWrite(AppConstants.accessTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    return _safeRead(AppConstants.accessTokenKey);
  }

  //==========================================================
  // Refresh Token
  //==========================================================

  Future<void> saveRefreshToken(String token) async {
    await _safeWrite(AppConstants.refreshTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    return _safeRead(AppConstants.refreshTokenKey);
  }

  //==========================================================
  // User Id
  //==========================================================

  Future<void> saveUserId(String userId) async {
    await _safeWrite(AppConstants.userIdKey, userId);
  }

  Future<String?> getUserId() async {
    return _safeRead(AppConstants.userIdKey);
  }

  //==========================================================
  // Tenant Id
  //==========================================================

  Future<void> saveTenantId(String tenantId) async {
    await _safeWrite(AppConstants.tenantIdKey, tenantId);
  }

  Future<String?> getTenantId() async {
    return _safeRead(AppConstants.tenantIdKey);
  }

  //==========================================================
  // Session Id
  //==========================================================

  Future<void> saveSessionId(String sessionId) async {
    await _safeWrite(AppConstants.sessionIdKey, sessionId);
  }

  Future<String?> getSessionId() async {
    return _safeRead(AppConstants.sessionIdKey);
  }

  //==========================================================
  // Role Id
  //==========================================================

  Future<void> saveRoleId(String roleId) async {
    await _safeWrite(AppConstants.roleIdKey, roleId);
  }

  Future<String?> getRoleId() async {
    return _safeRead(AppConstants.roleIdKey);
  }

  //==========================================================
  // Save Complete Login Session
  //==========================================================

  Future<void> saveLoginSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String tenantId,
    required String sessionId,
    required String roleId,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
      saveUserId(userId),
      saveTenantId(tenantId),
      saveSessionId(sessionId),
      saveRoleId(roleId),
    ]);
  }

  //==========================================================
  // Login Status
  //==========================================================
  Future<bool> isLoggedIn() async {
    try {
      final accessToken = await getAccessToken();
      final refreshToken = await getRefreshToken();
      final sessionId = await getSessionId();

      return accessToken != null &&
          accessToken.isNotEmpty &&
          refreshToken != null &&
          refreshToken.isNotEmpty &&
          sessionId != null &&
          sessionId.isNotEmpty;
    } catch (e) {
      AppLogger.error('isLoggedIn check failed: $e', tag: 'STORAGE');
      return false;
    }
  }

  //==========================================================
  // Logout
  //==========================================================

  Future<void> clearAuthData() async {
    await Future.wait([
      _safeDelete(AppConstants.accessTokenKey),
      _safeDelete(AppConstants.refreshTokenKey),
      _safeDelete(AppConstants.userIdKey),
      _safeDelete(AppConstants.tenantIdKey),
      _safeDelete(AppConstants.sessionIdKey),
      _safeDelete(AppConstants.roleIdKey),
      _safeDelete(AppConstants.lastActivityKey),
    ]);
  }

  //==========================================================
  // Clear Everything
  //==========================================================

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      AppLogger.error('clearAll failed: $e', tag: 'STORAGE');
    }
  }

  Future<void> setFirstLaunchCompleted() async {
    await _safeWrite(AppConstants.firstLaunchKey, "false");
  }

  Future<bool> isFirstLaunch() async {
    final value = await _safeRead(AppConstants.firstLaunchKey);
    return value != "false";
  }

  Future<void> clearSession() async {
    await clearAuthData();
  }

  //==========================================================
  // Last Activity
  //==========================================================

  Future<void> saveLastActivity(DateTime dateTime) async {
    await _safeWrite(AppConstants.lastActivityKey, dateTime.toIso8601String());
  }

  Future<DateTime?> getLastActivity() async {
    final value = await _safeRead(AppConstants.lastActivityKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  Future<void> clearLastActivity() async {
    await _safeDelete(AppConstants.lastActivityKey);
  }

  Future<bool> hasValidSession() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    final userId = await getUserId();
    final tenantId = await getTenantId();
    final sessionId = await getSessionId();
    final roleId = await getRoleId();

    return [
      accessToken,
      refreshToken,
      userId,
      tenantId,
      sessionId,
      roleId,
    ].every((value) => value != null && value.isNotEmpty);
  }
}
