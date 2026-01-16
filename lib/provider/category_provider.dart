import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repository/post_repository.dart';

part 'category_provider.g.dart';

@riverpod
// 반환 타입: Future<Map<String, String>>
Future<Map<String, String>> category(Ref ref) async {
  return ref.watch(postRepositoryProvider).getCategories();
}