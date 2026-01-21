import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constants.dart';
import 'network_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        queryParameters: {
          'client_id': ApiConstants.key,
        },
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(NetworkInterceptor());

    // Add logger only in debug mode
    assert(() {
      dio.interceptors.add(PrettyDioLogger(requestBody: true));
      return true;
    }());
  }
}
