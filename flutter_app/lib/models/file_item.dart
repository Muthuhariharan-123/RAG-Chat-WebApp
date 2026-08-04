import 'dart:typed_data';

enum FileUploadStatus { queued, uploading, processing, processed, failed }

class FileItem {
  FileItem({
    required this.name,
    required this.bytes,
    this.status = FileUploadStatus.queued,
    this.errorMessage,
  });

  final String name;
  final Uint8List bytes;
  FileUploadStatus status;
  String? errorMessage;
}
