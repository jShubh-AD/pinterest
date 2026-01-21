import 'package:dio/dio.dart';

import 'dio_client.dart';

class ApiService {

  static final Dio _dio = DioClient().dio;

  /// GET list response
  Future<List<T>> getList<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: query,
      );

      if (response.data is! List) {
        throw 'Invalid response format';
      }

      return (response.data as List)
          .map((e) => fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw e.error ?? 'Network error';
    } catch (_) {
      throw 'Unexpected error';
    }
  }

  /// GET single item (e.g. photos/:id)
  Future<T> getItem<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: query,
      );

      if (response.data is! Map<String, dynamic>) {
        throw 'Invalid response format';
      }

      return fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error ?? 'Network error';
    } catch (_) {
      throw 'Unexpected error';
    }
  }



}
