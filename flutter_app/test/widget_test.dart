import 'package:flutter_test/flutter_test.dart';

import 'package:rag_chat_webapp/main.dart';
import 'package:rag_chat_webapp/services/mock_rag_api.dart';

void main() {
  testWidgets('app boots and shows both navigation tabs', (tester) async {
    await tester.pumpWidget(RagChatApp(api: MockRagApi()));

    expect(find.text('RAG Chat WebApp'), findsOneWidget);
    expect(find.text('Upload'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
  });
}
