import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';

void main() {
  group('NetworkError', () {
    test('fromException returns NetworkError from DioException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final error = NetworkError.fromException(dioError);

      expect(error, isNot(const NetworkError.unexpectedError()));
      expect(error, isNot(const NetworkError.noInternetConnection()));
    });

    test('fromException returns noInternetConnection for SocketException', () {
      final error = NetworkError.fromException(const SocketException('Failed host lookup'));
      expect(error, const NetworkError.noInternetConnection());
    });

    test('fromException returns unexpectedError for generic Exception', () {
      final error = NetworkError.fromException(Exception('Generic exception'));
      expect(error, const NetworkError.unexpectedError());
    });

    test('fromException returns formatException for FormatException', () {
      final error = NetworkError.fromException(const FormatException('Format exception'));
      expect(error, const NetworkError.formatException());
    });

    test('fromException returns unableToProcess if error string contains subtype message', () {
      final error = NetworkError.fromException('type \'int\' is not a subtype of type \'String\'');
      expect(error, const NetworkError.unableToProcess());
    });

    test('fromException returns unexpectedError for unknown error type', () {
      final error = NetworkError.fromException(12345);
      expect(error, const NetworkError.unexpectedError());
    });

    test('fromException catches errors in try-catch and returns unexpectedError', () {

      final error = NetworkError.fromException(null);
      expect(error, const NetworkError.unexpectedError());
    });
  });
}
