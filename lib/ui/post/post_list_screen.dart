import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/post_list_provider.dart';
import '../common/user_info_widget.dart'; // 공용 유저 정보 위젯

class PostListScreen extends ConsumerWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태와 컨트롤러 가져오기
    final postState = ref.watch(postListControllerProvider);
    final controller = ref.read(postListControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("게시판"),
        elevation: 0,
      ),
      // 당겨서 새로고침
      body: RefreshIndicator(
        onRefresh: () async => await controller.refresh(),
        child: Column(
          children: [
            // 1. 상단 유저 정보 (로그인한 사용자 표시)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: UserInfoWidget(),
            ),
            const Divider(height: 1, thickness: 1),

            // 2. 게시글 리스트 영역
            Expanded(
              child: postState.posts.isEmpty && postState.isLoading
                  ? const Center(child: CircularProgressIndicator()) // 최초 로딩
                  : postState.posts.isEmpty
                  ? const Center(child: Text("등록된 게시글이 없습니다."))
                  : NotificationListener<ScrollNotification>(
                // ★ 스크롤 감지 로직 (핵심)
                onNotification: (ScrollNotification scrollInfo) {
                  // 스크롤이 90% 이상 내려갔고, 로딩 중이 아니고, 더 볼 페이지가 있다면
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent * 0.9 &&
                      !postState.isLoading &&
                      postState.hasMore) {
                    controller.loadNextPage();
                  }
                  return false; // 이벤트 전파 중단하지 않음
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  // 리스트 아이템 + 바닥 로딩 인디케이터(1개)
                  itemCount: postState.posts.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    // 마지막 아이템: 다음 페이지 로딩 중일 때만 인디케이터 표시
                    if (index == postState.posts.length) {
                      return postState.isLoading
                          ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : const SizedBox(height: 50); // 바닥 여백
                    }

                    // 실제 데이터 아이템
                    final post = postState.posts[index];

                    // 날짜 문자열 자르기 (2024-11-11...)
                    final dateStr = post.createdAt.length >= 10
                        ? post.createdAt.substring(0, 10)
                        : post.createdAt;

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: InkWell(
                        onTap: () {
                          // TODO: 게시글 상세 페이지 이동
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 카테고리 배지
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  post.category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // 제목
                              Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),

                              // 날짜
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  dateStr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}