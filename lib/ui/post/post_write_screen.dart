import 'dart:io';

import 'package:file_picker/file_picker.dart'; // 파일 선택용
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_mission/core/utils/file_compressor.dart';
// import 'package:image_picker/image_picker.dart'; // 삭제됨

import '../../provider/category_provider.dart';
import 'post_write_controller.dart';

class PostWriteScreen extends ConsumerStatefulWidget {
  const PostWriteScreen({super.key});

  @override
  ConsumerState<PostWriteScreen> createState() => _PostWriteScreenState();
}

class _PostWriteScreenState extends ConsumerState<PostWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  // 카테고리 Key (서버 전송용)
  String? _selectedCategoryKey;

  // 파일 관련 변수 (이미지 여부 플래그 삭제됨)
  String? _selectedFilePath;
  String? _selectedFileName;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // ▶️ 파일 탐색기에서 파일 선택 (단일 기능으로 통합)
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        final rawFile = File(result.files.single.path!);

        // ★ 로딩 표시 등을 보여주면 좋음 (선택 사항)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('파일 용량을 확인하고 있습니다...'), duration: Duration(seconds: 1)),
        );

        // ★ 압축 및 용량 체크 실행
        final validFile = await FileCompressor.compressIfNeeded(rawFile);

        setState(() {
          _selectedFilePath = validFile.path; // 압축된 경로 사용
          _selectedFileName = result.files.single.name; // 이름은 원본 유지 (혹은 변경 가능)
        });
      }
    } catch (e) {
      // ★ 1MB 넘는 문서나 압축 실패 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("1MB 초과한 파일은 첨부 할 수 없습니다"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ▶️ 첨부 취소
  void _clearFile() {
    setState(() {
      _selectedFilePath = null;
      _selectedFileName = null;
    });
  }

  void _onSubmit() async {
    if (_selectedCategoryKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카테고리를 선택해주세요.')),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final success =
    await ref.read(postWriteControllerProvider.notifier).createPost(
      title: _titleController.text,
      content: _contentController.text,
      category: _selectedCategoryKey!,
      filePath: _selectedFilePath,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시글이 등록되었습니다!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postWriteControllerProvider);
    final isLoading = state.isLoading;
    final categoryAsyncValue = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("글쓰기"),
        actions: [
          TextButton(
            onPressed: isLoading ? null : _onSubmit,
            child: Text(
              "완료",
              style: TextStyle(
                color: isLoading ? Colors.grey : Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 카테고리 드롭다운
            categoryAsyncValue.when(
              loading: () => const LinearProgressIndicator(),
              error: (err, stack) => Text('카테고리 로드 실패: $err'),
              data: (categoriesMap) {
                if (categoriesMap.isEmpty) return const Text("카테고리가 없습니다.");

                if (_selectedCategoryKey == null && categoriesMap.isNotEmpty) {
                  _selectedCategoryKey = categoriesMap.keys.first;
                }

                return DropdownButtonFormField<String>(
                  value: _selectedCategoryKey,
                  decoration: const InputDecoration(
                    labelText: '카테고리',
                    border: OutlineInputBorder(),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: categoriesMap.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (String? newKey) {
                    if (newKey != null) {
                      setState(() => _selectedCategoryKey = newKey);
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // 2. 제목
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 3. 내용
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            // 4. 파일 첨부 영역 (심플해짐)
            const Text(
              "첨부 파일 (선택)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            if (_selectedFilePath == null)
            // 파일 선택 버튼 (하나만 남음)
              SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text("파일 선택"),
                ),
              )
            else
            // 선택된 파일 정보 표시
              Card(
                elevation: 0,
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.insert_drive_file, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedFileName ?? "파일 이름 없음",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: _clearFile,
                        icon: const Icon(Icons.close, color: Colors.red),
                        tooltip: "첨부 취소",
                      ),
                    ],
                  ),
                ),
              ),

            // 로딩 인디케이터
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}