import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repository/auth_repository.dart';

part 'signup_controller.g.dart';

@riverpod
class SignupController extends _$SignupController {
  @override
  FutureOr<void> build() {
    // 초기 상태
  }

  Future<bool> signUp({
    required String username,
    required String name,
    required String password,
    required String confirmPassword, // ★ 추가됨
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // 리포지토리 호출 시 confirmPassword 전달
      await ref.read(authRepositoryProvider).signUp(
        username: username,
        name: name,
        password: password,
        confirmPassword: confirmPassword, // ★ 추가됨
      );
    });

    return !state.hasError;
  }
}