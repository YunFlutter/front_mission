import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_mission/provider/post_edit_controller.dart';
import '../../core/config/app_config.dart';
import '../../core/utils/file_compressor.dart'; // ★ 압축 유틸 임포트
import '../../data/model/post_detail_model.dart';
import '../../provider/category_provider.dart';

class PostEditScreen extends ConsumerStatefulWidget {
  final PostDetail post;

  const PostEditScreen({super.key, required this.post});

  @override
  ConsumerState<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends ConsumerState<PostEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  String? _selectedCategoryKey;

  String? _newFilePath;
  String? _newFileName;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
    _selectedCategoryKey = widget.post.boardCategory;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // ★ [수정됨] 파일 선택 + 압축 로직 적용
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        // 1. 원본 파일 가져오기
        final rawFile = File(result.files.single.path!);

        // (선택) 처리 중임을 알림
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('파일 용량을 확인하고 있습니다...'),
              duration: Duration(seconds: 1),
            ),
          );
        }

        // 2. 압축 및 용량 체크 실행 (1MB 제한)
        final validFile = await FileCompressor.compressIfNeeded(rawFile);

        // 3. 통과 시 상태 업데이트
        setState(() {
          _newFilePath = validFile.path; // 압축된 경로
          _newFileName = result.files.single.name; // 이름 표시
        });
      }
    } catch (e) {
      // 4. 용량 초과 또는 압축 실패 시 에러 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("1MB 초과한 파일은 첨부 할 수 없습니다"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearNewFile() {
    setState(() {
      _newFilePath = null;
      _newFileName = null;
    });
  }

  // ... (나머지 _onSubmit 및 build 코드는 기존과 동일하므로 유지) ...

  void _onSubmit() async {
    // ... 기존 코드 그대로 ...
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('제목과 내용을 입력해주세요.')));
      return;
    }

    FocusScope.of(context).unfocus();

    final success = await ref.read(postEditControllerProvider.notifier).updatePost(
      id: widget.post.id,
      title: _titleController.text,
      content: _contentController.text,
      category: _selectedCategoryKey ?? widget.post.boardCategory,
      filePath: _newFilePath,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('게시글이 수정되었습니다!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... 기존 build 코드 그대로 ...
    // (이전 단계에서 작성한 UI 코드 전체 유지)
    final state = ref.watch(postEditControllerProvider);
    final categoryAsyncValue = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("게시글 수정"),
        actions: [
          TextButton(
            onPressed: state.isLoading ? null : _onSubmit,
            child: Text("수정", style: TextStyle(color: state.isLoading ? Colors.grey : Colors.blue, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 카테고리
            categoryAsyncValue.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text("카테고리 로드 실패"),
              data: (categoriesMap) {
                return DropdownButtonFormField<String>(
                  value: _selectedCategoryKey,
                  decoration: const InputDecoration(labelText: '카테고리', border: OutlineInputBorder()),
                  items: categoriesMap.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                  onChanged: (val) => setState(() => _selectedCategoryKey = val),
                );
              },
            ),
            const SizedBox(height: 16),

            // 제목
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '제목', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            // 내용
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: const InputDecoration(labelText: '내용', border: OutlineInputBorder(), alignLabelWithHint: true),
            ),
            const SizedBox(height: 24),

            // --- 파일 첨부 영역 ---
            const Text("첨부 파일", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            // Case 1: 새로 파일을 선택한 경우
            if (_newFilePath != null)
              Card(
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const Icon(Icons.new_releases, color: Colors.blue),
                  title: Text(_newFileName ?? "새 파일"),
                  subtitle: const Text("새로 선택된 파일"),
                  trailing: IconButton(onPressed: _clearNewFile, icon: const Icon(Icons.close, color: Colors.red)),
                ),
              )
            // Case 2: 기존 이미지가 있는 경우
            else if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty)
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.image, color: Colors.grey),
                      title: const Text("기존 첨부 파일"),
                      subtitle: const Text("변경하려면 아래 버튼을 누르세요"),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                      child: Image.network(
                        widget.post.imageUrl!.startsWith('http')
                            ? widget.post.imageUrl!
                            : '${AppConfig.baseUrl}${widget.post.imageUrl}',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // 파일 선택 버튼
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(_newFilePath == null ? "파일 변경 / 선택" : "다른 파일로 변경"),
              ),
            ),

            if (state.isLoading)
              const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator())),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}