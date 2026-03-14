import 'package:coachly/features/auth/data/models/user_model/user_model.dart';
import 'package:coachly/features/auth/data/utils/jwt_validator.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
UserModel? user(Ref ref) {
  final authState = ref.watch(authProvider);

  if (authState.isLoading ||
      authState.hasError ||
      authState.value?.tokens == null) {
    return null;
  }

  final accessToken = authState.value!.tokens!.accessToken;

  if (accessToken.isEmpty) return null;

  final payload = JwtValidator.decodeToken(accessToken);
  if (payload == null) return null;

  try {
    final firstName =
        (payload['given_name'] ??
                payload['firstName'] ??
                payload['preferred_username'] ??
                '')
            .toString();
    final lastName = (payload['family_name'] ?? payload['lastName'] ?? '')
        .toString();
    final exp = payload['exp'];
    final sub = (payload['sub'] ?? '').toString();

    if (firstName.isEmpty || sub.isEmpty || exp is! int) {
      return null;
    }

    return UserModel(
      sub: sub,
      firstName: firstName,
      lastName: lastName,
      exp: exp,
    );
  } catch (e) {
    return null;
  }
}
