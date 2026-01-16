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
        try {
          // 토큰이 필요 없는 경로 정의
          final publicPaths = ['/auth/signin', '/auth/signup', '/auth/refresh'];
          final isPublicRequest = publicPaths.any((path) => options.path.contains(path));

          if (!isPublicRequest) {
            final token = await storage.getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              print('🔐 [토큰 탑재] ${options.path}');
            }
          } else {
            print('🔓 [토큰 미탑재] ${options.path} (Public API)');
          }

          print('🌐 REQ [${options.method}] ${options.path}');
          return handler.next(options);

        } catch (e) {
          print('🔥 [요청 준비 실패] $e');
          return handler.reject(DioException(requestOptions: options, error: e));
        }
      },
      onResponse: (response, handler) {
        print('✅ RES [${response.statusCode}] ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        print('❌ ERR [${e.response?.statusCode}] ${e.message} (${e.requestOptions.path})');

        final isStatus401 = e.response?.statusCode == 401;
        final isPathRefresh = e.requestOptions.path.contains('/auth/refresh');

        if (isStatus401 && !isPathRefresh) {
          print('🔄 [Token Refresh] 토큰 만료! 갱신을 시도합니다...');

          try {
            final refreshToken = await storage.getRefreshToken();
            if (refreshToken == null) {
              await storage.deleteAllTokens();
              return handler.next(e);
            }

            // 1. 토큰 갱신
            final refreshDio = Dio(BaseOptions(
              baseUrl: AppConfig.baseUrl,
              headers: {'Content-Type': 'application/json'},
            ));

            final refreshResponse = await refreshDio.post(
              '/auth/refresh',
              data: {'refreshToken': refreshToken},
            );

            final newAccessToken = refreshResponse.data['accessToken'];

            if (newAccessToken != null) {
              await storage.saveAccessToken(newAccessToken);
              print('✅ [Refresh] Access Token 갱신 성공!');

              // 2. 재요청 준비
              final originalRequest = e.requestOptions;
              originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';

              // ★ [핵심 수정] FormData 재사용 문제 해결 ★
              // 데이터가 FormData(파일 업로드)라면, 새것으로 복제해야 함
              if (originalRequest.data is FormData) {
                print('📦 [Retry] FormData 재생성 중...');
                final oldFormData = originalRequest.data as FormData;
                final newFormData = FormData();

                // (1) 텍스트 필드 복사
                newFormData.fields.addAll(oldFormData.fields);

                // (2) 파일 필드 복제 (핵심: 파일 스트림을 새로 엽니다)
                for (final file in oldFormData.files) {
                  newFormData.files.add(MapEntry(
                    file.key,
                    file.value.clone(), // .clone() 메서드가 스트림을 리셋해줍니다.
                  ));
                }

                // 교체!
                originalRequest.data = newFormData;
              }

              // 3. 재요청 전송
              final clonedRequest = await dio.fetch(originalRequest);
              return handler.resolve(clonedRequest);
            }
          } catch (refreshError) {
            print('🚨 [Refresh] 실패: $refreshError');
            await storage.deleteAllTokens();
          }
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
}