import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_provider.dart';
import '../model/post_model.dart';

part 'post_repository.g.dart';

@riverpod
PostRepository postRepository(Ref ref) {
  return PostRepository(ref.watch(dioProvider));
}

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


  Future<void> createPost({
    required String title,
    required String content,
    required String category,
    String? filePath, // 파일 경로 (선택)
  }) async {
    // JSON 데이터 준비
    final jsonMap = {
      'title': title,
      'content': content,
      'category': category,
    };
    final jsonString = jsonEncode(jsonMap);

    // FormData 생성
    final formData = FormData.fromMap({
      // request 부분: JSON을 문자열로 보내되, Content-Type을 application/json으로 명시
      'request': MultipartFile.fromString(
        jsonString,
        contentType: MediaType.parse('application/json'),
      ),
    });

    // 파일이 있다면 file 부분에 추가
    if (filePath != null) {
      formData.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      ));
    }

    await _dio.post('/boards', data: formData);
  }


  // ★ 카테고리 조회 추가
  Future<Map<String, String>> getCategories() async {
    try {
      final response = await _dio.get('/boards/categories');


      return Map<String, String>.from(response.data);
    } catch (e) {
      print("🚨 카테고리 로드 실패: $e");
      // 실패 시 기본값이라도 반환 (앱이 죽지 않도록 방어 코드)
      return {
        "NOTICE": "공지(기본)",
        "FREE": "자유(기본)"
      };
    }
  }
}