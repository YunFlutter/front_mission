import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repository/post_repository.dart';
import '../../provider/post_list_provider.dart';

part 'post_delete_controller.g.dart';

@riverpod
class PostDeleteController extends _$PostDeleteController {
  @override
  FutureOr<void> build() {
    // 초기 상태: 아무것도 안 함
  }

  Future<bool> deletePost(int id) async {
    state = const AsyncValue.loading(); // 로딩 시작

    state = await AsyncValue.guard(() async {
      await ref.read(postRepositoryProvider).deletePost(id);

      // ★ 삭제 성공 시 목록 새로고침 (삭제된 글이 안 보이게)
      ref.invalidate(postListControllerProvider);
    });

    return !state.hasError; // 성공 여부 반환
  }
}