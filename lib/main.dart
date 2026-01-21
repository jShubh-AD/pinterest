import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/network/api_service.dart';
import 'core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'core/router/app_router.dart';


final dioProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});


void main() {
  runApp(const ProviderScope(child: PinterestApp()));
}

class PinterestApp extends StatelessWidget {
  const PinterestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig:  appRouter,
    );
  }
}