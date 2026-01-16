import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/post_list_provider.dart';
import '../common/user_info_widget.dart'; // 유저 정보 위젯 (이전 단계에서 생성함)
import 'post_write_screen.dart';

class PostListScreen extends ConsumerWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postListControllerProvider);
    final controller = ref.read(postListControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("게시판")),
      // ★ 글쓰기 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostWriteScreen()),
          );
        },
        child: const Icon(Icons.edit),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await controller.refresh(),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(16.0), child: UserInfoWidget()),
            const Divider(height: 1),
            Expanded(
              child: postState.posts.isEmpty && postState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : postState.posts.isEmpty
                  ? const Center(child: Text("게시글이 없습니다."))
                  : NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.9 &&
                      !postState.isLoading &&
                      postState.hasMore) {
                    controller.loadNextPage();
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: postState.posts.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == postState.posts.length) {
                      return postState.isLoading
                          ? const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
                          : const SizedBox(height: 50);
                    }
                    final post = postState.posts[index];
                    return Card(
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                          child: Text(post.category, style: TextStyle(fontSize: 12, color: Colors.blue[700], fontWeight: FontWeight.bold)),
                        ),
                        title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(post.createdAt.split('T')[0], style: const TextStyle(fontSize: 12)),
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