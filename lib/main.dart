import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/service/api_service.dart';
import 'core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'core/router/app_router.dart';


final dioProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('saved_pins');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,          // background
      statusBarIconBrightness: Brightness.dark, // Android icons
      statusBarBrightness: Brightness.light, // iOS
    ),
  );

  runApp(const ProviderScope(child: PinterestApp()));
}

class PinterestApp extends StatelessWidget {
  const PinterestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,

        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.red,
          selectionColor: Colors.red.shade400,
          selectionHandleColor: Colors.red.shade400,
        ),

        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.black,
          background: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      routerConfig:  appRouter,
    );
  }
}