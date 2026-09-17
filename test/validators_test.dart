import 'package:flutter_test/flutter_test.dart';
import 'package:front_mission/core/utils/validators.dart';

void main() {
  group('Validators.validateEmail', () {
    test('빈 값이면 안내 메시지를 반환한다', () {
      expect(Validators.validateEmail(''), '이메일을 입력해주세요.');
    });

    test('잘못된 형식이면 오류 메시지를 반환한다', () {
      expect(Validators.validateEmail('invalid-email'), '올바른 이메일 형식이 아닙니다.');
    });

    test('유효한 이메일이면 null을 반환한다', () {
      expect(Validators.validateEmail('yunseo@example.com'), isNull);
    });
  });

  group('Validators.validateName', () {
    test('한 글자 이름이면 오류 메시지를 반환한다', () {
      expect(Validators.validateName('윤'), '이름은 2글자 이상이어야 합니다.');
    });

    test('두 글자 이상이면 null을 반환한다', () {
      expect(Validators.validateName('윤서'), isNull);
    });
  });

  group('Validators.validatePassword', () {
    test('필수 조건이 빠진 비밀번호면 오류 메시지를 반환한다', () {
      expect(
        Validators.validatePassword('password1'),
        '8자 이상, 영문/숫자/특수문자(!%*#?&)를 포함해야 합니다.',
      );
    });

    test('영문, 숫자, 특수문자를 포함한 8자 이상 값이면 null을 반환한다', () {
      expect(Validators.validatePassword('Password1!'), isNull);
    });
  });

  group('Validators.validateConfirmPassword', () {
    test('비밀번호가 다르면 오류 메시지를 반환한다', () {
      expect(
        Validators.validateConfirmPassword('Password2!', 'Password1!'),
        '비밀번호가 일치하지 않습니다.',
      );
    });

    test('비밀번호가 같으면 null을 반환한다', () {
      expect(
        Validators.validateConfirmPassword('Password1!', 'Password1!'),
        isNull,
      );
    });
  });
}
