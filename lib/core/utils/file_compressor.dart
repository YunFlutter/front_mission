import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

class FileCompressor {
  /// 파일이 1MB(1024 * 1024 bytes)를 넘는지 확인하고,
  /// 이미지라면 압축을 시도하여 반환합니다.
  /// 이미지 외의 파일이 1MB를 넘으면 에러를 던집니다.
  static Future<File> compressIfNeeded(File file) async {
    final int sizeInBytes = await file.length();
    final double sizeInMb = sizeInBytes / (1024 * 1024);

    // 확장자 확인
    final ext = p.extension(file.path).toLowerCase();
    final isImage = ['.jpg', '.jpeg', '.png', '.heic', '.webp'].contains(ext);

    // 1. 이미지가 아니면서 1MB 넘는 경우 -> 바로 거절
    if (!isImage && sizeInMb > 1.0) {
      throw Exception('문서/기타 파일은 1MB 이하여야 합니다. (현재: ${sizeInMb.toStringAsFixed(2)}MB)');
    }

    // 2. 이미지가 아니거나, 1MB 이하라면 -> 원본 그대로 반환
    if (!isImage || sizeInMb <= 1.0) {
      return file;
    }

    // 3. 이미지이고 1MB가 넘는 경우 -> 압축 시작!
    print("🗜️ 이미지 압축 시작: 원본 ${sizeInMb.toStringAsFixed(2)}MB");

    // 임시 저장 경로 생성 (원본_compressed.jpg)
    final dir = file.parent.path;
    final name = p.basenameWithoutExtension(file.path);
    final targetPath = '$dir/${name}_compressed.jpg';

    // 압축 실행 (해상도 줄이기 & 품질 낮추기)
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70, // 1차 품질: 70%
      minWidth: 1024, // 가로 해상도 최대 1024px로 리사이징
      minHeight: 1024,
    );

    if (result == null) throw Exception("이미지 압축 실패");

    final compressedFile = File(result.path);
    final newSize = await compressedFile.length() / (1024 * 1024);

    print("✅ 압축 완료: ${newSize.toStringAsFixed(2)}MB");

    // 압축했는데도 1MB가 넘으면? (매우 고해상도인 경우)
    if (newSize > 1.0) {
      // 한 번 더 강력하게 압축 (품질 50%)
      var result2 = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 50,
        minWidth: 800,
        minHeight: 800,
      );
      if (result2 != null) return File(result2.path);
    }

    return compressedFile;
  }
}