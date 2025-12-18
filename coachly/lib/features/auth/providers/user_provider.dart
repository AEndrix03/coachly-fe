import 'package:coachly/features/auth/data/models/user_model/user_model.dart';
import 'package:coachly/features/auth/providers/session_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
UserModel? user(UserRef ref) {
  final session = ref.watch(sessionNotifierProvider);
  final accessToken = session.accessToken;

  if (accessToken == null) {
    return null;
  }

  try {
    final payload = Jwt.parseJwt(accessToken);
    // The payload from jwt_decode is Map<String, dynamic>, which matches our model's fromJson factory.
    return UserModel.fromJson(payload);
  } catch (e) {
    // Handle potential decoding errors (e.g., invalid token)
    print('Error decoding JWT: $e');
    return null;
  }
}
