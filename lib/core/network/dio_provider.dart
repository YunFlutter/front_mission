import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// AppConfig가 있는 파일 import (경로는 실제 위치에 맞게 수정해주세요)
import 'package:front_mission/core/config/app_config.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  // 1. AppConfig의 static 변수들을 바로 할당
  final options = BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: AppConfig.connectTimeout,
    receiveTimeout: AppConfig.receiveTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final dio = Dio(options);

  // 2. 디버깅을 위한 인터셉터 (로그 출력)
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🌐 REQ [${options.method}] ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ RES [${response.statusCode}] ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('❌ ERR [${e.response?.statusCode}] ${e.message}');
        return handler.next(e);
      },
    ),
  );

  return dio;
}