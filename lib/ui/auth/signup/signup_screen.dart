import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import 'signup_controller.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  // 폼 상태 관리를 위한 키
  final _formKey = GlobalKey<FormState>();

  // 입력 컨트롤러
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLocked = false;
  @override
  void dispose() {
    // 메모리 누수 방지를 위해 컨트롤러 해제
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 회원가입 제출 함수
  void _onSubmit() async {

    if (_isLocked) return;

    // 1. 폼 유효성 검사 실행
    if (_formKey.currentState!.validate()) {

      setState(() {
        _isLocked = true;
      });

      // 키보드 내리기
      FocusScope.of(context).unfocus();
      bool success = false; // 성공 여부 추적 변수
      try {
         success = await ref.read(signupControllerProvider.notifier).signUp(
          username: _emailController.text,
          name: _nameController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('회원가입 성공! 로그인해주세요.')),
          );

          Navigator.pop(context);
        }
      } finally {
        // 4. 작업이 끝나면(성공하든 실패하든) 문 열어주기
        // (화면이 아직 살아있다면)
        if (mounted) {
          setState(() {
            _isLocked = false;
          });
          if (!success) {
            Future.microtask(() {
              ref.invalidate(signupControllerProvider);
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 상태 구독
    final state = ref.watch(signupControllerProvider);
    final isLoading = state.isLoading;

    // 에러 리스너: 컨트롤러에서 에러가 발생하면 스낵바 표시
    ref.listen(signupControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류 발생: 중복된 회원이거나 잘못된 회원 정보를 입력하셨습니다'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Center(
        // ★ 반응형 대응: 웹/태블릿에서 너무 넓어지지 않게 폭 제한 (500px)
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. 이메일 (Username)
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: '이메일 (ID)',
                      hintText: 'user@example.com',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // 2. 이름
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '이름',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: Validators.validateName,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // 3. 비밀번호
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: '비밀번호',
                      helperText: '8자 이상, 영문/숫자/특수문자(!%*#?&) 포함',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: Validators.validatePassword,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 24), // 헬퍼 텍스트 공간 고려

                  // 4. 비밀번호 확인
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: '비밀번호 확인',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    // 현재 입력값과 비밀번호 컨트롤러의 값을 비교
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onSubmit(), // 엔터 누르면 제출
                  ),
                  const SizedBox(height: 32),

                  // 5. 가입 버튼
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onSubmit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text(
                        '가입하기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}