import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repository/post_repository.dart';

part 'category_provider.g.dart';

@riverpod
Future<List<String>> category(Ref ref) async {
  // Repository를 통해 카테고리 목록을 가져옵니다.
  return ref.watch(postRepositoryProvider).getCategories();
}