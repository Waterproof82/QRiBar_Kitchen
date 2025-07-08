import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/errors/network_error_utils.dart';

void main() {
  group('getErrorFromDioError', () {
    test('returns requestCancelled for DioExceptionType.cancel', () {
      final error = DioException(
        type: DioExceptionType.cancel,
        requestOptions: RequestOptions(),
      );
      final result = getErrorFromDioError(error);
      expect(result, const NetworkError.requestCancelled());
    });

    test('returns requestTimeout for DioExceptionType.connectionTimeout', () {
      final error = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(),
      );
      final result = getErrorFromDioError(error);
      expect(result, const NetworkError.requestTimeout());
    });

    test('returns unableToProcess when unknown type contains subtype error', () {
      final error = DioException(
        requestOptions: RequestOptions(),
        error: 'type \'int\' is not a subtype of type \'String\'',
      );
      final result = getErrorFromDioError(error);
      expect(result, const NetworkError.unableToProcess());
    });

    test('returns noInternetConnection when unknown type without subtype error', () {
      final error = DioException(
        requestOptions: RequestOptions(),
        error: 'Some other error message',
      );
      final result = getErrorFromDioError(error);
      expect(result, const NetworkError.noInternetConnection());
    });

    test('returns sendTimeout for DioExceptionType.sendTimeout', () {
      final error = DioException(
        type: DioExceptionType.sendTimeout,
        requestOptions: RequestOptions(),
      );
      final result = getErrorFromDioError(error);
      expect(result, const NetworkError.sendTimeout());
    });

    test('returns infoNotMatching when errorType is INFO_NOT_MATCHING', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(),
          data: {
            'error': {'error_type': 'INFO_NOT_MATCHING'}
          },
        ),
      );
      final result = getErrorFromDioError(error);
      expect(result, const NetworkError.infoNotMatching());
    });

    test('returns badRequestListErrors when errorDescription is list of strings', () {
      final errorDescription = ['error1', 'error2'];
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(),
          data: {
            'error': {'error_description': errorDescription}
          },
        ),
      );
      final result = getErrorFromDioError(error);
      expect(result, isA<NetworkError>());
      result.whenOrNull(
        badRequestListErrors: (listErrors) {
          expect(listErrors, errorDescription);
        },
      );
    });

    test('returns correct NetworkError based on statusCode', () {
      final codes = {
        400: const NetworkError.badRequest(),
        401: const NetworkError.unauthorizedRequest(),
        403: const NetworkError.forbidden(),
        404: const NetworkError.notFound('Not found'),
        409: const NetworkError.conflict(),
        408: const NetworkError.requestTimeout(),
        500: const NetworkError.internalServerError(),
        503: const NetworkError.serviceUnavailable(),
        999: const NetworkError.defaultError('Received invalid status code: 999'),
        null: const NetworkError.defaultError('Received invalid status code: null'),
      };

      for (final entry in codes.entries) {
        final error = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: entry.key,
            requestOptions: RequestOptions(),
          ),
        );
        final result = getErrorFromDioError(error);
        expect(result, entry.value);
      }
    });
  });
}
