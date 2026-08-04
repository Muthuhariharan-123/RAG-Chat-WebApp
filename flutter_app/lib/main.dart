import 'package:flutter/material.dart';

import 'change_notifiers/upload_store.dart';
import 'screens/home_screen.dart';
import 'services/mock_rag_api.dart';
import 'services/rag_api.dart';
import 'services/supabase_rag_api.dart';
import 'services/supabase_service.dart';

const bool useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);
const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  RagApi api;
  if (useMock) {
    api = MockRagApi();
  } else {
    SupabaseService.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    api = SupabaseRagApi(SupabaseService.client);
  }

  runApp(RagChatApp(api: api));
}

class RagChatApp extends StatelessWidget {
  const RagChatApp({super.key, required this.api});

  final RagApi api;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'RAG Chat WebApp',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      home: HomeScreen(api: api, store: UploadStore(api)),
    );
  }
}
