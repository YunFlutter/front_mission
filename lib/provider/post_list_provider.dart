import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/model/post_model.dart';
import '../data/repository/post_repository.dart';

part 'post_list_provider.g.dart';

// 상태 클래스: 화면에 필요한 모든 데이터를 가집니다.
class PostListState {
  final List<Post> posts;
  final int page;
  final bool isLoading;
  final bool hasMore; // 다음 페이지가 있는지 여부 (API 'last' 필드 기반)

  PostListState({
    required this.posts,
    required this.page,
    required this.isLoading,
    required this.hasMore,
  });

  // 초기 상태
  factory PostListState.initial() {
    return PostListState(posts: [], page: 0, isLoading: false, hasMore: true);
  }

  // 상태 복사 및 수정 (copyWith)
  PostListState copyWith({
    List<Post>? posts,
    int? page,
    bool? isLoading,
    bool? hasMore,
  }) {
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
    // 컨트롤러가 생성되자마자 첫 페이지 로드
    Future.microtask(() => _loadPosts(page: 0));
    return PostListState.initial();
  }

  // 내부 로딩 함수
  Future<void> _loadPosts({required int page}) async {
    // 이미 로딩 중이거나, 더 이상 데이터가 없는데(첫 페이지 제외) 요청하면 무시
    if (state.isLoading) return;
    if (page > 0 && !state.hasMore) return;

    // 로딩 시작
    state = state.copyWith(isLoading: true);

    try {
      // 리포지토리 호출 (page, size는 기본값 10)
      final response = await ref.read(postRepositoryProvider).getPosts(page: page);

      if (page == 0) {
        // 첫 페이지: 리스트 덮어쓰기
        state = state.copyWith(
          posts: response.posts,
          page: 0,
          isLoading: false,
          hasMore: !response.isLast, // 'last'가 true면 hasMore는 false
        );
      } else {
        // 다음 페이지: 기존 리스트 뒤에 이어 붙이기
        state = state.copyWith(
          posts: [...state.posts, ...response.posts],
          page: page,
          isLoading: false,
          hasMore: !response.isLast,
        );
      }
    } catch (e) {
      // 에러 발생 시 로딩만 끔 (실무에선 에러 상태도 관리 필요)
      state = state.copyWith(isLoading: false);
      print("🚨 데이터 로드 실패: $e");
    }
  }

  // UI에서 호출: 다음 페이지 불러오기 (스크롤 바닥 감지 시)
  void loadNextPage() {
    if (state.isLoading || !state.hasMore) return;
    _loadPosts(page: state.page + 1);
  }

  // UI에서 호출: 새로고침 (Pull to Refresh)
  Future<void> refresh() async {
    // 상태를 초기화하고 첫 페이지 다시 로드
    state = PostListState.initial();
    await _loadPosts(page: 0);
  }
}