import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:rag_chat_webapp/models/file_item.dart';
import 'package:rag_chat_webapp/services/mock_rag_api.dart';

void main() {
  final api = MockRagApi();

  FileItem file(String name) =>
      FileItem(name: name, bytes: Uint8List.fromList([1, 2, 3]));

  test('canned question returns grounded answer with source', () async {
    final res = await api.ask('What was the revenue in 2023?');
    expect(res.answer, contains(r'$1.2M'));
    expect(res.sources, contains('2023-financial-report.pdf'));
  });

  test('unknown question returns fallback answer', () async {
    final res = await api.ask('What is the capital of France?');
    expect(res.answer, MockRagApi.fallbackAnswer);
    expect(res.sources, isEmpty);
  });

  test('processFile succeeds by default', () async {
    final res = await api.processFile(file('notes.txt'));
    expect(res.chunksCreated, greaterThan(0));
  });

  test('processFile throws when forceFail is enabled', () async {
    final failing = MockRagApi(forceFail: true);
    expect(() => failing.processFile(file('notes.txt')), throwsException);
  });
}
