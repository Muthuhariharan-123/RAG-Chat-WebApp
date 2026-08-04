import '../models/ask_response.dart';
import '../models/file_item.dart';
import '../models/process_result.dart';
import 'rag_api.dart';

class MockRagApi implements RagApi {
  MockRagApi({this.forceFail = false});

  bool forceFail;

  static const _qaPairs = [
    (
      keywords: ['revenue', 'income', 'earnings'],
      answer:
          'Based on 2023-financial-report.pdf, total revenue for 2023 was '
          '\$1.2M, a 15% increase over the prior year.',
      sources: ['2023-financial-report.pdf'],
    ),
    (
      keywords: ['employee', 'people', 'headcount', 'staff'],
      answer:
          'According to company-overview.pdf, the company has 240 full-time '
          'employees across offices in New York, Berlin, and Tokyo.',
      sources: ['company-overview.pdf'],
    ),
    (
      keywords: ['roadmap', '2024', 'launch', 'next year'],
      answer:
          'Product roadmap states that a mobile companion app and a new '
          'analytics dashboard are planned for release in Q2 2024.',
      sources: ['product-roadmap.pdf'],
    ),
    (
      keywords: ['leave', 'vacation', 'policy', 'handbook'],
      answer:
          'Per employee-handbook.txt, employees receive 25 days of paid '
          'leave per year plus public holidays.',
      sources: ['employee-handbook.txt'],
    ),
  ];

  static const fallbackAnswer =
      'I couldn\'t find relevant information in the uploaded documents. '
      'Try rephrasing your question or upload more documents.';

  static const _delay = Duration(milliseconds: 900);

  @override
  Future<AskResponse> ask(String question) async {
    await Future.delayed(_delay);
    final normalized = question.toLowerCase();
    for (final pair in _qaPairs) {
      if (pair.keywords.any(normalized.contains)) {
        return AskResponse(answer: pair.answer, sources: List.of(pair.sources));
      }
    }
    return const AskResponse(answer: fallbackAnswer);
  }

  @override
  Future<ProcessResult> processFile(FileItem file) async {
    await Future.delayed(_delay);
    if (forceFail) {
      throw Exception('Simulated upload failure (mock debug toggle).');
    }
    return ProcessResult(chunksCreated: 8);
  }
}
