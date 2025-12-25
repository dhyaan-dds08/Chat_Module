import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;

  factory ApiClient() {
    return _instance;
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

    if (kDebugMode) {
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

  Future<void> _initializeHeaders() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      _dio.options.headers.addAll({
        'X-App-Name': packageInfo.appName,
        'X-App-Version': packageInfo.version,
        'X-Build-Number': packageInfo.buildNumber,
        'X-Platform': Platform.operatingSystem,
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to initialize app headers: $e');
    }
  }

  static Future<Dio> getApiClient() async {
    final instance = ApiClient();
    await instance._initializeHeaders();
    return instance._dio;
  }

  Dio get dio => _dio;
}
