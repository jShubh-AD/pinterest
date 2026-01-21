import 'package:dio/dio.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;

    switch (err.type) {
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        message = 'Request timed out. Please try again';
        break;

      case DioExceptionType.badResponse:
        final status = err.response?.statusCode;
        if (status == 429) {
          message = 'Rate limit exceeded. Try again later';
        } else if (status != null && status >= 500) {
          message = 'Server error. Please try later';
        } else {
          message = 'Something went wrong';
        }
        break;

      default:
        message = 'Unexpected error occurred';
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: message,
        type: err.type,
      ),
    );
  }
}
