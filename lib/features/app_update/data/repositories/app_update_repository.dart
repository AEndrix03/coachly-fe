import 'package:coachly/core/config/app_config.dart';
import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/result/api_response_result.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/app_update/data/services/app_requirements_service.dart';
import 'package:coachly/features/app_update/domain/app_update_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appUpdateRepositoryProvider = Provider<AppUpdateRepository>((ref) {
  return AppUpdateRepositoryImpl(
    ref.watch(appRequirementsServiceProvider),
    installedVersion: AppConfig.appVersion,
  );
});

abstract interface class AppUpdateRepository {
  /// Confronta la versione installata con le soglie pubblicate dal backend.
  Future<Result<AppUpdateStatus, Failure>> checkForUpdate();

  /// Soglie dell'ultima verifica riuscita, per il testo della schermata.
  AppRequirements? get lastKnownRequirements;
}

class AppUpdateRepositoryImpl implements AppUpdateRepository {
  AppUpdateRepositoryImpl(
    this._service, {
    required String installedVersion,
  }) : _installedVersion = installedVersion;

  final AppRequirementsService _service;
  final String _installedVersion;

  AppRequirements? _lastKnown;

  @override
  AppRequirements? get lastKnownRequirements => _lastKnown;

  @override
  Future<Result<AppUpdateStatus, Failure>> checkForUpdate() async {
    final response = await _service.fetchRequirements();
    final result = response.toResult();

    return switch (result) {
      Ok(:final value) => () {
        _lastKnown = value;
        return Ok<AppUpdateStatus, Failure>(
          value.statusFor(_installedVersion),
        );
      }(),
      Err(:final failure) => Err(failure),
    };
  }
}
