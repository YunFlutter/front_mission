import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_provider.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(dioProvider));
}

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<void> signUp({
    required String username,
    required String name,
    required String password,
    required String confirmPassword, // ★ 추가됨
  }) async {
    // API 명세에 맞춰 confirmPassword도 전송
    await _dio.post('/auth/signup', data: {
      'username': username,
      'name': name,
      'password': password,
      'confirmPassword': confirmPassword, // ★ 추가됨
    });
  }
}