import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    print('TokenManager: Saving tokens - Access: ${accessToken.substring(0, 5)}..., Refresh: ${refreshToken.substring(0, 5)}...');
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    print('TokenManager: Tokens saved.');
  }

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: _accessTokenKey);
    print('TokenManager: Retrieved AccessToken: ${token != null ? token.substring(0, 5) + '...' : 'null'}');
    return token;
  }

  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: _refreshTokenKey);
    print('TokenManager: Retrieved RefreshToken: ${token != null ? token.substring(0, 5) + '...' : 'null'}');
    return token;
  }

  Future<void> clearTokens() async {
    print('TokenManager: Clearing tokens...');
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    print('TokenManager: Tokens cleared.');
  }
}
