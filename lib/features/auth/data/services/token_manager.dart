import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _idTokenKey = 'idToken';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveTokens(
    String accessToken,
    String refreshToken, {
    String? idToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    if (idToken != null) {
      await _storage.write(key: _idTokenKey, value: idToken);
    }
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<String?> getIdToken() async {
    return _storage.read(key: _idTokenKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _idTokenKey);
  }
}
