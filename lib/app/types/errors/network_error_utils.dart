import 'package:dio/dio.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';

NetworkError getErrorFromDioError(DioException error) {
  final NetworkError networkExceptions;
  switch (error.type) {
    case DioExceptionType.cancel:
      return const NetworkError.requestCancelled();
    case DioExceptionType.connectionTimeout:
      return const NetworkError.requestTimeout();
    case DioExceptionType.unknown:
      if (error.toString().contains('is not a subtype of')) {
        return const NetworkError.unableToProcess();
      }
      return const NetworkError.noInternetConnection();
    case DioExceptionType.sendTimeout:
      return const NetworkError.sendTimeout();
    default:
      final errorDescription = error.response?.data?['error']?['error_description'];
      final errorType = error.response?.data?['error']?['error_type'];
      if (errorType != null && errorType == 'INFO_NOT_MATCHING') {
        return const NetworkError.infoNotMatching();
      }
      if (errorDescription != null && errorDescription is List) {
        return NetworkError.badRequestListErrors(
          (errorDescription).map((e) => e as String).toList(),
        );
      }
      networkExceptions = _checkStatusCode(error.response?.statusCode);
      break;
  }
  return networkExceptions;
}

NetworkError _checkStatusCode(int? statusCode) => switch (statusCode) {
      400 => const NetworkError.badRequest(),
      401 => const NetworkError.unauthorizedRequest(),
      403 => const NetworkError.forbidden(),
      404 => const NetworkError.notFound('Not found'),
      409 => const NetworkError.conflict(),
      408 => const NetworkError.requestTimeout(),
      500 => const NetworkError.internalServerError(),
      503 => const NetworkError.serviceUnavailable(),
      _ => NetworkError.defaultError(
          'Received invalid status code: $statusCode',
        ),
    };
