// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostDetail _$PostDetailFromJson(Map<String, dynamic> json) => _PostDetail(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String,
  boardCategory: json['boardCategory'] as String,
  imageUrl: json['imageUrl'] as String?,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$PostDetailToJson(_PostDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'boardCategory': instance.boardCategory,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt,
    };
