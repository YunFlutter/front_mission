import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_detail_model.freezed.dart';
part 'post_detail_model.g.dart';

@freezed
abstract class PostDetail with _$PostDetail {
  factory PostDetail({
    required int id,
    required String title,
    required String content,
    required String boardCategory, // 목록 API랑 다르게 이름이 boardCategory임
    String? imageUrl, // 이미지가 없을 수도 있으므로 nullable
    required String createdAt,
  }) = _PostDetail;

  factory PostDetail.fromJson(Map<String, dynamic> json) => _$PostDetailFromJson(json);
}