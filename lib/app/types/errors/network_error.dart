import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/types/errors/network_error_utils.dart';

part 'network_error.freezed.dart';

@freezed
sealed class NetworkError with _$NetworkError {
  const factory NetworkError.badRequest() = _BadRequest;

  const factory NetworkError.badRequestListErrors(List<String> listErrors) =
      _BadRequestListErrors;

  const factory NetworkError.conflict() = _Conflict;

  const factory NetworkError.defaultError(String error) = _DefaultError;

  const factory NetworkError.formatException() = _FormatException;

  const factory NetworkError.internalServerError() = _InternalServerError;

  const factory NetworkError.methodNotAllowed() = _MethodNotAllowed;

  const factory NetworkError.noInternetConnection() = _NoInternetConnection;

  const factory NetworkError.notAcceptable() = _NotAcceptable;

  const factory NetworkError.notFound(String reason) = _NotFound;

  const factory NetworkError.notImplemented() = _NotImplemented;

  const factory NetworkError.requestCancelled() = _RequestCancelled;

  const factory NetworkError.requestTimeout() = _RequestTimeout;

  const factory NetworkError.sendTimeout() = _SendTimeout;

  const factory NetworkError.serviceUnavailable() = _ServiceUnavailable;

  const factory NetworkError.unableToProcess() = _UnableToProcess;

  const factory NetworkError.unauthorizedRequest() = _UnauthorizedRequest;

  const factory NetworkError.forbidden() = _Forbidden;

  const factory NetworkError.unexpectedError() = _UnexpectedError;

  const factory NetworkError.mockNotFoundError() = _MockNotFoundError;

  const factory NetworkError.infoNotMatching() = _InfoNotMatching;

  // Biometrics
  const factory NetworkError.noStoredCredentials() = _NoStoredCredentials;
  const factory NetworkError.biometricAuthFailed() = _BiometricAuthFailed;
  const factory NetworkError.biometricHardwareUnavailable() =
      _BiometricHardwareUnavailable;
  const factory NetworkError.biometricAuthCancelled() = _BiometricAuthCancelled;

  static NetworkError fromException(error) {
    try {
      if (error is PlatformException) {
        if (error.code == 'auth_canceled') {
          return const NetworkError.biometricAuthCancelled();
        }
        if (error.code == 'NotAvailable' || error.code == 'not_authenticated') {
          return const NetworkError.biometricHardwareUnavailable();
        }
        if (error.code == 'NotEnrolled') {
          return const NetworkError.noStoredCredentials();
        }
        if (error.code == 'NotSupported') {
          return const NetworkError.biometricHardwareUnavailable();
        }
        if (error.code == 'AuthCancelled') {
          return const NetworkError.biometricAuthCancelled();
        }
        if (error.code == 'LockedOut' || error.code == 'PermanentlyLockedOut') {
          // Maneja el caso en que el usuario intentó demasiadas veces
          return const NetworkError.biometricAuthFailed();
        }
        // Para otros códigos de error, asume que es un fallo de autenticación
        return const NetworkError.biometricAuthFailed();
      }
      if (error is Exception) {
        if (error is DioException) {
          return getErrorFromDioError(error);
        }
        if (error is SocketException) {
          return const NetworkError.noInternetConnection();
        }
        return const NetworkError.unexpectedError();
      }
      if (error is FormatException) {
        return const NetworkError.formatException();
      }

      if (error.toString().contains('is not a subtype of')) {
        return const NetworkError.unableToProcess();
      }
      return const NetworkError.unexpectedError();
    } catch (_) {
      return const NetworkError.unexpectedError();
    }
  }
}
