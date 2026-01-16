import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_mission/ui/auth/signup_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Front Mission', // 앱 이름
      debugShowCheckedModeBanner: false, // 오른쪽 위 'Debug' 띠 제거
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // 아직 홈 화면을 안 만들었으므로 임시 페이지 연결
      home: SignupScreen()
    );
  }
}