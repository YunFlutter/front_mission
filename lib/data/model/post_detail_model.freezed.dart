// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostDetail {

 int get id; String get title; String get content; String get boardCategory;// 목록 API랑 다르게 이름이 boardCategory임
 String? get imageUrl;// 이미지가 없을 수도 있으므로 nullable
 String get createdAt;
/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDetailCopyWith<PostDetail> get copyWith => _$PostDetailCopyWithImpl<PostDetail>(this as PostDetail, _$identity);

  /// Serializes this PostDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.boardCategory, boardCategory) || other.boardCategory == boardCategory)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,boardCategory,imageUrl,createdAt);

@override
String toString() {
  return 'PostDetail(id: $id, title: $title, content: $content, boardCategory: $boardCategory, imageUrl: $imageUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PostDetailCopyWith<$Res>  {
  factory $PostDetailCopyWith(PostDetail value, $Res Function(PostDetail) _then) = _$PostDetailCopyWithImpl;
@useResult
$Res call({
 int id, String title, String content, String boardCategory, String? imageUrl, String createdAt
});




}
/// @nodoc
class _$PostDetailCopyWithImpl<$Res>
    implements $PostDetailCopyWith<$Res> {
  _$PostDetailCopyWithImpl(this._self, this._then);

  final PostDetail _self;
  final $Res Function(PostDetail) _then;

/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? boardCategory = null,Object? imageUrl = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,boardCategory: null == boardCategory ? _self.boardCategory : boardCategory // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PostDetail].
extension PostDetailPatterns on PostDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostDetail value)  $default,){
final _that = this;
switch (_that) {
case _PostDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String content,  String boardCategory,  String? imageUrl,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.boardCategory,_that.imageUrl,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String content,  String boardCategory,  String? imageUrl,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _PostDetail():
return $default(_that.id,_that.title,_that.content,_that.boardCategory,_that.imageUrl,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String content,  String boardCategory,  String? imageUrl,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.boardCategory,_that.imageUrl,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostDetail implements PostDetail {
   _PostDetail({required this.id, required this.title, required this.content, required this.boardCategory, this.imageUrl, required this.createdAt});
  factory _PostDetail.fromJson(Map<String, dynamic> json) => _$PostDetailFromJson(json);

@override final  int id;
@override final  String title;
@override final  String content;
@override final  String boardCategory;
// 목록 API랑 다르게 이름이 boardCategory임
@override final  String? imageUrl;
// 이미지가 없을 수도 있으므로 nullable
@override final  String createdAt;

/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostDetailCopyWith<_PostDetail> get copyWith => __$PostDetailCopyWithImpl<_PostDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.boardCategory, boardCategory) || other.boardCategory == boardCategory)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,boardCategory,imageUrl,createdAt);

@override
String toString() {
  return 'PostDetail(id: $id, title: $title, content: $content, boardCategory: $boardCategory, imageUrl: $imageUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PostDetailCopyWith<$Res> implements $PostDetailCopyWith<$Res> {
  factory _$PostDetailCopyWith(_PostDetail value, $Res Function(_PostDetail) _then) = __$PostDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String content, String boardCategory, String? imageUrl, String createdAt
});




}
/// @nodoc
class __$PostDetailCopyWithImpl<$Res>
    implements _$PostDetailCopyWith<$Res> {
  __$PostDetailCopyWithImpl(this._self, this._then);

  final _PostDetail _self;
  final $Res Function(_PostDetail) _then;

/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? boardCategory = null,Object? imageUrl = freezed,Object? createdAt = null,}) {
  return _then(_PostDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,boardCategory: null == boardCategory ? _self.boardCategory : boardCategory // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
