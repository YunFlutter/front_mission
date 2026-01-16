import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'local_storage_service.g.dart';

@Riverpod(keepAlive: true)
LocalStorageService localStorageService(Ref ref) {
  return LocalStorageService();
}

 class LocalStorageService {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'ACCESS_TOKEN';

  // 토큰 저장
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // 토큰 읽기
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // 토큰 삭제
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}