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
    return UserModel.fromJson(payload);
  } catch (e) {
    return null;
  }
}
