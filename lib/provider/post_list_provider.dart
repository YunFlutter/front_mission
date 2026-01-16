import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/model/post_model.dart';
import '../data/repository/post_repository.dart';

part 'post_list_provider.g.dart';

class PostListState {
  final List<Post> posts;
  final int page;
  final bool isLoading;
  final bool hasMore;

  PostListState({required this.posts, required this.page, required this.isLoading, required this.hasMore});

  factory PostListState.initial() => PostListState(posts: [], page: 0, isLoading: false, hasMore: true);

  PostListState copyWith({List<Post>? posts, int? page, bool? isLoading, bool? hasMore}) {
    return PostListState(
      posts: posts ?? this.posts,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

@riverpod
class PostListController extends _$PostListController {
  @override
  PostListState build() {
    // 빌드 완료 후 실행 (에러 방지)
    Future.microtask(() => _loadPosts(page: 0));
    return PostListState.initial();
  }

  Future<void> _loadPosts({required int page}) async {
    if (state.isLoading) return;
    if (page > 0 && !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final response = await ref.read(postRepositoryProvider).getPosts(page: page);

      if (page == 0) {
        state = state.copyWith(
          posts: response.posts,
          page: 0,
          isLoading: false,
          hasMore: !response.isLast,
        );
      } else {
        state = state.copyWith(
          posts: [...state.posts, ...response.posts],
          page: page,
          isLoading: false,
          hasMore: !response.isLast,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void loadNextPage() {
    if (!state.isLoading && state.hasMore) _loadPosts(page: state.page + 1);
  }

  Future<void> refresh() async {
    state = PostListState.initial();
    await _loadPosts(page: 0);
  }
}