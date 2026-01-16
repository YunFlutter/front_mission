import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/service/local_storage_service.dart'; // ★ 저장소 서비스 임포트 필수
import 'package:front_mission/core/config/app_config.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  // 1. 기본 설정
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

  // 2. 저장소 서비스 구독 (토큰 꺼내기 위해)
  final storage = ref.watch(localStorageServiceProvider);

  // 3. 인터셉터 설정
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async { // ★ async 필수
        // (1) 저장소에서 토큰 꺼내기
        final token = await storage.getAccessToken();


        // (3) 헤더에 토큰 탑재 (Bearer 방식)
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

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