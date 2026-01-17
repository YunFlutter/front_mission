import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repository/post_repository.dart';
import '../../provider/post_list_provider.dart';
import '../../provider/post_detail_provider.dart';

part 'post_edit_controller.g.dart';

@riverpod
class PostEditController extends _$PostEditController {
  @override
  FutureOr<void> build() {}

  Future<bool> updatePost({
    required int id,
    required String title,
    required String content,
    required String category,
    String? filePath,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ref.read(postRepositoryProvider).updatePost(
        id: id,
        title: title,
        content: content,
        category: category,
        filePath: filePath,
      );

      // ★ 중요: 수정 후 데이터 갱신
      // 1. 상세 페이지 캐시 갱신 (사용자가 보고 있는 화면)
      ref.invalidate(postDetailProvider(id));
      // 2. 목록 페이지 갱신 (목록으로 돌아갔을 때 반영되도록)
      ref.invalidate(postListControllerProvider);
    });

    return !state.hasError;
  }
}