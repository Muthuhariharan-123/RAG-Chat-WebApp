import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static SupabaseClient? _client;

  static SupabaseClient get client {
    final client = _client;
    if (client == null) {
      throw StateError(
        'Supabase client not initialized. Provide SUPABASE_URL and '
        'SUPABASE_ANON_KEY via --dart-define.',
      );
    }
    return client;
  }

  static void initialize({required String url, required String anonKey}) {
    if (url.isEmpty || anonKey.isEmpty) {
      throw ArgumentError(
        'Missing Supabase credentials. Run with '
        '--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
      );
    }
    _client = SupabaseClient(url, anonKey);
  }
}
