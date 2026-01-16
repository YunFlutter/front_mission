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
        final publicPaths = [
          '/auth/signin',
          '/auth/signup',
        ];

        // 현재 요청하는 경로가 publicPaths에 포함되어 있는지 확인
        // (path에 '/auth/signin' 문자열이 포함되어 있으면 true)
        final isPublicRequest = publicPaths.any((path) => options.path.contains(path));

        // ★ [수정됨] Public 요청이 아닐 때만 토큰을 넣음
        if (!isPublicRequest) {
          final token = await storage.getAccessToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print('🔐 [토큰 탑재] ${options.path}'); // 디버깅용
          }
        } else {
          print('🔓 [토큰 미탑재] ${options.path}'); // 디버깅용
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