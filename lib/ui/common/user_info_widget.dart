import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_mission/ui/auth/login/login_screen.dart';
import '../../provider/auth_provider.dart';

class UserInfoWidget extends ConsumerWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. AuthProvider를 구독 (로그인 정보가 바뀌면 자동으로 UI 갱신)
    final user = ref.watch(authProvider);

    // 2. 로그인 정보가 없을 때 (비로그인 상태) 처리
    if (user == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("로그인 정보가 없습니다."),
        ),
      );
    }

    // 3. 로그인 정보 표시 (카드 형태)
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // 프로필 아이콘 (이름의 첫 글자 표시)
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.indigo.shade100,
              child: Text(
                user.name.isNotEmpty ? user.name[0] : '?',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 이름 및 아이디 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name, // 이름
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.username, // 아이디 (이메일)
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // 로그아웃 버튼 (편의 기능)
            IconButton(
              onPressed: () {
                // 로그아웃 다이얼로그
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("로그아웃"),
                    content: const Text("정말 로그아웃 하시겠습니까?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("취소"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 다이얼로그 닫기
                          ref.read(authProvider.notifier).logout(); // 로그아웃 로직

                          // 로그인 화면으로 이동 (모든 스택 제거)
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                                (route) => false,
                          );
                        },
                        child: const Text("로그아웃", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.grey),
              tooltip: '로그아웃',
            ),
          ],
        ),
      ),
    );
  }
}