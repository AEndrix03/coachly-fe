import 'package:coachly/features/auth/data/models/user_model/user_model.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
UserModel? user(Ref ref) {
  final authState = ref.watch(authProvider);

  if (authState.isLoading || authState.hasError || authState.value == null) {
    return null;
  }

  final accessToken = authState.value!.accessToken;

  if (accessToken == null || accessToken.isEmpty) {
    return null;
  }

  try {
    // Check if the token is expired before decoding (optional, can be done by interceptor)
    if (JwtDecoder.isExpired(accessToken)) {
      // Token is expired, return null to indicate no active user
      return null;
    }

    final Map<String, dynamic> payload = JwtDecoder.decode(accessToken);
    return UserModel.fromJson(payload);
  } catch (e) {
    // Handle potential decoding errors (e.g., invalid token format)
    print('Error decoding JWT: $e');
    return null;
  }
}
