import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../network/dio_client.dart';

class ApiService {

  static final Dio _dio = DioClient().dio;

  final _connectivity = Connectivity();

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) return false;

    try {
      final lookup = await InternetAddress.lookup('google.com');
      return lookup.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// GET list response
  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? query,
  }) async {

    if (!await isOnline()) {
      throw 'No internet connection';
    }

    try {
      final response = await _dio.get(
        path,
        queryParameters: query,
      );

      // Only return if not null
      if (response.data == null) {
        throw 'Empty response';
      }

      return response.data;
    } on DioException catch (e) {
      throw e.error ?? 'Network error';
    } catch (e) {
      throw 'Unexpected error';
    }
  }


  /// GET single item (e.g. photos/:id)
  Future<T> getItem<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? query,
  }) async {

    if (!await isOnline()) {
      throw 'No internet connection';
    }

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
