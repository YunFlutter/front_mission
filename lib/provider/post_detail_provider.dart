import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/model/post_detail_model.dart';
import '../data/repository/post_repository.dart';

part 'post_detail_provider.g.dart';

@riverpod
Future<PostDetail> postDetail(Ref ref, int postId) {
  return ref.watch(postRepositoryProvider).getPostDetail(postId);
}