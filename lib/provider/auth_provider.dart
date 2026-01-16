import 'package:front_mission/data/model/user_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repository/auth_repository.dart';
import '../data/service/local_storage_service.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  User? build() {
    return null; // 초기값: 로그아웃 상태
  }

  Future<void> login({required String username, required String password}) async {
    final storage = ref.read(localStorageServiceProvider);

    // 1. API 호출
    final tokens = await ref.read(authRepositoryProvider).login(
      username: username,
      password: password,
    );

    // 2. 토큰 추출
    final accessToken = tokens['accessToken'] as String;
    final refreshToken = tokens['refreshToken'] as String?;

    // 3. 토큰 저장
    await storage.saveAccessToken(accessToken);
    if (refreshToken != null) {
      await storage.saveRefreshToken(refreshToken);
    }

    // 4. 유저 정보 생성 (JWT 디코딩)
    String displayName = '사용자';
    int userId = 0;

    try {
      // ★ 토큰 뜯어보기
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      print("🔍 토큰 정보: $decodedToken");

      // 정보 추출 (없으면 기본값)
      if (decodedToken.containsKey('sub')) {
        // sub는 보통 아이디(이메일)
      }
      if (decodedToken.containsKey('name')) {
        displayName = decodedToken['name'];
      } else if (decodedToken.containsKey('username')) {
        displayName = decodedToken['username'];
      } else {
        // 이름 정보가 토큰에 없다면, 입력한 아이디의 앞부분(@ 앞)을 이름으로 씀
        displayName = username.split('@')[0];
      }

      if (decodedToken.containsKey('id')) {
        userId = decodedToken['id'];
      }

    } catch (e) {
      print("⚠️ 토큰 디코딩 실패: $e");
      // 실패 시 입력받은 정보로 임시 표시
      displayName = username.split('@')[0];
    }

    // 5. 상태 업데이트 (앱 전역에 로그인 정보 알림)
    state = User(
      id: userId,
      username: username, // 아이디는 사용자가 입력한 것 사용
      name: displayName,
      email: username,
    );
  }

  Future<void> logout() async {
    await ref.read(localStorageServiceProvider).deleteAllTokens();
    state = null;
  }
}