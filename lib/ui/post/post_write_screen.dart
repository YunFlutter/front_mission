import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_mission/provider/category_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'post_write_controller.dart';

class PostWriteScreen extends ConsumerStatefulWidget {
  const PostWriteScreen({super.key});

  @override
  ConsumerState<PostWriteScreen> createState() => _PostWriteScreenState();
}

class _PostWriteScreenState extends ConsumerState<PostWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String? _selectedCategoryKey;

  // 파일 관련 변수
  String? _selectedFilePath;
  String? _selectedFileName;
  bool _isImage = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // 1. 갤러리 선택
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedFilePath = image.path;
          _selectedFileName = image.name;
          _isImage = true;
        });
      }
    } catch (e) {
      debugPrint('이미지 선택 실패: $e');
    }
  }

  // 2. 파일 선택
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _selectedFilePath = file.path;
          _selectedFileName = file.name;
          final ext = file.extension?.toLowerCase();
          _isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
        });
      }
    } catch (e) {
      debugPrint('파일 선택 실패: $e');
    }
  }

  // 3. 파일 취소
  void _clearFile() {
    setState(() {
      _selectedFilePath = null;
      _selectedFileName = null;
      _isImage = false;
    });
  }

  void _onSubmit() async {

    // 유효성 검사: 카테고리가 로딩되지 않았거나 선택되지 않았을 때
    if (_selectedCategoryKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카테고리를 선택해주세요.')),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final success = await ref.read(postWriteControllerProvider.notifier).createPost(
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

    ref.listen(postWriteControllerProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('등록 실패: ${next.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("글쓰기"),
        actions: [
          TextButton(
            onPressed: isLoading ? null : _onSubmit,
            child: Text("완료", style: TextStyle(color: isLoading ? Colors.grey : Colors.blue, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            categoryAsyncValue.when(
              loading: () => const LinearProgressIndicator(),
              error: (err, stack) => Text('카테고리 로드 실패: $err'),
              data: (categoriesMap) {
                if (categoriesMap.isEmpty) return const Text("카테고리가 없습니다.");

                // 초기값 설정: 맵의 첫 번째 Key로 설정
                if (_selectedCategoryKey == null && categoriesMap.isNotEmpty) {
                  _selectedCategoryKey = categoriesMap.keys.first;
                }

                return DropdownButtonFormField<String>(
                  value: _selectedCategoryKey, // 현재 선택된 Key
                  decoration: const InputDecoration(
                    labelText: '카테고리',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  // Map을 순회하며 DropdownItem 생성
                  items: categoriesMap.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key, // 저장될 값: "NOTICE"
                      child: Text(entry.value), // 보여질 값: "공지"
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
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '제목', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: const InputDecoration(labelText: '내용', border: OutlineInputBorder(), alignLabelWithHint: true),
            ),
            const SizedBox(height: 16),
            const Text("첨부 파일 (선택)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            if (_selectedFilePath == null)
              Row(
                children: [
                  Expanded(child: OutlinedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.photo), label: const Text("사진 앨범"))),
                  const SizedBox(width: 8),
                  Expanded(child: OutlinedButton.icon(onPressed: _pickFile, icon: const Icon(Icons.attach_file), label: const Text("파일 선택"))),
                ],
              )
            else
              Card(
                color: Colors.grey[100],
                child: ListTile(
                  leading: Icon(_isImage ? Icons.image : Icons.insert_drive_file),
                  title: Text(_selectedFileName ?? ""),
                  trailing: IconButton(onPressed: _clearFile, icon: const Icon(Icons.close, color: Colors.red)),
                ),
              ),

            if (_selectedFilePath != null && _isImage) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(_selectedFilePath!), height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
            ],

            if (isLoading) const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}