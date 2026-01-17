import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_mission/provider/post_delete_controller.dart';
import 'package:front_mission/ui/post/post_edit_screen.dart';
import '../../core/config/app_config.dart'; // Base URL 가져오기 위해 필요
import '../../provider/post_detail_provider.dart';

class PostDetailScreen extends ConsumerWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // ★ 삭제 확인 팝업 함수
    void _confirmDelete(BuildContext context, WidgetRef ref) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("글 삭제"),
          content: const Text("정말로 이 게시글을 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // 취소
              child: const Text("취소", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // 팝업 닫기

                // 삭제 요청 실행
                final success = await ref.read(postDeleteControllerProvider.notifier).deletePost(postId);

                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("게시글이 삭제되었습니다.")),
                  );
                  Navigator.pop(context); // 상세 페이지 닫기 (목록으로 이동)
                }
              },
              child: const Text("삭제", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }


    // ID를 기반으로 데이터 구독
    final detailAsync = ref.watch(postDetailProvider(postId));
    final deleteState = ref.watch(postDeleteControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("게시글 상세"),
        actions: [
          // 데이터가 로드된 상태일 때만 수정 버튼 표시
          detailAsync.when(
            data: (post) => Row(
              children: [
                // ✏️ 수정 버튼
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: deleteState.isLoading
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PostEditScreen(post: post)),
                    );
                  },
                ),
                // 🗑️ 삭제 버튼 (NEW)
                IconButton(
                  icon: deleteState.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.delete, color: Colors.red),
                  onPressed: deleteState.isLoading
                      ? null
                      : () => _confirmDelete(context, ref),
                ),
              ],
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
      body: detailAsync.when(
        // 1. 로딩 중
        loading: () => const Center(child: CircularProgressIndicator()),

        // 2. 에러 발생
        error: (err, stack) => Center(child: Text('불러오기 실패: $err')),

        // 3. 데이터 로드 완료
        data: (post) {
          // 날짜 포맷팅
          final dateStr = post.createdAt.split('T')[0];

          // 이미지 URL 처리 (상대 경로인 경우 Base URL 붙이기)
          String? fullImageUrl;
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
            if (post.imageUrl!.startsWith('http')) {
              fullImageUrl = post.imageUrl;
            } else {
              fullImageUrl = '${AppConfig.baseUrl}${post.imageUrl}';
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리 배지
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    post.boardCategory,
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 제목
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // 날짜 및 작성자 정보(있다면)
                Text(
                  dateStr,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                const Divider(height: 30, thickness: 1),

                // 이미지 (있을 경우에만 표시)
                if (fullImageUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      fullImageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: const Text("이미지를 불러올 수 없습니다."),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // 본문 내용
                Text(
                  post.content,
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
