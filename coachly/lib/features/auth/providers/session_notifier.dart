import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_notifier.g.dart';

class Session {
  final String? accessToken;
  final String? refreshToken;

  const Session({this.accessToken, this.refreshToken});

  bool get isAuthenticated => accessToken != null;
}

@riverpod
class SessionNotifier extends _$SessionNotifier {
  final _storage = const FlutterSecureStorage();
  final _accessTokenKey = 'access_token';
  final _refreshTokenKey = 'refresh_token';

  @override
  Session build() {
    // Initial state is unauthenticated
    return const Session();
  }

  Future<void> init() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    state = Session(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    state = Session(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
    state = const Session();
  }
}
