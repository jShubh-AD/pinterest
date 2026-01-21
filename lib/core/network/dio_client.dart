import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_constants.dart';

class DioClient {
  late final Dio dio;

  DioClient(){
    dio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        contentType: 'application/json'
    ));

    // Add logger only in debug mode
    assert(() {
      dio.interceptors.add(PrettyDioLogger(requestBody: true));
      return true;
    }());

  }

}