class Validators {
  // 이메일 정규식
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  // 비밀번호 정규식: 8자 이상, 영문, 숫자, 특수문자(!%*#?&) 포함
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!%*#?&])[A-Za-z\d!%*#?&]{8,}$',
  );

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return '이메일을 입력해주세요.';
    if (!_emailRegExp.hasMatch(value)) return '올바른 이메일 형식이 아닙니다.';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return '이름을 입력해주세요.';
    if (value.length < 2) return '이름은 2글자 이상이어야 합니다.';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return '비밀번호를 입력해주세요.';
    if (!_passwordRegExp.hasMatch(value)) {
      return '8자 이상, 영문/숫자/특수문자(!%*#?&)를 포함해야 합니다.';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return '비밀번호 확인을 입력해주세요.';
    if (value != password) return '비밀번호가 일치하지 않습니다.';
    return null;
  }
}