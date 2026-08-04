import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/ask_response.dart';
import '../models/file_item.dart';
import '../models/process_result.dart';
import 'rag_api.dart';

class RagApiException implements Exception {
  RagApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class SupabaseRagApi implements RagApi {
  SupabaseRagApi(this._client);

  final SupabaseClient _client;

  static const _uploadsBucket = 'uploads';

  @override
  Future<AskResponse> ask(String question) async {
    final response = await _client.functions.invoke(
      'ask-question',
      body: {'question': question},
    );
    if (response.status >= 400 || response.data == null) {
      throw RagApiException('ask-question failed (HTTP ${response.status}).');
    }
    return AskResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<ProcessResult> processFile(FileItem file) async {
    final storagePath =
        '${DateTime.now().microsecondsSinceEpoch}-${file.name}';
    try {
      await _client.storage
          .from(_uploadsBucket)
          .uploadBinary(storagePath, file.bytes);
    } catch (e) {
      throw RagApiException('Upload to storage failed: $e');
    }
    final response = await _client.functions.invoke(
      'process-file',
      body: {
        'fileName': file.name,
        'storagePath': storagePath,
      },
    );
    if (response.status >= 400 || response.data == null) {
      throw RagApiException('process-file failed (HTTP ${response.status}).');
    }
    return ProcessResult.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
