import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class User with _$User {
  // 생성자
  factory User({
    required int id,          // 사용자 고유 번호 (없으면 0 등으로 처리)
    required String username, // 아이디 (이메일)
    required String name,     // 사용자 이름 (표시 이름)
    String? email,            // 이메일 (선택)
  }) = _User;

  // JSON -> 객체 변환 메서드
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}