import 'package:flutter/foundation.dart';

import '../models/file_item.dart';
import '../services/mock_rag_api.dart';
import '../services/rag_api.dart';

class UploadStore extends ChangeNotifier {
  UploadStore(this._api);

  final RagApi _api;

  static const int maxFiles = 10;
  static const Set<String> allowedExtensions = {'txt', 'pdf'};

  final List<FileItem> _files = [];

  List<FileItem> get files => List.unmodifiable(_files);

  bool get hasFiles => _files.isNotEmpty;

  bool get isFull => _files.length >= maxFiles;

  bool get isBusy => _files.any(
        (f) =>
            f.status == FileUploadStatus.uploading ||
            f.status == FileUploadStatus.processing,
      );

  bool get supportsMockFailureToggle => _api is MockRagApi;

  void addFiles(List<FileItem> newFiles) {
    for (final file in newFiles) {
      if (_files.length >= maxFiles) {
        break;
      }
      _files.add(file);
      _processOne(file);
    }
    notifyListeners();
  }

  Future<void> _processOne(FileItem file) async {
    file.status = FileUploadStatus.uploading;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 350));
    file.status = FileUploadStatus.processing;
    notifyListeners();
    try {
      await _api.processFile(file);
      file.status = FileUploadStatus.processed;
      file.errorMessage = null;
    } catch (e) {
      file.status = FileUploadStatus.failed;
      file.errorMessage = e.toString();
    }
    notifyListeners();
  }

  void removeFile(FileItem file) {
    _files.remove(file);
    notifyListeners();
  }

  void clear() {
    _files.clear();
    notifyListeners();
  }

  void setMockForceFail(bool value) {
    final api = _api;
    if (api is MockRagApi) {
      api.forceFail = value;
    }
  }
}
