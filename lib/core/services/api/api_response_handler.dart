import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kamao/core/core.dart';

import 'api_response.dart';

class ApiResponseHandler {
  ApiResponseHandler._();

  static Future<Either<Failure, ApiResponse<T>>> handleResponse<T>(
    Future<Response<dynamic>> Function() apiCall,
    T Function(dynamic)? fromJsonT,
  ) async {
    try {
      final response = await apiCall();

      if (response.data == null) {
        return Left(
          ServerFailure('No data received from server.', response.statusCode),
        );
      }

      final apiResponse = ApiResponse<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );

      if (apiResponse.success) {
        return Right(apiResponse);
      }

      return Left(ServerFailure(apiResponse.message, apiResponse.statusCode));
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          'Connection timeout. Please try again.',
          error.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          'No internet connection.',
          error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return UnknownFailure('Request cancelled.', error.response?.statusCode);

      // default:
      //   return UnknownFailure(
      //     error.message ?? 'Something went wrong.',
      //     error.response?.statusCode,
      //   );
      default:
        return UnknownFailure(
          error.message ?? error.error?.toString() ?? 'Something went wrong.',
          error.response?.statusCode,
        );
    }
  }

  static Failure _handleBadResponse(Response<dynamic>? response) {
    if (response == null) {
      return const ServerFailure('Unknown server error.');
    }

    final statusCode = response.statusCode ?? 0;

    String message = 'Something went wrong.';

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;

      message =
          data['message']?.toString() ??
          data['detail']?.toString() ??
          data['title']?.toString() ??
          message;
    }

    switch (statusCode) {
      case 400:
        return ValidationFailure(message, statusCode);

      case 401:
        return AuthenticationFailure(message, statusCode);

      case 403:
        return AuthenticationFailure(message, statusCode);

      case 404:
        return ServerFailure(message, statusCode);

      case 500:
      case 502:
      case 503:
        return ServerFailure(message, statusCode);

      default:
        return ServerFailure(message, statusCode);
    }
  }
}
