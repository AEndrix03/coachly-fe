import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_dto.freezed.dart';
part 'login_response_dto.g.dart';

@freezed
abstract class LoginResponseDto with _$LoginResponseDto {
  const factory LoginResponseDto({
    required String accessToken,
    required String refreshToken,
    String? firstName, // Make optional
    String? lastName, // Make optional
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  // Factory constructor for when only tokens are available (e.g., offline)
  factory LoginResponseDto.fromTokens({
    required String accessToken,
    required String refreshToken,
  }) =>
      LoginResponseDto(
        accessToken: accessToken,
        refreshToken: refreshToken,
        firstName: null, // Default to null when not provided
        lastName: null, // Default to null when not provided
      );
}
