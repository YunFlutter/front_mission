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

  String? _selectedCategory;

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
    if (_selectedCategory == null) {
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
      category: _selectedCategory!,
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
              // 1. 데이터 로딩 중
              loading: () => const LinearProgressIndicator(),

              // 2. 에러 발생
              error: (err, stack) => Text('카테고리 로드 실패: $err'),

              // 3. 데이터 로드 완료
              data: (categories) {
                // 데이터가 왔는데 비어있을 경우 처리
                if (categories.isEmpty) return const Text("카테고리가 없습니다.");

                // 초기값이 설정 안 되어 있다면, 리스트의 첫 번째 항목으로 자동 설정
                if (_selectedCategory == null && categories.isNotEmpty) {
                  // 빌드 중에 setState를 부르면 안 되므로,
                  // post frame callback 혹은 단순히 렌더링 값으로만 처리
                  // 여기서는 렌더링 시 값만 맞춰주고, 실제 변수 할당은 onChanged에서 함
                  _selectedCategory = categories.first;
                }

                return DropdownButtonFormField<String>(
                  value: _selectedCategory, // 현재 선택된 값
                  decoration: const InputDecoration(
                    labelText: '카테고리',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  // 서버에서 받은 리스트로 메뉴 아이템 생성
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedCategory = newValue);
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