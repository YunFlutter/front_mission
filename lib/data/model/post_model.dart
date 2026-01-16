import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class Post with _$Post {
  factory Post({
    required int id,
    required String title,
    required String category, // ★ 추가됨
    required String createdAt, // ★ 추가됨 (ISO 8601 String)
    // content, writer는 JSON에 없으므로 제거했습니다.
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}