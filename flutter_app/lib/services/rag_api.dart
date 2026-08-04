import '../models/ask_response.dart';
import '../models/file_item.dart';
import '../models/process_result.dart';

abstract class RagApi {
  Future<AskResponse> ask(String question);

  Future<ProcessResult> processFile(FileItem file);
}
