import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repository/post_repository.dart';
import '../../provider/post_list_provider.dart'; // 목록 갱신을 위해 필요

part 'post_write_controller.g.dart';

@riverpod
class PostWriteController extends _$PostWriteController {
  @override
  FutureOr<void> build() {
    // 초기 상태
  }

  Future<bool> createPost({
    required String title,
    required String content,
    required String category,
    String? filePath,
  }) async {
    state = const AsyncValue.loading(); // 로딩 시작

    state = await AsyncValue.guard(() async {
      await ref.read(postRepositoryProvider).createPost(
        title: title,
        content: content,
        category: category,
        filePath: filePath,
      );

      // 작성 성공 시 목록 컨트롤러를 초기화하여, 목록 화면으로 돌아갔을 때 새 글이 보이게 함
      ref.invalidate(postListControllerProvider);
    });

    return !state.hasError; // 성공 여부 반환
  }
}