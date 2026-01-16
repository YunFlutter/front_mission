import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_provider.dart';
import '../model/post_model.dart';

part 'post_repository.g.dart';

@riverpod
PostRepository postRepository(Ref ref) {
  return PostRepository(ref.watch(dioProvider));
}

// 반환값을 위한 임시 클래스 (Record를 써도 되지만 명시적으로 작성)
class PostPageResponse {
  final List<Post> posts;
  final bool isLast;

  PostPageResponse({required this.posts, required this.isLast});
}

class PostRepository {
  final Dio _dio;

  PostRepository(this._dio);

  Future<PostPageResponse> getPosts({required int page, int size = 10}) async {
    try {
      final response = await _dio.get(
        '/boards',
        queryParameters: {
          'page': page,
          'size': size,
          'sort': 'createdAt,desc', // (선택) 최신순 정렬 필요 시
        },
      );

      final data = response.data;

      // 1. 데이터 리스트 파싱 ('content' 필드)
      final content = data['content'] as List;
      final posts = content.map((e) => Post.fromJson(e)).toList();

      // 2. 마지막 페이지 여부 파싱 ('last' 필드)
      final isLast = data['last'] as bool;

      return PostPageResponse(posts: posts, isLast: isLast);

    } catch (e) {
      print("🚨 게시글 조회 실패: $e");
      rethrow;
    }
  }
}