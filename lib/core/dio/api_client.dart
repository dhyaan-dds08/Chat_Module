import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  bool _headersInitialized = false;

  factory ApiClient() {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _initializeHeaders();

    if (kDebugMode && !_isInTestMode()) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (log) => debugPrint(log.toString()),
        ),
      );
    }
  }

  bool _isInTestMode() {
    return Platform.environment.containsKey('FLUTTER_TEST');
  }

  Future<void> _initializeHeaders() async {
    if (_headersInitialized) return;

    try {
      final packageInfo = await PackageInfo.fromPlatform();

      _dio.options.headers.addAll({
        'X-App-Name': packageInfo.appName,
        'X-App-Version': packageInfo.version,
        'X-Build-Number': packageInfo.buildNumber,
        'X-Platform': Platform.operatingSystem,
      });

      _headersInitialized = true;
    } catch (e) {
      if (kDebugMode && !_isInTestMode()) {
        debugPrint('Failed to initialize app headers: $e');
      }
      _headersInitialized = true;
    }
  }

  static Future<Dio> getApiClient() async {
    final instance = ApiClient();
    await instance._initializeHeaders();
    return instance._dio;
  }

  Dio get dio => _dio;

  static void reset() {
    _instance = null;
  }
}
